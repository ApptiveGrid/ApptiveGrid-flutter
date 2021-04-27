import 'package:active_grid_core/network/web_authenticator.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks.dart';

@TestOn('browser')
void main() {
  testWidgets('Authenticate with Web', (tester) async {
    // This does not really test the web implemetation
    // Todo: Find a way to test thing depending on dart:html
    final client = MockAuthClient();
    final authenticator = Authenticator(client,
        scopes: ['openid'],
        urlLauncher: (_) {},
        redirectUri: Uri.parse('https://someurl.com'));

    await authenticator.authorize();
  });
}
