import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResourceDataEntity', () {
    test('From rawSpaceResource maps correctly', () {
      final rawSpaceResource = {
        "icon": null,
        "belongsTo": null,
        "iconset": null,
        "_links": {
          "self": {
            "href":
                "/api/users/66719e4c8f83ff0c88d77dc1/spaces/66f415f8e26ae86e74df53b0",
            "method": "get",
          },
        },
        "key": null,
        "color": null,
        "name": "Resource Space",
        "id": "66f415f8e26ae86e74df53b0",
        "type": "space",
      };

      final resourceDataEntity = ResourceDataEntity.fromJson(rawSpaceResource);

      expect(resourceDataEntity.value, isNot(null));
      expect(resourceDataEntity.value!.name, equals('Resource Space'));
      expect(resourceDataEntity.value!.type, equals(DataResourceType.space));
      expect(
        resourceDataEntity.value!.href.uri,
        equals(
          Uri(
            path:
                '/api/users/66719e4c8f83ff0c88d77dc1/spaces/66f415f8e26ae86e74df53b0',
          ),
        ),
      );
    });

    test('From resource with unknown type maps correctly', () {
      final rawUnknownResource = {
        "_links": {
          "self": {
            "href":
                "/api/users/66719e4c8f83ff0c88d77dc1/spaces/66f415f8e26ae86e74df53b0",
            "method": "get",
          },
        },
        "name": "???",
        "type": "whatever",
      };

      final resourceDataEntity =
          ResourceDataEntity.fromJson(rawUnknownResource);

      expect(resourceDataEntity.value, isNot(null));
      expect(resourceDataEntity.value!.name, equals('???'));
      expect(resourceDataEntity.value!.type, equals(DataResourceType.unknown));
      expect(
        resourceDataEntity.value!.href.uri,
        equals(
          Uri(
            path:
                '/api/users/66719e4c8f83ff0c88d77dc1/spaces/66f415f8e26ae86e74df53b0',
          ),
        ),
      );
    });

    test('From resource with missing link maps correctly', () {
      final rawUnknownResource = {
        "name": "???",
        "type": "whatever",
      };

      final resourceDataEntity =
          ResourceDataEntity.fromJson(rawUnknownResource);

      expect(resourceDataEntity.value, isNot(null));
      expect(resourceDataEntity.value!.name, equals('???'));
      expect(resourceDataEntity.value!.type, equals(DataResourceType.unknown));
      expect(
        resourceDataEntity.value!.href.uri,
        equals(
          Uri(
            path:
                'missing_link',
          ),
        ),
      );
    });

    test('toString, HashCode', () {
      final rawUnknownResource = {
        "name": "???",
        "type": "whatever",
      };

      final resourceDataEntity =
          ResourceDataEntity.fromJson(rawUnknownResource);

      expect(resourceDataEntity.value.toString(), isNot(null));
      expect(resourceDataEntity.value.hashCode, isNot(null));
    });
  });
}
