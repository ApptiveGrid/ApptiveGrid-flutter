import 'dart:async';
import 'dart:convert';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_core/src/network/attachment_processor.dart';
import 'package:apptive_grid_core/src/network/authentication/apptive_grid_authenticator.dart';
import 'package:apptive_grid_core/src/network/constants.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client.dart';

/// Api Client to communicate with the ApptiveGrid Backend
class ApptiveGridClient extends ChangeNotifier {
  /// Creates an ApiClient
  ApptiveGridClient({
    ApptiveGridOptions options = const ApptiveGridOptions(),
    http.Client? httpClient,
    ApptiveGridAuthenticator? authenticator,
  })  : _options = options,
        _client = httpClient ?? http.Client() {
    this.authenticator = authenticator ??
        ApptiveGridAuthenticator(
          client: this,
          httpClient: _client,
          onAuthenticationChanged: _authenticationChanged,
        );
    _attachmentProcessor =
        AttachmentProcessor(options, this.authenticator, httpClient: _client);
  }

  /// Configurations
  ApptiveGridOptions _options;

  /// Returns the [ApptiveGridOptions] for the current Client
  ApptiveGridOptions get options => _options;

  /// Updates the [options]
  Future<void> setOptions(ApptiveGridOptions options) async {
    // Keep old environment as change is handled in [updateEnvironment]
    _options = options.copyWith(environment: _options.environment);
    await updateEnvironment(options.environment);
  }

  /// The authenticator used to authenticate requests
  late final ApptiveGridAuthenticator authenticator;

  final http.Client _client;

  /// The underlying http client
  http.Client get httpClient => _client;

  late AttachmentProcessor _attachmentProcessor;

  /// Processor for Attachments.
  /// Handles uploading attachments, creating attachments, scaling images
  AttachmentProcessor get attachmentProcessor => _attachmentProcessor;

  /// Close the connection on the httpClient
  @override
  void dispose() {
    _client.close();
    authenticator.dispose();
    super.dispose();
  }

  /// Headers that are used for multiple Calls
  Map<String, String> get defaultHeaders => (<String, String?>{
        HttpHeaders.authorizationHeader: authenticator.header,
        HttpHeaders.contentTypeHeader: ContentType.json,
      }..removeWhere((key, value) => value == null))
          .map((key, value) => MapEntry(key, value!));

  Map<String, String> _createHeadersWithDefaults(
    Map<String, String> customHeader, [
    ApptiveGridHalVersion? halVersion,
  ]) {
    return {
      ...defaultHeaders,
      if (halVersion != null) ...Map.fromEntries([halVersion.header]),
      ...customHeader,
    };
  }

  Uri _generateApptiveGridUri(Uri baseUri) {
    return baseUri.replace(
      scheme: 'https',
      host: Uri.parse(options.environment.url).host,
    );
  }

  /// Loads a [FormData] represented by [formUri]
  ///
  /// [headers] will be added in addition to [ApptiveGridClient.defaultHeaders]
  ///
  /// Based on [formUri] this might require Authentication
  /// throws [Response] if the request fails
  Future<FormData> loadForm({
    required Uri uri,
    Map<String, String> headers = const {},
    bool isRetry = false,
  }) async {
    final url = _generateApptiveGridUri(uri);
    final sanitizedUrl =
        url.replace(path: url.path.replaceAll(RegExp('/r/'), '/a/'));
    final response = await _client.get(
      sanitizedUrl,
      headers: _createHeadersWithDefaults(headers),
    );
    if (response.statusCode >= 400) {
      if (response.statusCode == 401 && !isRetry) {
        await authenticator.checkAuthentication();
        return loadForm(
          uri: uri,
          headers: headers,
          isRetry: true,
        );
      } else {
        throw response;
      }
    }
    return FormData.fromJson(json.decode(response.body));
  }

