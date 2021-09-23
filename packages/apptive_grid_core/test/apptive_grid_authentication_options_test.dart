import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthenticationOptions', () {
    group('Equality', () {
      test('Objects are equal', () {
        const optionsA = ApptiveGridAuthenticationOptions(
          autoAuthenticate: true,
          redirectScheme: 'scheme',
        );
        const optionsB = ApptiveGridAuthenticationOptions(
          autoAuthenticate: true,
          redirectScheme: 'scheme',
        );

        expect(optionsA, equals(optionsB));
        expect(optionsA.hashCode, equals(optionsB.hashCode));
      });

      test('Objects are not equal', () {
        const optionsA = ApptiveGridAuthenticationOptions(
          autoAuthenticate: true,
          redirectScheme: 'scheme',
        );
        const optionsB = ApptiveGridAuthenticationOptions(
          autoAuthenticate: true,
          redirectScheme: 'differentScheme',
        );

        expect(optionsA, isNot(equals(optionsB)));
        expect(optionsA.hashCode, isNot(equals(optionsB.hashCode)));
      });
    });
  });

  group('ApiKey', () {
    group('Equality', () {
      test('Objects are equal', () {
        const keyA =
            ApptiveGridApiKey(authKey: 'authKey', password: 'password');
        const keyB =
            ApptiveGridApiKey(authKey: 'authKey', password: 'password');

        expect(keyA, equals(keyB));
        expect(keyA.hashCode, equals(keyB.hashCode));
      });

      test('Objects are not equal', () {
        const keyA =
            ApptiveGridApiKey(authKey: 'authKey', password: 'password');
        const keyB =
            ApptiveGridApiKey(authKey: 'authKey', password: 'passwortWithT');

        expect(keyA, isNot(equals(keyB)));
        expect(keyA.hashCode, isNot(equals(keyB.hashCode)));
      });
    });
  });
}
