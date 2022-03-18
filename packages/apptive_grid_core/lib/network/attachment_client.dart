part of apptive_grid_client;

class AttachmentProcessor {
  AttachmentProcessor(
    this.options,
    this.authenticator, {
    http.Client? httpClient,
  }) : _client = httpClient ?? http.Client();

  final http.Client _client;
  final ApptiveGridOptions options;
  final ApptiveGridAuthenticator authenticator;
  AttachmentConfiguration? _config;
  static const _uuid = Uuid();

  Future<AttachmentConfiguration> get configuration async {
    if (_config == null) {
      final serverResponse = (await _client
          .get(Uri.parse('${options.environment.url}/config.json'))
          .catchError((error) => http.Response('{}', 400)));
      final serverAttachments = jsonDecode(serverResponse.body)['attachments'];

      final newConfiguration = serverAttachments != null
          ? AttachmentConfiguration.fromJson(serverAttachments)
          : options.attachmentConfigurations[options.environment];
      if (newConfiguration == null) {
        throw Exception(
            'Attachment is null. If there is no internet connection you should provide attachment Configurations through `ApptiveGridOptions.options.attachmentConfigs`');
      } else {
        _config = newConfiguration;
      }
    }
    return _config!;
  }

  Future<Attachment> createAttachment(String name) async {
    final type = lookupMimeType(name) ?? '';
    final config = await configuration;

    final url = _generateUri(config);

    Uri? smallThumbnail;
    Uri? largeThumbnail;

    if (type.startsWith('image/')) {
      smallThumbnail = _generateUri(config);
      largeThumbnail = _generateUri(config);
    }
    final attachment = Attachment(
      name: name,
      url: url,
      type: type,
      smallThumbnail: smallThumbnail,
      largeThumbnail: largeThumbnail,
    );
    return attachment;
  }

  Uri _generateUri(AttachmentConfiguration configuration) {
    final id = _uuid.v4();

    final baseUri = Uri.parse(configuration.attachmentApiEndpoint);
    return baseUri.replace(
      path: '${baseUri.path}/$id',
    );
  }

  Future<http.Response> uploadAttachment(
    AddAttachmentAction attachmentAction,
  ) async {
    final config = await configuration;
    final authenticated = (await authenticator.isAuthenticated) ||
        config.signedUrlFormApiEndpoint == null;

    if (authenticated) {
      await authenticator.checkAuthentication();
    }

    final baseUploadUri = Uri.parse(
      authenticated
          ? config.signedUrlApiEndpoint
          : config.signedUrlFormApiEndpoint!,
    );
    final uploadHeaders = authenticated
        ? {
            HttpHeaders.authorizationHeader: authenticator.header!,
          }
        : <String, String>{};

    if (attachmentAction.attachment.type.startsWith('image')) {
      final type = attachmentAction.attachment.type;
      final uploads = await Future.wait<http.Response>(
        [
          _uploadFile(
            baseUri: baseUploadUri,
            headers: uploadHeaders,
            bytes: await _scaleImageToMaxSize(
              originalImage: attachmentAction.byteData!,
              size: 1000,
              type: type,
            ),
            name: attachmentAction.attachment.url.pathSegments.last,
            type: type,
          ),
          if (attachmentAction.attachment.largeThumbnail != null)
            _uploadFile(
              baseUri: baseUploadUri,
              headers: uploadHeaders,
              bytes: await _scaleImageToMaxSize(
                originalImage: attachmentAction.byteData!,
                size: 256,
                type: type,
              ),
              name:
                  attachmentAction.attachment.largeThumbnail!.pathSegments.last,
              type: type,
            ),
          if (attachmentAction.attachment.smallThumbnail != null)
            _uploadFile(
              baseUri: baseUploadUri,
              headers: uploadHeaders,
              bytes: await _scaleImageToMaxSize(
                originalImage: attachmentAction.byteData!,
                size: 64,
                type: type,
              ),
              name:
                  attachmentAction.attachment.smallThumbnail!.pathSegments.last,
              type: type,
            ),
        ],
      );
      return uploads.first;
    } else {
      return _uploadFile(
        baseUri: baseUploadUri,
        headers: uploadHeaders,
        bytes: attachmentAction.byteData!,
        name: attachmentAction.attachment.url.pathSegments.last,
        type: attachmentAction.attachment.type,
      );
    }
  }

  Future<http.Response> _uploadFile({
    required Uri baseUri,
    required Map<String, String> headers,
    required Uint8List bytes,
    required String name,
    required String type,
  }) async {
    final uri = baseUri.replace(
      queryParameters: {
        'fileName': name,
        'fileType': type,
      },
    );

    final uploadUrlResponse = await _client.get(uri, headers: headers);

    if (uploadUrlResponse.statusCode >= 400) {
      throw uploadUrlResponse;
    }

    final uploadUrl = Uri.parse(
      jsonDecode(uploadUrlResponse.body)['uploadURL'],
    );

    final putResponse = await _client.put(
      uploadUrl,
      headers: {
        HttpHeaders.contentTypeHeader: type,
      },
      body: bytes,
    );

    if (putResponse.statusCode >= 400) {
      throw putResponse;
    } else {
      return putResponse;
    }
  }

  Future<Uint8List> _scaleImageToMaxSize({
    required Uint8List originalImage,
    required int size,
    required String type,
  }) async {
    final resizeData = originalImage;
    final image = img.decodeImage(resizeData)!;
    if (math.max(image.width, image.height) <= size) {
      return originalImage;
    }

    final isPortrait = image.width < image.height;
    final widthFactor = isPortrait ? image.width / image.height : 1.0;
    final heightFactor = isPortrait ? 1.0 : image.height / image.width;

    final resized = img.copyResize(
      image,
      width: (size * widthFactor).toInt(),
      height: (size * heightFactor).toInt(),
      interpolation: img.Interpolation.average,
    );
    return Uint8List.fromList(
      img.encodeNamedImage(
        resized,
        'name.${type.split('/').last}',
      )!,
    );
  }
}
