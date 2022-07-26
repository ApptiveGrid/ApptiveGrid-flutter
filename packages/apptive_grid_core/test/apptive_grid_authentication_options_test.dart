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

        expect(optionsA, isNot(optionsB));
        expect(optionsA.hashCode, isNot(optionsB.hashCode));
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
      });

      test('Objects are not equal', () {
        const keyA =
            ApptiveGridApiKey(authKey: 'authKey', password: 'password');
        const keyB =
            ApptiveGridApiKey(authKey: 'authKey', password: 'passwortWithT');

        expect(keyA, isNot(keyB));
      });
    });

    test('Hashcode', () {
      const key = ApptiveGridApiKey(authKey: 'authKey', password: 'password');

      expect(key.hashCode, equals(Object.hash('authKey', 'password')));
    });

    test('toString()', () {
      const key = ApptiveGridApiKey(authKey: 'authKey', password: 'password');

      expect(key.toString(),
          equals('ApptiveGridApiKey(authKey: authKey, password: password)'));
    });
  });
}
