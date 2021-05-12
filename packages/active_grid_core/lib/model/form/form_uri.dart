part of active_grid_model;

abstract class FormUri {
  FormUri._();

  factory FormUri.fromRedirectUri({required String formId,}) => _RedirectFormUri(form: formId);
  factory FormUri.fromDirectUri({required String user, required String space, required String grid, required String form,}) => _DirectFormUri(user: user, space: space, grid: grid, form: form,);

  factory FormUri.fromUri(String uri) {
    if(RegExp(_DirectFormUri.regex).hasMatch(uri)) {
      return _DirectFormUri.fromUri(uri);
    }
    if(RegExp(_RedirectFormUri.regex).hasMatch(uri)) {
      return _RedirectFormUri.fromUri(uri);
    }
    throw ArgumentError('Could not parse FormUri $uri');
  }

  String get uriString;
}

class _RedirectFormUri extends FormUri {
  _RedirectFormUri({required this.form}) : super._();

  factory _RedirectFormUri.fromUri(String uri) {
    final matches = RegExp(regex).allMatches(uri);
    if(matches.isEmpty || matches.elementAt(0).groupCount != 2) {
      throw ArgumentError('Could not parse FormUri $uri');
    }
    final match = matches.elementAt(0);
    return _RedirectFormUri(form: match.group(2)!);
  }

  static const regex = r'/api/(r|a)/(\w+)\b';

  final String form;

  @override
  String get uriString => '/api/a/$form';

  @override
  String toString() {
    return '_RedirectFormUri(form: $form)';
  }

  @override
  bool operator ==(Object other) {
    return other is _RedirectFormUri &&
        form == other.form;
  }

  @override
  int get hashCode => toString().hashCode;
}

class _DirectFormUri extends FormUri {
  _DirectFormUri({required this.user, required this.space, required this.grid, required this.form}) : super._();

  factory _DirectFormUri.fromUri(String uri) {
    final matches = RegExp(regex).allMatches(uri);
    if(matches.isEmpty || matches.elementAt(0).groupCount != 4) {
      throw ArgumentError('Could not parse FormUri $uri');
    }
    final match = matches.elementAt(0);
    return _DirectFormUri(user: match.group(1)!, space: match.group(2)!, grid: match.group(3)!, form: match.group(4)!);
  }

  static const regex = r'/api/users/(\w+)/spaces/(\w+)/grids/(\w+)/forms/(\w+)\b';

  final String user;
  final String space;
  final String grid;
  final String form;

  @override
  String get uriString => '/api/users/$user/spaces/$space/grids/$grid/forms/$form';

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