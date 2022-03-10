part of apptive_grid_network;

/// Api Client to communicate with the ApptiveGrid Backend
class ApptiveGridClient {
  /// Creates an ApiClient
  ApptiveGridClient({
    this.options = const ApptiveGridOptions(),
  })  : _client = http.Client(),
        _authenticator = ApptiveGridAuthenticator(options: options);

  /// Creates an Api Client on the Basis of a [http.Client]
  ///
  /// this should only be used for testing in order to pass in a Mocked [http.Client]
  @visibleForTesting
  ApptiveGridClient.fromClient(
    http.Client httpClient, {
    this.options = const ApptiveGridOptions(),
    ApptiveGridAuthenticator? authenticator,
  })  : _client = httpClient,
        _authenticator = authenticator ??
            ApptiveGridAuthenticator(options: options, httpClient: httpClient);

  /// Configurations
  ApptiveGridOptions options;

  final ApptiveGridAuthenticator _authenticator;

  final http.Client _client;

  /// Close the connection on the httpClient
  void dispose() {
    _client.close();
    _authenticator.dispose();
  }

  /// Headers that are used for multiple Calls
  @visibleForTesting
  Map<String, String> get headers => (<String, String?>{
        HttpHeaders.authorizationHeader: _authenticator.header,
        HttpHeaders.contentTypeHeader: ContentType.json,
      }..removeWhere((key, value) => value == null))
          .map((key, value) => MapEntry(key, value!));

  Uri _generateApptiveGridUri(ApptiveGridUri baseUri) {
    return baseUri.uri.replace(
      scheme: 'https',
      host: Uri.parse(options.environment.url).host,
    );
  }

  /// Loads a [FormData] represented by [formUri]
  ///
  /// Based on [formUri] this might require Authentication
  /// throws [Response] if the request fails
  Future<FormData> loadForm({
    required FormUri formUri,
  }) async {
    final url = _generateApptiveGridUri(formUri);
    final response = await _client.get(url, headers: headers);
    if (response.statusCode >= 400) {
      if (response.statusCode == 401) {
        await _authenticator.checkAuthentication();
        return loadForm(formUri: formUri);
      }
      throw response;
    }
    return FormData.fromJson(json.decode(response.body));
  }

  /// Performs a [FormAction] using [formData]
  ///
  /// if this returns a [http.Response] with a [http.Response.statusCode] >= 400 it means that the Item was saved in [options.cache]
  /// throws [Response] if the request fails
  Future<http.Response> performAction(
    FormAction action,
    FormData formData, {
    bool saveToPendingItems = true,
  }) async {
    final actionItem = ActionItem(action: action, data: formData);

    final attachmentActions = await _performAttachmentActions(
      formData.attachmentActions,
      fromForm: true,
    ).catchError(
      (error) => _handleActionError(
        error,
        actionItem: actionItem,
        saveToPendingItems: saveToPendingItems,
      ),
    );
    if (attachmentActions.statusCode >= 400) {
      return attachmentActions;
    }
    final uri = Uri.parse('${options.environment.url}${action.uri}');
    final request = http.Request(action.method, uri);
    request.body = jsonEncode(formData.toRequestObject());
    late http.Response response;
    request.headers.addAll(headers);
    try {
      final streamResponse = await _client.send(request);
      response = await http.Response.fromStream(streamResponse);
    } catch (error) {
      // Catch all Exception for compatibility Reasons between Web and non Web Apps
      return _handleActionError(
        error,
        actionItem: actionItem,
        saveToPendingItems: saveToPendingItems,
      );
    }

    if (response.statusCode >= 400) {
      return _handleActionError(
        response,
        actionItem: actionItem,
        saveToPendingItems: saveToPendingItems,
      );
    }
    // Action was performed successfully. Remove it from pending Actions
    await options.cache?.removePendingActionItem(actionItem);
    return response;
  }