  /// Submits [formData] against [link]
  ///
  /// [headers] will be added in addition to [ApptiveGridClient.defaultHeaders]
  ///
  /// This will return a Stream of [SubmitFormProgressEvent]s to indicate the current step of the submission
  Stream<SubmitFormProgressEvent> submitFormWithProgress(
    ApptiveLink link,
    FormData formData, {
    bool saveToPendingItems = true,
    Map<String, String> headers = const {},
  }) async* {
    final actionItem = ActionItem(link: link, data: formData);

    final controller = StreamController<SubmitFormProgressEvent>();

    _performAttachmentActions(
      formData.attachmentActions,
      fromForm: true,
      headers: headers,
      statusController: controller,
    );

    SubmitFormProgressEvent? attachmentActions;
    yield* controller.stream.map((event) {
      if (event is AttachmentCompleteProgressEvent ||
          event is ErrorProgressEvent) {
        attachmentActions ??= event;
      }
      return event;
    }).handleError((error) async {
      if (error is http.Response) {
        attachmentActions ??= AttachmentCompleteProgressEvent(error);
      } else {
        attachmentActions ??= ErrorProgressEvent(error);
      }
    });

    if ((attachmentActions is ErrorProgressEvent) ||
        (attachmentActions is AttachmentCompleteProgressEvent &&
            ((attachmentActions as AttachmentCompleteProgressEvent)
                        .response
                        ?.statusCode ??
                    400) >=
                400)) {
      late final dynamic error;
      if (attachmentActions is ErrorProgressEvent) {
        error = (attachmentActions as ErrorProgressEvent).error;
      } else {
        error = (attachmentActions as AttachmentCompleteProgressEvent).response;
      }
      if (saveToPendingItems && error != null) {
        yield SubmitCompleteProgressEvent(
          await _handleActionError(
            error,
            actionItem: actionItem,
            saveToPendingItems: saveToPendingItems,
          ),
        );
      } else {
        yield ErrorProgressEvent(error);
      }

      controller.close();
      return;
    }

    yield UploadFormProgressEvent(formData);
    late http.Response? response;
    try {
      response = await performApptiveLink<http.Response>(
        link: link,
        body: formData.toRequestObject(),
        headers: headers,
        parseResponse: (response) async => response,
      );
    } catch (error) {
      // Catch all Exception for compatibility Reasons between Web and non Web Apps

      if (saveToPendingItems) {
        yield SubmitCompleteProgressEvent(
          await _handleActionError(
            error,
            actionItem: actionItem,
            saveToPendingItems: saveToPendingItems,
          ),
        );
      } else {
        yield ErrorProgressEvent(error);
      }
      return;
    }
    if (response != null && response.statusCode < 400) {
      // Action was performed successfully. Remove it from pending Actions
      await options.cache?.removePendingActionItem(actionItem);
    }
    yield SubmitCompleteProgressEvent(response);
  }

  /// Submits [formData] against [link]
  ///
  /// [headers] will be added in addition to [ApptiveGridClient.defaultHeaders]
  ///
  /// if this returns a [http.Response] with a [http.Response.statusCode] >= 400 it means that the Item was saved in [options.cache]
  /// throws [Response] if the request fails
  Future<http.Response?> submitForm(
    ApptiveLink link,
    FormData formData, {
    bool saveToPendingItems = true,
    Map<String, String> headers = const {},
  }) async {
    final eventWithResponse = await submitFormWithProgress(
      link,
      formData,
      saveToPendingItems: false, // Saving is handled below
      headers: headers,
    )
        .firstWhere(
      (element) =>
          element is SubmitCompleteProgressEvent ||
          element is ErrorProgressEvent,
    )
        .catchError((error) {
      throw error;
    });

    if (eventWithResponse is SubmitCompleteProgressEvent) {
      return eventWithResponse.response;
    } else if (eventWithResponse is ErrorProgressEvent) {
      final error = eventWithResponse.error;
      return _handleActionError(
        error,
        actionItem: ActionItem(link: link, data: formData),
        saveToPendingItems: saveToPendingItems,
      );
    } else {
      return null;
    }
  }

  Future<http.Response?> _handleActionError(
    Object error, {
    required ActionItem actionItem,
    required bool saveToPendingItems,
  }) async {
    // TODO: Filter out Errors that happened because the Input was not correct
    // in that case don't save the Action and throw the error
    if (saveToPendingItems && options.cache != null) {
      await options.cache!.addPendingActionItem(actionItem);
      if (error is http.Response) {
        return error;
      } else {
        return http.Response(error.toString(), 400);
      }
    }
    throw error;
  }

