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
        "metaType": "space",
      };

      final resourceDataEntity = ResourceDataEntity.fromJson(rawSpaceResource);

      expect(resourceDataEntity.value, isNot(null));
      expect(resourceDataEntity.value!.name, equals('Resource Space'));
      expect(resourceDataEntity.value!.type, equals(DataResourceType.space));
      expect(
        resourceDataEntity.value!.metaType,
        equals(DataResourceMetaType.space),
      );
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
        resourceDataEntity.value!.metaType,
        equals(DataResourceMetaType.unknown),
      );
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
        resourceDataEntity.value!.metaType,
        equals(DataResourceMetaType.unknown),
      );
      expect(
        resourceDataEntity.value!.href.uri,
        equals(
          Uri(
            path: 'missing_link',
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

  group('Server contract', () {
    const uri =
        '/api/users/66719e4c8f83ff0c88d77dc1/spaces/66f415f8e26ae86e74df53b0';

    test('schemaValue carries a top-level href next to the object', () {
      // The backend's AGResourceType resolves a written value through `href`
      // only; the rest is kept so cached forms round-trip losslessly.
      final entity = ResourceDataEntity(
        DataResource(
          href: ApptiveLink(uri: Uri.parse(uri), method: 'get'),
          type: DataResourceType.space,
          name: 'Resource Space',
          metaType: DataResourceMetaType.space,
        ),
      );

      expect(entity.schemaValue, containsPair('href', uri));
      expect(entity.schemaValue, containsPair('name', 'Resource Space'));
      expect(entity.schemaValue, containsPair('type', 'space'));
      expect(entity.schemaValue, containsPair('metaType', 'space'));
      expect(entity.schemaValue['_links']['self']['href'], equals(uri));
    });

    test('schemaValue of an empty entity is null', () {
      expect(ResourceDataEntity().schemaValue, isNull);
    });

    test('fromJson accepts a bare href', () {
      final resource = DataResource.fromJson({'href': uri});

      expect(resource.href.uri, equals(Uri.parse(uri)));
      expect(resource.type, equals(DataResourceType.unknown));
      expect(resource.metaType, equals(DataResourceMetaType.unknown));
    });

    test('fromJson accepts a bare uri', () {
      final resource = DataResource.fromJson({'uri': uri, 'name': 'Legacy'});

      expect(resource.href.uri, equals(Uri.parse(uri)));
      expect(resource.name, equals('Legacy'));
    });

    test('_links.self wins over a bare href', () {
      final resource = DataResource.fromJson({
        '_links': {
          'self': {'href': uri, 'method': 'get'},
        },
        'href': '/somewhere/else',
      });

      expect(resource.href.uri, equals(Uri.parse(uri)));
    });

    test('schemaValue round trips through fromJson', () {
      final entity = ResourceDataEntity(
        DataResource(
          href: ApptiveLink(uri: Uri.parse(uri), method: 'get'),
          type: DataResourceType.form,
          name: 'Contact',
          metaType: DataResourceMetaType.form,
        ),
      );

      final restored = ResourceDataEntity.fromJson(entity.schemaValue);

      expect(restored.value, equals(entity.value));
      expect(restored.schemaValue, equals(entity.schemaValue));
    });

    test('unknown resource types and meta types still fall back', () {
      final resource = DataResource.fromJson({
        'href': uri,
        'type': 'flowInstance',
        'metaType': 'externalHook',
      });

      expect(resource.type, equals(DataResourceType.flowInstance));
      expect(resource.metaType, equals(DataResourceMetaType.externalHook));
    });
  });

  group('Resources link', () {
    test('linkMapFromJson recognises the resources link of a field', () {
      final links = linkMapFromJson({
        'self': {'href': '/api/a/grids/g/fields/f', 'method': 'get'},
        'resources': {
          'href': '/api/a/spaces/s/resources?types=grid,form',
          'method': 'get',
        },
      });

      expect(
        links[ApptiveLinkType.resources]?.uri,
        equals(Uri.parse('/api/a/spaces/s/resources?types=grid,form')),
      );
    });
  });
}
