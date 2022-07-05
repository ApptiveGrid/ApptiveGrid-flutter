part of apptive_grid_client;

/// Processor for Attachments.
/// Handles uploading attachments, creating attachments, scaling images
class AttachmentProcessor {
  /// Creates a new AttachmentProcessor
  ///
  /// [options] is used to get the current stage to try to fetch server config for attachments
  /// As a fallback [AttachmentConfig] provided through [ApptiveGridOptions.attachmentConfigurations] is used
  ///
  /// If the user is authenticated in [authenticator] then the authenticated endpoint is used and an authorization is triggered
  AttachmentProcessor(
    this.options,
    this.authenticator, {
    http.Client? httpClient,
  }) : _client = httpClient ?? http.Client(); // coverage:ignore-line

  final http.Client _client;

  /// [options] is used to get the current stage to try to fetch server config for attachments
  /// As a fallback [AttachmentConfig] provided through [ApptiveGridOptions.attachmentConfigurations] is used
  final ApptiveGridOptions options;

  /// Authenticator to handle authentication to upload attachments
  final ApptiveGridAuthenticator authenticator;
  AttachmentConfiguration? _config;
  static const _uuid = Uuid();

  /// Returns the current configuration
  /// It tries to fetch the attachment configuration on the server determined by [ApptiveGridOptions.environment] from [options]
  /// if that fails or there are no options it fallbacks to [ApptiveGridOptions.attachmentConfigurations] from [options]
  /// if that is also `null` for the current environment an [Exception] is thrown
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
          'Attachment is null. If there is no internet connection you should provide attachment Configurations through `ApptiveGridOptions.options.attachmentConfigs`',
        );
      } else {
        _config = newConfiguration;
      }
    }
    return _config!;
  }

  /// Creates a new [Attachment] based on [name]
  /// The [Attachment.type] is the mime determined by the ending of [name] through [lookupMimeType]
  /// If the Attachment is an image (type starts with `image/`) it will generate a new [Attachment] with thumbnail urls
  /// If the Attachment is not an image, [Attachment.smallThumbnail] and [Attachment.largeThunbnail] will be `null`
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

  /// Perform an [attachmentAction] to upload [AttachmentAction.byteData] for [AttachmentAction.attachment]
  ///
  /// [headers] will be added in addition to the default headers
  ///
  /// If the attachment is an image (see createAttachment) it will upload a scaled version of the original (max Side 1000px) and tries to upload thumbnails (256px and 64px)
  /// If uploading one or more of the thumnbnails fails the upload will still be handled as success as long as the main file did upload successfully
  ///
  /// If the attachment is not an imge the file will be uploaded without any alterations
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
    var uploadHeaders = <String, String>{};
    if (authenticated) {
      uploadHeaders[HttpHeaders.authorizationHeader] = authenticator.header!;
    }

    if (attachmentAction.attachment.type.startsWith('image')) {
      final type = attachmentAction.attachment.type;
      http.Response? mainUpload;

      final resizeId = _uuid.v4();
      final imagePaths = await scaleImageToMaxSize(
        sizes: [1000, 256, 64],
        type: type,
        id: resizeId,
        originalImageBytes: attachmentAction.byteData,
        path: attachmentAction.path,
      );

      if (imagePaths != null) {
        final uploads = await Future.wait<http.Response>(
          [
            _uploadFile(
              baseUri: baseUploadUri,
              headers: uploadHeaders,
              createBytes: () => File(imagePaths[0]).readAsBytes(),
              name: attachmentAction.attachment.url.pathSegments.last,
              type: type,
            ).then((response) {
              mainUpload = response;
              return response;
            }),
            if (attachmentAction.attachment.largeThumbnail != null)
              _uploadFile(
                baseUri: baseUploadUri,
                headers: uploadHeaders,
                createBytes: () => File(imagePaths[1]).readAsBytes(),
                name: attachmentAction
                    .attachment.largeThumbnail!.pathSegments.last,
                type: type,
              ).catchError((error) {
                debugPrint('Could not upload large thumbnail');
                debugPrint(error);
                return http.Response('', 200); // coverage:ignore-line
              }),
            if (attachmentAction.attachment.smallThumbnail != null)
              _uploadFile(
                baseUri: baseUploadUri,
                headers: uploadHeaders,
                createBytes: () => File(imagePaths[2]).readAsBytes(),
                name: attachmentAction
                    .attachment.smallThumbnail!.pathSegments.last,
                type: type,
              ).catchError((error) {
                debugPrint('Could not upload small thumbnail');
                debugPrint(error);
                return http.Response('', 200); // coverage:ignore-line
              }),
          ],
        ).catchError((error) {
          if (mainUpload != null) {
            return [mainUpload!];
          } else {
            throw error;
          }
        });
        return uploads.first;
      } else {
        return _uploadFile(
          baseUri: baseUploadUri,
          headers: uploadHeaders,
          createBytes: () async =>
              attachmentAction.byteData ??
              await File(attachmentAction.path!).readAsBytes(),
          name: attachmentAction.attachment.url.pathSegments.last,
          type: attachmentAction.attachment.type,
        );
      }
    } else {
      return _uploadFile(
        baseUri: baseUploadUri,
        headers: uploadHeaders,
        createBytes: () async =>
            attachmentAction.byteData ??
            await File(attachmentAction.path!).readAsBytes(),
        name: attachmentAction.attachment.url.pathSegments.last,
        type: attachmentAction.attachment.type,
      );
    }
  }

  Future<http.Response> _uploadFile({
    required Uri baseUri,
    required Map<String, String> headers,
    required Future<Uint8List> Function() createBytes,
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

    final bodyBytes = await createBytes();

    final putResponse = await _client.put(
      uploadUrl,
      headers: {
        HttpHeaders.contentTypeHeader: type,
      },
      body: bodyBytes,
    );

    if (putResponse.statusCode >= 400) {
      throw putResponse;
    } else {
      return putResponse;
    }
  }

  /// Scales down [originalImage] so that the largest size will be [size] pixels while keeping the aspect ratio
  /// [type] should be the mime type of the image. It is used to determine the file format when scaling
  Future<List<String>?> scaleImageToMaxSize({
    String? path,
    Uint8List? originalImageBytes,
    required List<int> sizes,
    required String type,
    required String id,
  }) async {
    final port = ReceivePort();
    await Isolate.spawn(_scaleImageWorker, {
      'port': port.sendPort,
      'filePath': path,
      'bytes': originalImageBytes,
      'sizes': sizes,
      'type': type,
      'id': id,
    });

    return await port.first as List<String>?;
  }

  static Future<void> _scaleImageWorker(Map<String, dynamic> args) async {
    final port = args['port'] as SendPort;
    final byteData = args['bytes'] as Uint8List? ??
        await File(args['filePath'] as String).readAsBytes();
    final sizes = args['sizes'] as List<int>;
    final type = (args['type'] as String).split('/').last;
    final id = args['id'] as String;
    final directory = Directory.systemTemp;

    final image = img.decodeImage(byteData);
    if (image == null) {
      Isolate.exit(port, null);
    }
    final maxSize = math.max(image.width, image.height);
    final isPortrait = image.width < image.height;
    final widthFactor = isPortrait ? image.width / image.height : 1.0;
    final heightFactor = isPortrait ? 1.0 : image.height / image.width;

    final outputs = <String>[];
    for (final size in sizes) {
      late final List<int> output;
      if (size < maxSize) {
        final resized = img.copyResize(
          image,
          width: (size * widthFactor).toInt(),
          height: (size * heightFactor).toInt(),
          interpolation: img.Interpolation.average,
        );
        output = img.encodeNamedImage(
          resized,
          '.$type',
        )!;
      } else {
        output = byteData;
      }
      // Save File and add path to outputs
      final file = File(
        '${directory.path}/$id/${size}px.$type',
      );
      final exists = await file.exists();
      if (!exists) {
        await file.create(recursive: true);
      }
      await file.writeAsBytes(output);
      outputs.add(file.path);
    }

    Isolate.exit(port, outputs);
  }
}
