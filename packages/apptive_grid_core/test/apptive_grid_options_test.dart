import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_core/apptive_grid_network.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks.dart';

void main() {
  group('Copy', () {
    test('New Values get carried', () {
      const env1 = ApptiveGridEnvironment.alpha;
      const env2 = ApptiveGridEnvironment.production;

      const authOptionsA = ApptiveGridAuthenticationOptions();
      const authOptionsB =
          ApptiveGridAuthenticationOptions(autoAuthenticate: true);

      final cache = MockApptiveGridCache();

      const optionsA = ApptiveGridOptions(
        authenticationOptions: authOptionsA,
        environment: env1,
      );
      final optionsB = optionsA.copyWith(
        environment: env2,
        authenticationOptions: authOptionsB,
        cache: cache,
      );
      expect(
        optionsB,
        ApptiveGridOptions(
          environment: env2,
          authenticationOptions: authOptionsB,
          cache: cache,
        ),
      );
    });

    test('No op stays the same', () {
      const env1 = ApptiveGridEnvironment.alpha;

      const authOptionsA = ApptiveGridAuthenticationOptions();

      final cache = MockApptiveGridCache();

      final optionsA = ApptiveGridOptions(
        authenticationOptions: authOptionsA,
        environment: env1,
        cache: cache,
      );
      final optionsB = optionsA.copyWith();
      expect(optionsB, optionsA);
    });
  });

  group('Equality', () {
    test('Objects are equal', () {
      const optionsA = ApptiveGridOptions(
        environment: ApptiveGridEnvironment.beta,
      );
      const optionsB =
          ApptiveGridOptions(environment: ApptiveGridEnvironment.beta);

      expect(optionsA, equals(optionsB));
      expect(optionsA.hashCode, equals(optionsB.hashCode));
    });

    test('Objects are not equal', () {
      const optionsA = ApptiveGridOptions(
        environment: ApptiveGridEnvironment.beta,
      );
      const optionsB = ApptiveGridOptions(
        environment: ApptiveGridEnvironment.alpha,
        authenticationOptions:
            ApptiveGridAuthenticationOptions(autoAuthenticate: true),
      );

      expect(optionsA, isNot(equals(optionsB)));
      expect(optionsA.hashCode, isNot(equals(optionsB.hashCode)));
    });
  });
}
