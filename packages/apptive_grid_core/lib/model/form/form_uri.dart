part of apptive_grid_model;

/// A Uri representation used for performing Form based Api Calls
///
/// FormUris can come from different sources.
///
/// Depending on your use case you should use a different constructor
///
/// [FormUri.fromUri] is best used if you have a URI Link to a Form but don't know if it's a redirect Link or a direct Link to a Form
///
/// [RedirectFormUri] should be used if you accessed a Form via a Redirect Link e.g. https://app.apptivegrid.de/api/r/609bd6f89fcca3c4c77e70fa
/// [DirectFormUri] should be used if accessed
abstract class FormUri extends ApptiveGridUri {
  FormUri._();

  /// Creates a FormUri based on a [uri]
  /// [uri] must match either:
  /// /api/(r|a)/(\w+)\b for [RedirectFormUri]
  /// or
  /// /api/users/(\w+)/spaces/(\w+)/grids/(\w+)/forms/(\w+)\b for [DirectFormUri]
  ///
  /// throws an [ArgumentError] if [uri] can't be matched against against the above regexes
  factory FormUri.fromUri(String uri) {
    if (RegExp(DirectFormUri._regex).hasMatch(uri)) {
      return DirectFormUri.fromUri(uri);
    }
    if (RegExp(RedirectFormUri._regex).hasMatch(uri)) {
      return RedirectFormUri.fromUri(uri);
    }
    throw ArgumentError('Could not parse FormUri $uri');
  }

  /// Returns the uriString used for Api Calls using this FormUri
  @override
  String get uriString;

  /// Indicates whether or not a call to this Form will require Authentication
  ///
  /// return [false] for [RedirectFormUri]
  /// return [true] for [DirectFormUri]
  bool get needsAuthorization;
}

/// A FormUri for a Form represented by a redirect Link
class RedirectFormUri extends FormUri {
  /// Create a FormUri accessed via a redirect Link from the ApptiveGrid UI Console
  /// for https://app.apptivegrid.de/api/r/609bd6f89fcca3c4c77e70fa `609bd6f89fcca3c4c77e70fa` would be [components]
  RedirectFormUri({
    required this.components,
  }) : super._();

  /// Creates a FormUri based on a [uri]
  /// [uri] must match:
  /// /api/(r|a)/(\w+)\b
  factory RedirectFormUri.fromUri(String uri) {
    final matches = RegExp(_regex).allMatches(uri);
    if (matches.isEmpty || matches.elementAt(0).groupCount < 2) {
      throw ArgumentError('Could not parse FormUri $uri');
    }
    final match = matches.elementAt(0);
    return RedirectFormUri(components: match.group(2)!.split('/'));
  }

  static const _regex = r'/api/(r|a)/((\w+/?)+)';

  /// Id this is representing
  /// for https://app.apptivegrid.de/api/r/609bd6f89fcca3c4c77e70fa `609bd6f89fcca3c4c77e70fa` would be [components]
  final List<String> components;

  @override
  String get uriString => '/api/a/${components.join('/')}';

  @override
  bool get needsAuthorization => false;

  @override
  String toString() {
    return 'RedirectFormUri(form: $components)';
  }

  @override
  bool operator ==(Object other) {
    return other is RedirectFormUri &&
        f.listEquals(components, other.components);
  }

  @override
  int get hashCode => toString().hashCode;
}

/// A FormUri for a Form represented by a direct Link
class DirectFormUri extends FormUri {
  /// Create a FormUri with known attributes for [user], [space], [grid], [form]
  DirectFormUri({
    required this.user,
    required this.space,
    required this.grid,
    required this.form,
    this.entity,
  }) : super._();

  /// Creates a FormUri based on a [uri]
  /// Creates a FormUri based on a [uri]
  /// [uri] must match:
  /// /api/users/(\w+)/spaces/(\w+)/grids/(\w+)/forms/(\w+)\b
  factory DirectFormUri.fromUri(String uri) {
    final parsed = Uri.parse(uri);
    final matches = RegExp(_regex).allMatches(parsed.path);
    if (matches.isEmpty || matches.elementAt(0).groupCount != 4) {
      throw ArgumentError('Could not parse FormUri $uri');
    }

    final match = matches.elementAt(0);
    EntityUri? entity;
    if (parsed.queryParameters['uri'] != null) {
      entity = EntityUri.fromUri(parsed.queryParameters['uri']!);
    }
    return DirectFormUri(
      user: match.group(1)!,
      space: match.group(2)!,
      grid: match.group(3)!,
      form: match.group(4)!,
      entity: entity,
    );
  }

  static const _regex =
      r'/api/users/(\w+)/spaces/(\w+)/grids/(\w+)/forms/(\w+)\b';

  /// Id of the User that owns this Grid
  final String user;

  /// Id of the Space this Grid is in
  final String space;

  /// Id of the Grid this is in
  final String grid;

  /// Id of the Form this [FormUri] is representing
  final String form;

  /// Optional [EntityUri] leading to a pre-filled form
  final EntityUri? entity;

  @override
  bool get needsAuthorization => true;

  @override
  String get uriString {
    var entityAppendix = '';
    if (entity != null) {
      entityAppendix = '?uri=${entity!.uriString}';
    }
    return '/api/users/$user/spaces/$space/grids/$grid/forms/$form$entityAppendix';
  }

  /// Returns a FormUri pointing to a Form prefilled with values for a certain [EntityUri]
  FormUri forEntity({
    required EntityUri entity,
  }) {
    return DirectFormUri(
      user: user,
      space: space,
      grid: grid,
      form: form,
      entity: entity,
    );
  }

  @override
  String toString() {
    return 'DirectFormUri(user: $user, space: $space, grid: $grid, form: $form, entity: $entity)';
  }

  @override
  bool operator ==(Object other) {
    return other is DirectFormUri &&
        grid == other.grid &&
        user == other.user &&
        space == other.space &&
        form == other.form &&
        entity == other.entity;
  }

  @override
  int get hashCode => toString().hashCode;
}