  Future<http.Response> _handleActionError(
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
  }) async {
    await Future.wait(
      actions.values.map((action) {
        switch (action.type) {
          case AttachmentActionType.add:
            return _uploadAttachment(
              action as AddAttachmentAction,
              fromForm: fromForm,
            );
          case AttachmentActionType.delete:
            debugPrint('Delete Attachment ${action.attachment}');
            return Future.value();
          case AttachmentActionType.rename:
            debugPrint(
              'Rename Attachment ${action.attachment} to "${action.attachment.name}"',
            );
            return Future.value();
        }
      }),
    );
    return http.Response('AttachmentActionSuccess', 200);
  }

  /// Loads a [Grid] represented by [gridUri]
  ///
  /// [sorting] defines the order in which items will be returned
  /// The order of [ApptiveGridSorting] in [sorting] will rank the order in which values should be sorted
  ///
  /// Requires Authorization
  /// throws [Response] if the request fails
  Future<Grid> loadGrid({
    required GridUri gridUri,
    List<ApptiveGridSorting>? sorting,
    ApptiveGridFilter? filter,
    bool isRetry = false,
  }) async {
    final gridViewUrl = _generateApptiveGridUri(gridUri);

    final gridViewResponse = await _client.get(gridViewUrl, headers: headers);
    if (gridViewResponse.statusCode >= 400) {
      if (gridViewResponse.statusCode == 401 && !isRetry) {
        await _authenticator.checkAuthentication();
        return loadGrid(
            gridUri: gridUri, sorting: sorting, filter: filter, isRetry: true);
      }
      throw gridViewResponse;
    }

    final entitiesResponse = await loadEntities(
      uri: Uri.parse(
        '${gridViewUrl.toString().replaceAll(RegExp('/views/.*'), '')}/entities',
      ),
      viewId: gridViewUrl.pathSegments.contains('views')
          ? gridViewUrl
              .pathSegments[gridViewUrl.pathSegments.indexOf('views') + 1]
          : null,
      layout: 'indexed',
      filter: filter,
      sorting: sorting,
    );

    final entities = entitiesResponse.items;
    final gridToParse = jsonDecode(gridViewResponse.body);
    gridToParse['entities'] = entities;
    return Grid.fromJson(gridToParse);
  }

  /// Load Entities of a Grid that are accessed by [uri]
  /// [viewId] specifies allows to request the entities of a specific GridView which allows for getting Filters/Sorting that was applied from the web client
  ///
  /// if [layout] is not set the items will be a Map<String, dynamic> with the keys being the fieldIds and the value being the values as json objects
  /// `indexed` layout will return the items in the following format:
  /// ```
  /// {
  ///   "fields": [
  ///     `jsonValue of First Column`,
  ///     `jsonValue of Second Column`,
  ///     `jsonValue of Third Column`,
  ///     `jsonValue of Fourth Column`,
  ///     ...
  ///   ]
  /// }
  /// ```
  ///
  /// [sorting] allows to apply custom sorting
  /// [filter] allows to get custom filters
  Future<EntitiesResponse<T>> loadEntities<T>({
    required Uri uri,
    String? viewId,
    String? layout,
    List<ApptiveGridSorting>? sorting,
    ApptiveGridFilter? filter,
  }) async {
    final baseUrl = Uri.parse(options.environment.url);
    final requestUri = uri.replace(
      scheme: baseUrl.scheme,
      host: baseUrl.host,
      queryParameters: Map.from(uri.queryParameters)
        ..addAll({
          if (viewId != null) 'viewId': viewId,
          if (layout != null) 'layout': layout,
          if (sorting != null)
            'sorting':
                jsonEncode(sorting.map((e) => e.toRequestObject()).toList()),
          if (filter != null) 'filter': jsonEncode(filter.toJson()),
        }),
    );

    final response = await _client.get(requestUri, headers: headers);

    if (response.statusCode >= 400) {
      throw response;
    }

    final decodedResponse = jsonDecode(response.body);
    if (decodedResponse is List) {
      return EntitiesResponse(items: decodedResponse.cast<T>());
    } else {
      // Preparation for Paging
      return EntitiesResponse(items: decodedResponse['items']);
    }
  }

  /// Get the [User] that is authenticated
  ///
  /// Requires Authorization
  /// throws [Response] if the request fails
  Future<User> getMe() async {
    await _authenticator.checkAuthentication();

    final url = Uri.parse('${options.environment.url}/api/users/me');
    final response = await _client.get(url, headers: headers);
    if (response.statusCode >= 400) {
      throw response;
    }
    return User.fromJson(json.decode(response.body));
  }

  /// Get the [Space] represented by [spaceUri]
  ///
  /// Requires Authorization
  /// throws [Response] if the request fails
  Future<Space> getSpace({
    required SpaceUri spaceUri,
  }) async {
    await _authenticator.checkAuthentication();

    final url = _generateApptiveGridUri(spaceUri);
    final response = await _client.get(url, headers: headers);
    if (response.statusCode >= 400) {
      throw response;
    }
    return Space.fromJson(json.decode(response.body));
  }

  /// Get all [FormUri]s that are contained in a [Grid] represented by [gridUri]
  ///
  /// Requires Authorization
  /// throws [Response] if the request fails
  Future<List<FormUri>> getForms({
    required GridUri gridUri,
  }) async {
    await _authenticator.checkAuthentication();

    final baseUrl = _generateApptiveGridUri(gridUri);
    final url = baseUrl.replace(
      pathSegments: [...baseUrl.pathSegments, 'forms'],
    );
    final response = await _client.get(url, headers: headers);
    if (response.statusCode >= 400) {
      throw response;
    }
    return (json.decode(response.body) as List)
        .map((e) => FormUri.fromUri(e))
        .toList();
  }

  /// Get all [GridViewUri]s that are contained in a [Grid] represented by [gridUri]
  ///
  /// Requires Authorization
  /// throws [Response] if the request fails
  Future<List<GridViewUri>> getGridViews({
    required GridUri gridUri,
  }) async {
    await _authenticator.checkAuthentication();

    final baseUrl = _generateApptiveGridUri(gridUri);
    final url = baseUrl.replace(
      pathSegments: [...baseUrl.pathSegments, 'views'],
    );
    final response = await _client.get(url, headers: headers);
    if (response.statusCode >= 400) {
      throw response;
    }
    return (json.decode(response.body) as List)
        .map((e) => GridViewUri.fromUri(e))
        .toList();
  }

  /// Creates and returns a [FormUri] filled with the Data represented by [entityUri]
  ///
  /// Requires Authorization
  /// throws [Response] if the request fails
  Future<FormUri> getEditLink({
    required EntityUri entityUri,
    required String formId,
  }) async {
    await _authenticator.checkAuthentication();

    final baseUrl = _generateApptiveGridUri(entityUri);
    final url = baseUrl.replace(
      pathSegments: [...baseUrl.pathSegments, 'EditLink'],
    );

    final response = await _client.post(
      url,
      headers: headers,
      body: jsonEncode({
        'formId': formId,
      }),
    );

    if (response.statusCode >= 400) {
      throw response;
    }

    return FormUri.fromUri((json.decode(response.body) as Map)['uri']);
  }

  /// Get a specific entity via a [entityUri]
  ///
  /// This will return a Map of fieldIds and the respective values
  /// To know what [DataType] they are you need to Load a Grid via [loadGrid] and compare [Grid.fields] with the ids
  ///
  /// The id of the entity can be accessed via `['_id']`
  Future<Map<String, dynamic>> getEntity({
    required EntityUri entityUri,
  }) async {
    await _authenticator.checkAuthentication();

    final url = _generateApptiveGridUri(entityUri);

    final response = await _client.get(
      url,
      headers: headers,
    );

    if (response.statusCode >= 400) {
      throw response;
    }

    return jsonDecode(response.body);
  }

  /// Authenticate the User
  ///
  /// This will open a Webpage for the User Auth
  Future<Credential?> authenticate() {
    return _authenticator.authenticate();
  }

  /// Logs out the user
  Future<void> logout() {
    return _authenticator.logout();
  }

  /// Checks if the User is currently authenticated
  Future<bool> get isAuthenticated => _authenticator.isAuthenticated;

  /// Checks if the User is currently authenticated with a Token.
  /// Returns true if the user is logged in as a user.
  /// Will return false if there is no authentication set or if the authentication is done using a [ApptiveGridApiKey]
  Future<bool> get isAuthenticatedWithToken =>
      _authenticator.isAuthenticatedWithToken;

  /// Authenticates by setting a token
  /// [tokenResponse] needs to be a JWT
  Future<void> setUserToken(Map<String, dynamic> tokenResponse) async {
    return _authenticator.setUserToken(tokenResponse);
  }

  /// Updates the Environment for the client and handle necessary changes in the Authenticator
  Future<void> updateEnvironment(ApptiveGridEnvironment environment) async {
    final currentRealm = options.environment.authRealm;

    if (currentRealm != environment.authRealm) {
      await _authenticator.logout();
    }

    options = options.copyWith(environment: environment);
    _authenticator.options = options;
  }

  /// Tries to send pending [ActionItem]s that are stored in [options.cache]
  Future sendPendingActions() async {
    final pendingActions = await options.cache?.getPendingActionItems() ?? [];

    for (final action in pendingActions) {
      try {
        await performAction(
          action.action,
          action.data,
          saveToPendingItems: false, // don't resubmit this to pending items
        );
      } on http.Response catch (_) {
        // Was not able to submit this action
      }
    }
  }

  // Attachments
  String get _signedUrlApiEndpoint {
    final endpoint = options
        .attachmentConfigurations[options.environment]?.signedUrlApiEndpoint;
    if (endpoint != null) {
      return endpoint;
    } else {
      throw ArgumentError(
        'In order to use Attachments you need to specify AttachmentConfigurations in ApptiveGridOptions',
      );
    }
  }

  String? get _signedUrlFormApiEndpoint {
    return options.attachmentConfigurations[options.environment]
        ?.signedUrlFormApiEndpoint;
  }

  String get _attachmentApiEndpoint {
    final endpoint = options
        .attachmentConfigurations[options.environment]?.attachmentApiEndpoint;
    if (endpoint != null) {
      return endpoint;
    } else {
      throw ArgumentError(
        'In order to use Attachments you need to specify AttachmentConfigurations in ApptiveGridOptions',
      );
    }
  }

  /// Creates an url where an attachment should be saved
  ///
  /// TODO: Do not Use Name
  Uri createAttachmentUrl(String name) {
    return Uri.parse(
      '$_attachmentApiEndpoint$name?${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// Uploads an [Attachment] defined in [action]
  ///
  /// [fromForm] determines if this attachment can be added without the need for authentication
  ///
  /// In order for no authentication [fromForm] needs to be `true` and [AttachmentConfiguration.signedUrlFormApiEndpoint] needs to be non null
  /// for the current [ApptiveGridStage] in [ApptiveGridOptions.attachmentConfigurations] in [options]
  Future _uploadAttachment(
    AddAttachmentAction action, {
    bool fromForm = false,
  }) async {
    final requireAuth = !fromForm || _signedUrlFormApiEndpoint == null;
    if (requireAuth) {
      await _authenticator.checkAuthentication();
    }

    final baseUri = Uri.parse(
      requireAuth ? _signedUrlApiEndpoint : _signedUrlFormApiEndpoint!,
    );
    final uri = Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      path: baseUri.path,
      queryParameters: {
        'fileName': action.attachment.name,
        'fileType': action.attachment.type,
      },
    );
    final createUrlHeaders = requireAuth ? headers : <String, String>{};
    return _client.get(uri, headers: createUrlHeaders).then((response) {
      if (response.statusCode < 400) {
        return _client
            .put(
          Uri.parse(jsonDecode(response.body)['uploadURL']),
          headers: {HttpHeaders.contentTypeHeader: action.attachment.type},
          body: action.byteData,
        )
            .then((putResponse) {
          if (putResponse.statusCode < 400) {
            debugPrint('Uploaded Successfully');
            return putResponse;
          } else {
            throw putResponse;
          }
        });
      } else {
        throw response;
      }
    });
  }
}