  Future<http.Response> _performAttachmentActions(
    Map<Attachment, AttachmentAction> actions, {
    bool fromForm = false,
    Map<String, String> headers = const {},
    StreamController<SubmitFormProgressEvent>? statusController,
  }) async {
    try {
      for (final chunkedActions in actions.values.slices(2)) {
        await Future.wait(
          chunkedActions.map(
            (action) => switch (action) {
              AddAttachmentAction() =>
                _attachmentProcessor.uploadAttachment(action).then((response) {
                  statusController?.add(
                    ProcessedAttachmentProgressEvent(
                      action.attachment,
                    ),
                  );
                  return response;
                }).catchError((error) {
                  throw error;
                }),
              DeleteAttachmentAction() => Future.value().then((response) {
                  statusController?.add(
                    ProcessedAttachmentProgressEvent(action.attachment),
                  );
                  return response;
                }),
              RenameAttachmentAction() => Future.value().then((response) {
                  statusController?.add(
                    ProcessedAttachmentProgressEvent(action.attachment),
                  );
                  return response;
                })
            },
          ),
        );
      }
      final response = http.Response('AttachmentActionSuccess', 200);
      statusController?.add(AttachmentCompleteProgressEvent(response));
      statusController?.close();
      return response;
    } catch (error) {
      statusController?.addError(error);
      statusController?.close();
      final response = http.Response('AttachmentActionError', 400);
      return response;
    }
  }

  /// Loads a [Grid] represented by [gridUri]
  ///
  /// [sorting] defines the order in which items will be returned
  /// The order of [ApptiveGridSorting] in [sorting] will rank the order in which values should be sorted
  /// [headers] will be added in addition to [ApptiveGridClient.defaultHeaders]
  ///
  /// If [loadEntities] is `true` and there is a [ApptiveLinkType.entities] Link it will also fetch the entities
  /// Requires Authorization
  /// throws [Response] if the request fails
  Future<Grid> loadGrid({
    required Uri uri,
    List<ApptiveGridSorting>? sorting,
    ApptiveGridFilter? filter,
    bool isRetry = false,
    Map<String, String> headers = const {},
    bool loadEntities = true,
  }) async {
    final gridViewUrl = _generateApptiveGridUri(uri);

    final gridHeaders = _createHeadersWithDefaults(headers);
    gridHeaders.addEntries([ApptiveGridHalVersion.v2.header]);
    final gridViewResponse =
        await _client.get(gridViewUrl, headers: gridHeaders);
    if (gridViewResponse.statusCode >= 400) {
      if (gridViewResponse.statusCode == 401 && !isRetry) {
        await authenticator.checkAuthentication();
        return loadGrid(
          uri: uri,
          sorting: sorting,
          filter: filter,
          isRetry: true,
        );
      }
      throw gridViewResponse;
    }

    final gridToParse = jsonDecode(gridViewResponse.body);
    final grid = Grid.fromJson(gridToParse);
    if (loadEntities && grid.links.containsKey(ApptiveLinkType.entities)) {
      final entitiesResponse = await this.loadEntities(
        uri: grid.links[ApptiveLinkType.entities]!.uri,
        layout: ApptiveGridLayout.indexed,
        filter: filter,
        sorting: sorting,
      );

      final entities = entitiesResponse.items;

      gridToParse['entities'] = entities;
      return Grid.fromJson(gridToParse);
    } else {
      return grid;
    }
  }

  /// Load Entities of a Grid that are accessed by [uri]
  /// the layout in which the entities will be returned is determined by [layout]
  ///
  /// [sorting] allows to apply custom sorting
  /// [filter] allows to get custom filters
  /// [headers] will be added in addition to [ApptiveGridClient.defaultHeaders]
  /// [halVersion] describes what Hal Version of ApptiveGrid should be used. This can effect the format and features of the response and might break parsing.
  /// [pageIndex] is the index of the page to be loaded.
  /// [pageSize] is the requested item count in the loaded page.
  /// Paging currently requireds the header to contain `'accept': 'application/vnd.apptivegrid.hal'`.
  Future<EntitiesResponse<T>> loadEntities<T>({
    required Uri uri,
    ApptiveGridLayout layout = ApptiveGridLayout.field,
    List<ApptiveGridSorting>? sorting,
    ApptiveGridFilter? filter,
    bool isRetry = false,
    Map<String, String> headers = const {},
    ApptiveGridHalVersion? halVersion,
    int? pageIndex,
    int? pageSize,
  }) async {
    final baseUrl = Uri.parse(options.environment.url);
    final requestUri = uri.replace(
      scheme: baseUrl.scheme,
      host: baseUrl.host,
      queryParameters: {
        'layout': layout.queryParameter,
        if (sorting != null)
          'sorting':
              jsonEncode(sorting.map((e) => e.toRequestObject()).toList()),
        if (filter != null) 'filter': jsonEncode(filter.toJson()),
        if (pageIndex != null) 'pageIndex': '$pageIndex',
        if (pageSize != null) 'pageSize': '$pageSize',
        ...uri.queryParameters,
      },
    );

    final response = await _client.get(
      requestUri,
      headers: _createHeadersWithDefaults(headers, halVersion),
    );

    if (response.statusCode >= 400) {
      if (response.statusCode == 401 && !isRetry) {
        await authenticator.checkAuthentication();
        return loadEntities<T>(
          uri: uri,
          layout: layout,
          sorting: sorting,
          filter: filter,
          isRetry: true,
          headers: headers,
          pageIndex: pageIndex,
          pageSize: pageSize,
          halVersion: halVersion,
        );
      }
      throw response;
    }

    return EntitiesResponse<T>.fromJson(jsonDecode(response.body));
  }

