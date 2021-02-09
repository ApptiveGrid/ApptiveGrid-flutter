import 'package:active_grid_core/active_grid_network.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Authentication Creates Header', () {
    final authentication =
        ActiveGridAuthentication(username: 'username', password: 'password');

    expect(authentication.header, 'Basic dXNlcm5hbWU6cGFzc3dvcmQ=');
  });
}
