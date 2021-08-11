import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthenticationOptions', () {
    group('Equality', () {
      test('Objects are equal', () {
        final optionsA = ApptiveGridAuthenticationOptions(
            autoAuthenticate: true, redirectScheme: 'scheme');
        final optionsB = ApptiveGridAuthenticationOptions(
            autoAuthenticate: true, redirectScheme: 'scheme');

        expect(optionsA, equals(optionsB));
        expect(optionsA.hashCode, equals(optionsB.hashCode));
      });

      test('Objects are not equal', () {
        final optionsA = ApptiveGridAuthenticationOptions(
            autoAuthenticate: true, redirectScheme: 'scheme');
        final optionsB = ApptiveGridAuthenticationOptions(
            autoAuthenticate: true, redirectScheme: 'differentScheme');

        expect(optionsA, isNot(equals(optionsB)));
        expect(optionsA.hashCode, isNot(equals(optionsB.hashCode)));
      });
    });
  });

  group('ApiKey', () {
    group('Equality', () {
      test('Objects are equal', () {
        final keyA =
            ApptiveGridApiKey(authKey: 'authKey', password: 'password');
        final keyB =
            ApptiveGridApiKey(authKey: 'authKey', password: 'password');

        expect(keyA, equals(keyB));
        expect(keyA.hashCode, equals(keyB.hashCode));
      });

      test('Objects are not equal', () {
        final keyA =
            ApptiveGridApiKey(authKey: 'authKey', password: 'password');
        final keyB =
            ApptiveGridApiKey(authKey: 'authKey', password: 'passwortWithT');

        expect(keyA, isNot(equals(keyB)));
        expect(keyA.hashCode, isNot(equals(keyB.hashCode)));
      });
    });
  });
}