  /// Get the [User] that is authenticated
  ///
  /// [headers] will be added in addition to [ApptiveGridClient.defaultHeaders]
  ///
  /// Requires Authorization
  /// throws [Response] if the request fails
  Future<User> getMe({
    Map<String, String> headers = const {},
  }) async {
    // Always check for authentication here
    // as there is no way of loading the currently logged in user without being logged in
    await authenticator.checkAuthentication();

    final url = Uri.parse('${options.environment.url}/api/users/me');
    final response =
        await _client.get(url, headers: _createHeadersWithDefaults(headers));
    if (response.statusCode >= 400) {
      throw response;
    }
    return User.fromJson(json.decode(response.body));
  }

  /// Get the [Space] represented by [spaceUri]
  ///
  /// [headers] will be added in addition to [ApptiveGridClient.defaultHeaders]
  ///
  /// Requires Authorization
  /// throws [Response] if the request fails
  Future<Space> getSpace({
    required Uri uri,
    Map<String, String> headers = const {},
    bool isRetry = false,
  }) async {
    final url = _generateApptiveGridUri(uri);
    final response = await _client.get(
      url,
      headers: _createHeadersWithDefaults(headers),
    );
    if (response.statusCode >= 400) {
      if (response.statusCode == 401 && !isRetry) {
        await authenticator.checkAuthentication();
        return getSpace(
          uri: uri,
          headers: headers,
          isRetry: true,
        );
      }
      throw response;
    }
    return Space.fromJson(json.decode(response.body));
  }

  /// Creates and returns a [Uri] pointing to a Form filled with the Data represented for a given entitiy
  ///
  /// [headers] will be added in addition to [ApptiveGridClient.defaultHeaders]
  ///
  /// Requires Authorization
  /// throws [Response] if the request fails
  Future<Uri> getEditLink({
    required Uri uri,
    required String formId,
    Map<String, String> headers = const {},
    bool isRetry = false,
  }) async {
    final url = _generateApptiveGridUri(uri);

    final response = await _client.post(
      url,
      headers: _createHeadersWithDefaults(headers),
      body: jsonEncode({
        'formId': formId,
      }),
    );

    if (response.statusCode >= 400) {
      if (response.statusCode == 401 && !isRetry) {
        await authenticator.checkAuthentication();
        return getEditLink(
          uri: uri,
          formId: formId,
          headers: headers,
          isRetry: true,
        );
      }
      throw response;
    }

    return Uri.parse(
      ((json.decode(response.body) as Map)['uri'] as String)
          .replaceAll(RegExp('/r/'), '/a/'),
    );
  }

  /// Get a specific entity via a [uri]
  ///
  /// [headers] will be added in addition to [ApptiveGridClient.defaultHeaders]
  /// [halVersion] describes what Hal Version of ApptiveGrid should be used.
  ///
  /// This will return a Map of fieldIds and the respective values
  /// To know what [DataType] they are you need to Load a Grid via [loadGrid] and compare [Grid.fields] with the ids
  ///
  /// The entity will be layed out according to [layout]
  /// The id of the entity can be accessed via `['_id']`
  Future<dynamic> getEntity({
    required Uri uri,
    Map<String, String> headers = const {},
    ApptiveGridHalVersion? halVersion,
    ApptiveGridLayout layout = ApptiveGridLayout.field,
    bool isRetry = false,
  }) async {
    final url = _generateApptiveGridUri(uri);

    final response = await _client.get(
      url.replace(
        queryParameters: {
          'layout': layout.queryParameter,
        },
      ),
      headers: _createHeadersWithDefaults(headers, halVersion),
    );

    if (response.statusCode >= 400) {
      if (response.statusCode == 401 && !isRetry) {
        await authenticator.checkAuthentication();
        return getEntity(
          uri: uri,
          headers: headers,
          halVersion: halVersion,
          layout: layout,
          isRetry: true,
        );
      }
      throw response;
    }

    return jsonDecode(response.body);
  }

