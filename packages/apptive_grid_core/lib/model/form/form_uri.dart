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
@Deprecated('Use a normal `Uri` instead')
class FormUri extends ApptiveGridUri {
  FormUri._(Uri uri)
      : super._(
          uri.replace(path: uri.path.replaceFirst('api/r/', 'api/a/')),
          UriType.form,
        );

  /// Creates a FormUri based on a [uri]
  FormUri.fromUri(String uri)
      : super.fromUri(uri.replaceFirst('api/r/', 'api/a/'), UriType.form);

  /// Returns a FormUri pointing to a Form prefilled with values for a certain [EntityUri]
  FormUri forEntity({
    required EntityUri entity,
  }) {
    return FormUri._(
      uri.replace(
        query: 'uri=${entity.uri.toString()}',
      ),
    );
  }
}

/// A FormUri for a Form represented by a redirect Link
@Deprecated('Use a normal `Uri` instead')
class RedirectFormUri extends FormUri {
  /// Create a FormUri accessed via a redirect Link from the ApptiveGrid UI Console
  /// for https://app.apptivegrid.de/api/r/609bd6f89fcca3c4c77e70fa `609bd6f89fcca3c4c77e70fa` would be [components]
  RedirectFormUri({
    required List<String> components,
  }) : super._(Uri(path: '/api/a/${components.join('/')}'));

  /// Creates a FormUri based on a [uri]
  RedirectFormUri.fromUri(super.uri) : super.fromUri();
}

/// A FormUri for a Form represented by a direct Link
@Deprecated('Use a normal `Uri` instead')
class DirectFormUri extends FormUri {
  /// Create a FormUri with known attributes for [user], [space], [grid], [form]
  DirectFormUri({
    required String user,
    required String space,
    required String grid,
    required String form,
    EntityUri? entity,
  }) : super._(
          Uri(
            path: '/api/users/$user/spaces/$space/grids/$grid/forms/$form',
            query: entity != null ? 'uri=${entity.uri.toString()}' : null,
          ),
        );

  /// Creates a FormUri based on a [uri]
  DirectFormUri.fromUri(super.uri) : super.fromUri();
}
