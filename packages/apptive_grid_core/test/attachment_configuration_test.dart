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
      expect(direct.hashCode, equals(fromJson.hashCode));
    });
  });

  group('From Configuration String', () {
    test('Parses complete Map', () {
      final configMap = attachmentConfigurationMapFromConfigString(
        'ewogICAgImFscGhhIjogewogICAgICAgICJzaWduZWRVcmwiOiAiaHR0cHM6Ly9zaWduZWRVcmxFbmRwb2ludC5jb20vYWxwaGEiLAogICAgICAgICJzdG9yYWdlVXJsIjogImh0dHBzOi8vYXR0YWNobWVudEFwaUVuZHBvaW50LmNvbS9hbHBoYSIKICAgIH0sCiAgICAiYmV0YSI6IHsKICAgICAgICAic2lnbmVkVXJsIjogImh0dHBzOi8vc2lnbmVkVXJsRW5kcG9pbnQuY29tL2JldGEiLAogICAgICAgICJzdG9yYWdlVXJsIjogImh0dHBzOi8vYXR0YWNobWVudEFwaUVuZHBvaW50LmNvbS9iZXRhIgogICAgfSwKICAgICJwcm9kdWN0aW9uIjogewogICAgICAgICJzaWduZWRVcmwiOiAiaHR0cHM6Ly9zaWduZWRVcmxFbmRwb2ludC5jb20vcHJvZHVjdGlvbiIsCiAgICAgICAgInN0b3JhZ2VVcmwiOiAiaHR0cHM6Ly9hdHRhY2htZW50QXBpRW5kcG9pbnQuY29tL3Byb2R1Y3Rpb24iCiAgICB9Cn0=',
      );

      expect(
        configMap[ApptiveGridEnvironment.alpha],
        equals(
          const AttachmentConfiguration(
            signedUrlApiEndpoint: 'https://signedUrlEndpoint.com/alpha',
            attachmentApiEndpoint: 'https://attachmentApiEndpoint.com/alpha',
          ),
        ),
      );
      expect(
        configMap[ApptiveGridEnvironment.beta],
        equals(
          const AttachmentConfiguration(
            signedUrlApiEndpoint: 'https://signedUrlEndpoint.com/beta',
            attachmentApiEndpoint: 'https://attachmentApiEndpoint.com/beta',
          ),
        ),
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