  /// Authenticate the User
  ///
  /// This will open a Webpage for the User Auth
  Future<Credential?> authenticate() {
    return authenticator.authenticate();
  }

  /// Logs out the user
  Future<void> logout() {
    return authenticator.logout();
  }

  /// Checks if the User is currently authenticated
  Future<bool> get isAuthenticated => authenticator.isAuthenticated;

  /// Checks if the User is currently authenticated with a Token.
  /// Returns true if the user is logged in as a user.
  /// Will return false if there is no authentication set or if the authentication is done using a [ApptiveGridApiKey]
  Future<bool> get isAuthenticatedWithToken =>
      authenticator.isAuthenticatedWithToken;

  /// Authenticates by setting a token
  /// [tokenResponse] needs to be a JWT
  Future<void> setUserToken(Map<String, dynamic> tokenResponse) async {
    return authenticator.setUserToken(tokenResponse);
  }

  /// Updates the Environment for the client and handle necessary changes in the Authenticator
  Future<void> updateEnvironment(ApptiveGridEnvironment environment) async {
    if (environment != options.environment) {
      await authenticator.logout();

      _options = options.copyWith(environment: environment);
      await authenticator.performSetup();
      _attachmentProcessor =
          AttachmentProcessor(options, authenticator, httpClient: _client);
    }
  }

  /// Tries to send pending [ActionItem]s that are stored in [options.cache]
  Future<List<ActionItem>> sendPendingActions() async {
    final pendingActions = await options.cache?.getPendingActionItems() ?? [];
    final successfulActions = <ActionItem>[];
    await Future.wait(
      pendingActions.map((action) async {
        try {
          await submitForm(
            action.link,
            action.data,
            saveToPendingItems: false, // don't resubmit this to pending items
          ).then((value) {
            successfulActions.add(action);
            return value;
          });
        } catch (_) {
          // Was not able to submit this action
        }
      }),
    );
    return successfulActions;
  }

  /// Uploads [bytes] as the Profile Picture for the logged in user
  Future<http.Response> uploadProfilePicture({required Uint8List bytes}) async {
    final user = await getMe();

    final signedUri = Uri.parse(
      'https://6csgir6rcj.execute-api.eu-central-1.amazonaws.com/uploads',
    ).replace(
      queryParameters: {
        'fileName': user.id,
        'fileType': 'image/jpeg',
      },
    );

    final signedResponse =
        await _client.get(signedUri, headers: defaultHeaders);

    if (signedResponse.statusCode >= 400) {
      throw signedResponse;
    }

    final uploadUrl = Uri.parse(jsonDecode(signedResponse.body)['uploadURL']);

    final uploadResponse = await _client.put(
      uploadUrl,
      headers: {
        HttpHeaders.contentTypeHeader: 'image/jpeg',
      },
      body: bytes,
    );

    if (uploadResponse.statusCode >= 400) {
      throw uploadResponse;
    } else {
      return uploadResponse;
    }
  }

  /// Perform a action represented by [link]
  /// [body] is the body of the request
  /// [headers] will be added in addition to [ApptiveGridClient.defaultHeaders]
  /// [halVersion] describes what Hal Version of ApptiveGrid should be used
  /// [queryParameters] will override any [queryParameters] in [ApptiveLink.uri]
  /// [parseResponse] will be called with [http.Response] if the request has been successful
  Future<T?> performApptiveLink<T>({
    required ApptiveLink link,
    bool isRetry = false,
    dynamic body,
    Map<String, String> headers = const {},
    ApptiveGridHalVersion? halVersion,
    Map<String, String>? queryParameters,
    required Future<T?> Function(http.Response response) parseResponse,
  }) async {
    final request = http.Request(
      link.method,
      _generateApptiveGridUri(link.uri).replace(
        queryParameters: queryParameters ?? link.uri.queryParameters,
      ),
    );

    if (body != null) {
      request.body = json.encode(body);
    }

    request.headers.addAll(_createHeadersWithDefaults(headers, halVersion));

    final streamResponse = await _client.send(request);
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode >= 400) {
      if (response.statusCode == 401 && !isRetry) {
        await authenticator.checkAuthentication();
        return performApptiveLink(
          link: link,
          body: body,
          headers: headers,
          queryParameters: queryParameters,
          isRetry: true,
          parseResponse: parseResponse,
        );
      } else {
        throw response;
      }
    }

    return parseResponse(response);
  }

  void _authenticationChanged() {
    notifyListeners();
  }
}
