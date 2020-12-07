import 'package:active_grid_core/active_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('Successful Parse', () {
      final uri = '/api/a/3ojhtqiltc0kiylfp8nddmxmk';
      final method = 'POST';

      final json = {
        'uri': uri,
        'method': method,
      };

      final action = FormAction.fromJson(json);

      expect(action.uri, uri);
      expect(action.method, method);
    });
  });
}
