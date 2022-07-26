import 'package:apptive_grid_core/apptive_grid_core.dart';
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
      expect(optionsB, equals(optionsA));
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

      expect(optionsA, isNot(optionsB));
    });
  });

  test('Hashcode', () {
    const options = ApptiveGridOptions(
      environment: ApptiveGridEnvironment.alpha,
      authenticationOptions:
          ApptiveGridAuthenticationOptions(autoAuthenticate: true),
    );

    expect(
      options.hashCode,
      equals(
        Object.hash(
          options.environment,
          options.authenticationOptions,
          options.cache,
          options.attachmentConfigurations,
          options.formWidgetConfigurations,
        ),
      ),
    );
  });

  test('toString()', () {
    const options = ApptiveGridOptions(
      environment: ApptiveGridEnvironment.alpha,
      authenticationOptions:
          ApptiveGridAuthenticationOptions(autoAuthenticate: true),
    );

    expect(
      options.toString(),
      equals(
        'ApptiveGridOptions(environment: ApptiveGridEnvironment.alpha, authenticationOptions: ApptiveGridAuthenticationOptions(autoAuthenticate: true, redirectScheme: null, apiKey: null, persistCredentials: false), cache: null, attachmentConfigurations: {}, formWidgetConfigurations: [])',
      ),
    );
  });
}
