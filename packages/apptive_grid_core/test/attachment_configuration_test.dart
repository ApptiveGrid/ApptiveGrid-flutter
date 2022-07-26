import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AttachmentConfiguration', () {
    test('Parses from Json', () {
      const direct = AttachmentConfiguration(
        signedUrlApiEndpoint: 'https://signedUrlEndpoint.com',
        attachmentApiEndpoint: 'https://attachmentApiEndpoint.com',
      );
      final fromJson = AttachmentConfiguration.fromJson({
        "signedUrl": 'https://signedUrlEndpoint.com',
        "storageUrl": 'https://attachmentApiEndpoint.com',
      });

      expect(direct, equals(fromJson));
    });
  });

  test('Hashcode', () {
    const configuration = AttachmentConfiguration(
      signedUrlApiEndpoint: 'https://signedUrlEndpoint.com',
      attachmentApiEndpoint: 'https://attachmentApiEndpoint.com',
      signedUrlFormApiEndpoint: 'https://attachmentApiEndpoint.com',
    );
    expect(
        configuration.hashCode,
        equals(Object.hash(
            configuration.signedUrlApiEndpoint,
            configuration.attachmentApiEndpoint,
            configuration.signedUrlFormApiEndpoint)));
  });

  test('toString()', () {
    const configuration = AttachmentConfiguration(
      signedUrlApiEndpoint: 'https://signedUrlEndpoint.com',
      attachmentApiEndpoint: 'https://attachmentApiEndpoint.com',
      signedUrlFormApiEndpoint: 'https://attachmentApiEndpoint.com',
    );
    expect(
        configuration.toString(),
        equals(
            'AttachmentConfiguration(signedUrlApiEndpoint: https://signedUrlEndpoint.com, signedUrlFormApiEndpoint: https://attachmentApiEndpoint.com, attachmentApiEndpoint: https://attachmentApiEndpoint.com)'));
  });

  group('From Configuration String', () {
    test('Parses complete Map', () {
      final configMap = attachmentConfigurationMapFromConfigString(
        'ewogICAgImFscGhhIjogewogICAgICAgICJzaWduZWRVcmwiOiAiaHR0cHM6Ly9hbHBoYS51cGxvYWQuY29tL3VwbG9hZHMiLAogICAgICAgICJzaWduZWRVcmxGb3JtIjogImh0dHBzOi8vYWxwaGEuZm9ybS51cGxvYWQuY29tL3VwbG9hZHMiLAogICAgICAgICJzdG9yYWdlVXJsIjogImh0dHBzOi8vYWxwaGEuc3RvcmFnZS5jb20vIgogICAgfSwKICAgICJiZXRhIjogewogICAgICAgICJzaWduZWRVcmwiOiAiaHR0cHM6Ly9iZXRhLnVwbG9hZC5jb20vdXBsb2FkcyIsCiAgICAgICAgInNpZ25lZFVybEZvcm0iOiAiaHR0cHM6Ly9iZXRhLmZvcm0udXBsb2FkLmNvbS91cGxvYWRzIiwKICAgICAgICAic3RvcmFnZVVybCI6ICJodHRwczovL2JldGEuc3RvcmFnZS5jb20vIgogICAgfSwKICAgICJwcm9kdWN0aW9uIjogewogICAgICAgICJzaWduZWRVcmwiOiAiaHR0cHM6Ly9wcm9kdWN0aW9uLnVwbG9hZC5jb20vdXBsb2FkcyIsCiAgICAgICAgInNpZ25lZFVybEZvcm0iOiAiaHR0cHM6Ly9wcm9kdWN0aW9uLmZvcm0udXBsb2FkLmNvbS91cGxvYWRzIiwKICAgICAgICAic3RvcmFnZVVybCI6ICJodHRwczovL3Byb2R1Y3Rpb24uc3RvcmFnZS5jb20vIgogICAgfQp9',
      );

      expect(
        configMap[ApptiveGridEnvironment.alpha],
        equals(
          const AttachmentConfiguration(
            signedUrlApiEndpoint: "https://alpha.upload.com/uploads",
            signedUrlFormApiEndpoint: "https://alpha.form.upload.com/uploads",
            attachmentApiEndpoint: "https://alpha.storage.com/",
          ),
        ),
      );
      expect(
        configMap[ApptiveGridEnvironment.beta],
        equals(
          const AttachmentConfiguration(
            signedUrlApiEndpoint: "https://beta.upload.com/uploads",
            signedUrlFormApiEndpoint: "https://beta.form.upload.com/uploads",
            attachmentApiEndpoint: "https://beta.storage.com/",
          ),
        ),
      );
      expect(
        configMap[ApptiveGridEnvironment.production],
        equals(
          const AttachmentConfiguration(
            signedUrlApiEndpoint: "https://production.upload.com/uploads",
            signedUrlFormApiEndpoint:
                "https://production.form.upload.com/uploads",
            attachmentApiEndpoint: "https://production.storage.com/",
          ),
        ),
      );
    });

    test('Parses only Production', () {
      final configMap = attachmentConfigurationMapFromConfigString(
        'ewogICAgInByb2R1Y3Rpb24iOiB7CiAgICAgICAgInNpZ25lZFVybCI6ICJodHRwczovL3NpZ25lZFVybEVuZHBvaW50LmNvbS9wcm9kdWN0aW9uIiwKICAgICAgICAic3RvcmFnZVVybCI6ICJodHRwczovL2F0dGFjaG1lbnRBcGlFbmRwb2ludC5jb20vcHJvZHVjdGlvbiIKICAgIH0KfQ==',
      );

      expect(
        configMap[ApptiveGridEnvironment.alpha],
        isNull,
      );
      expect(
        configMap[ApptiveGridEnvironment.beta],
        isNull,
      );
      expect(
        configMap[ApptiveGridEnvironment.production],
        equals(
          const AttachmentConfiguration(
            signedUrlApiEndpoint: 'https://signedUrlEndpoint.com/production',
            attachmentApiEndpoint:
                'https://attachmentApiEndpoint.com/production',
          ),
        ),
      );
    });
  });
}
