part of apptive_grid_model;

/// A Uri representation used for performing Form based Api Calls
///
/// FormUris can come from different sources.
/// For Form Links displayed through EditLink/Preview Popups you want to pass in the [FormUri.redirectForm]
/// For Forms accessed via the api through [GridUri]s called on [ApptiveGridClient.getForms] use [FormUri.directForm]
/// If you just have the Uri part you can also use [FormUri.fromUri] which will handle it automatically
abstract class FormUri {
  FormUri._();

  /// Create a FormUri accessed via a redirect Link from the ApptiveGrid UI Console
  /// e.g. for https://app.apptivegrid.de/api/r/609bd6f89fcca3c4c77e70fa `609bd6f89fcca3c4c77e70fa` would be [form]
  factory FormUri.redirectForm({
    required String form,
  }) =>
      _RedirectFormUri(form: form);

  /// Create a FormUri with known attributes for [user], [space], [grid], [form]
  /// Mainly used when passed from other Api Calls
  factory FormUri.directForm({
    required String user,
    required String space,
    required String grid,
    required String form,
  }) =>
      _DirectFormUri(
        user: user,
        space: space,
        grid: grid,
        form: form,
      );

  /// Creates a FormUri based on a [uri]
  /// [uri] must match either:
  /// /api/(r|a)/(\w+)\b for [_RedirectFormUri]
  /// or
  /// /api/users/(\w+)/spaces/(\w+)/grids/(\w+)/forms/(\w+)\b
  ///
  /// throws an [ArgumentError] if [uri] can't be matched against against the above regexes
  factory FormUri.fromUri(String uri) {
    if (RegExp(_DirectFormUri.regex).hasMatch(uri)) {
      return _DirectFormUri.fromUri(uri);
    }
    if (RegExp(_RedirectFormUri.regex).hasMatch(uri)) {
      return _RedirectFormUri.fromUri(uri);
    }
    throw ArgumentError('Could not parse FormUri $uri');
  }

  /// Returns the uriString used for Api Calls using this FormUri
  String get uriString;

  /// Indicates whether or not a call to this Form will require Authentication
  ///
  /// return [false] for [_RedirectFormUri]
  /// return [true] for [_DirectFormUri]
  bool get needsAuthorization;
}

class _RedirectFormUri extends FormUri {
  _RedirectFormUri({required this.form}) : super._();

  factory _RedirectFormUri.fromUri(String uri) {
    final matches = RegExp(regex).allMatches(uri);
    final match = matches.elementAt(0);
    return _RedirectFormUri(form: match.group(2)!);
  }

  static const regex = r'/api/(r|a)/(\w+)\b';

  final String form;

  @override
  String get uriString => '/api/a/$form';

  @override
  bool get needsAuthorization => false;
  @override
  String toString() {
    return '_RedirectFormUri(form: $form)';
  }

  @override
  bool operator ==(Object other) {
    return other is _RedirectFormUri && form == other.form;
  }

  @override
  int get hashCode => toString().hashCode;
}

class _DirectFormUri extends FormUri {
  _DirectFormUri(
      {required this.user,
      required this.space,
      required this.grid,
      required this.form})
      : super._();

  factory _DirectFormUri.fromUri(String uri) {
    final matches = RegExp(regex).allMatches(uri);
    final match = matches.elementAt(0);
    return _DirectFormUri(
        user: match.group(1)!,
        space: match.group(2)!,
        grid: match.group(3)!,
        form: match.group(4)!);
  }

  static const regex =
      r'/api/users/(\w+)/spaces/(\w+)/grids/(\w+)/forms/(\w+)\b';

  final String user;
  final String space;
  final String grid;
  final String form;

  @override
  bool get needsAuthorization => true;

  @override
  String get uriString =>
      '/api/users/$user/spaces/$space/grids/$grid/forms/$form';

  @override
  String toString() {
    return '_DirectFormUri(user: $user, space: $space, grid: $grid, form: $form)';
  }

  @override
  bool operator ==(Object other) {
    return other is _DirectFormUri &&
        grid == other.grid &&
        user == other.user &&
        space == other.space &&
        form == other.form;
  }

  @override
  int get hashCode => toString().hashCode;
}
