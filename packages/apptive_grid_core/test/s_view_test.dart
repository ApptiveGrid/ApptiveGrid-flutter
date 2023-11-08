import 'dart:convert';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'infrastructure/sview_json_responses.dart';

void main() {
  test('Parses Previews', () {
    final decoded = (jsonDecode(sviewPreviewsJson) as List)
        .map((sview) => SView.fromJson(sview))
        .toList();

    expect(decoded.length, 5);
    expect(decoded[0].type, SViewType.spreadsheet);
    expect(decoded[1].type, SViewType.kanban);
    expect(decoded[2].type, SViewType.calendar);
    expect(decoded[3].type, SViewType.map);
    expect(decoded[4].type, SViewType.gallery);
  });

  group('Full Views', () {
    test('Parses Full KanbanView', () {
      final fromJson = SView.fromJson(jsonDecode(kanbanSViewJson));

      expect(fromJson.name, equals('Grid Ansicht 3'));
      expect(fromJson.id, equals('63e4a68393cf49ae03b08f1d'));
      expect(fromJson.type, equals(SViewType.kanban));
      expect(
        fromJson.slotProperties!['63e4a86993cf49fd11b08f2a']['isKanbanState'],
        equals(true),
      );
      // ignore: deprecated_member_use_from_same_package
      expect(fromJson.fieldProperties, equals(fromJson.slotProperties));
      expect(fromJson.fields!.map((e) => e.id).toList(), [
        '63d28a8978d9ca3100af8b3f',
        '63e4a86993cf49fd11b08f2a',
      ]);

      expect(SView.fromJson(fromJson.toJson()), equals(fromJson));
    });

    test('Parses Full Calendar View', () {
      final fromJson = SView.fromJson(jsonDecode(calendarSViewJson));

      expect(fromJson.name, equals('Grid Ansicht 4'));
      expect(fromJson.id, equals('63e4a68693cf49beccb08f23'));
      expect(fromJson.type, equals(SViewType.calendar));
      expect(
        fromJson.slotProperties?['63e4acde93cf492621b08f2e']['isStartField'],
        equals(true),
      );
      // ignore: deprecated_member_use_from_same_package
      expect(fromJson.fieldProperties, equals(fromJson.slotProperties));
      expect(fromJson.fields!.map((e) => e.id).toList(), [
        '63d28a8978d9ca3100af8b3f',
        '63e4acde93cf492621b08f2e',
      ]);

      expect(SView.fromJson(fromJson.toJson()), equals(fromJson));
    });

    test('Parses Full MapView', () {
      final fromJson = SView.fromJson(jsonDecode(mapSViewJson));

      expect(fromJson.name, equals('Grid Ansicht 5'));
      expect(fromJson.id, equals('63e4a68893cf4966e0b08f28'));
      expect(fromJson.type, equals(SViewType.map));
      expect(
        fromJson.properties!['stateFieldId'],
        equals('63e4ace493cf492621b08f32'),
      );
      // ignore: deprecated_member_use_from_same_package
      expect(fromJson.fieldProperties, equals(fromJson.slotProperties));
      expect(
        fromJson.fields!.map((e) => e.id).toList(),
        ['63d28a8978d9ca3100af8b3f'],
      );

      expect(SView.fromJson(fromJson.toJson()), equals(fromJson));
    });

    test('Parses Full SpreadsheetView', () {
      final fromJson = SView.fromJson(jsonDecode(spreadsheetSViewJson));

      expect(fromJson.name, equals('Grid Ansicht'));
      expect(fromJson.id, equals('63d28a8a78d9ca55c2af8b45'));
      expect(fromJson.type, equals(SViewType.spreadsheet));
      expect(
        fromJson.fields!.map((e) => e.id).toList(),
        ['63d28a8978d9ca3100af8b3f'],
      );
      // ignore: deprecated_member_use_from_same_package
      expect(fromJson.fieldProperties, equals(fromJson.slotProperties));

      expect(SView.fromJson(fromJson.toJson()), equals(fromJson));
    });

    test('Parses Full GalleryView', () {
      final fromJson = SView.fromJson(jsonDecode(gallerySViewJson));

      expect(fromJson.name, equals('Radio Test Ansicht 2'));
      expect(fromJson.id, equals('64197559dbe97e4cf0b3c4db'));
      expect(fromJson.type, equals(SViewType.gallery));
      expect(
        fromJson.fields!.map((e) => e.id).toList(),
        ['639b05e0d8165f7cb0ac2e9b'],
      );
      // ignore: deprecated_member_use_from_same_package
      expect(fromJson.fieldProperties, equals(fromJson.slotProperties));

      expect(SView.fromJson(fromJson.toJson()), equals(fromJson));
    });
  });

  group('Basic Creation, equals, toString()', () {
    final jsonView = SView.fromJson({
      "type": "spreadsheet",
      "id": "63d28a8a78d9ca55c2af8b45",
      "name": "Grid Ansicht",
      "_links": {
        "self": {
          "href":
              "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/sviews/63d28a8a78d9ca55c2af8b45",
          "method": "get",
        },
      },
    });

    test('Direct, equals json', () {
      final direct = SView(
        name: 'Grid Ansicht',
        id: '63d28a8a78d9ca55c2af8b45',
        type: SViewType.spreadsheet,
        links: {
          ApptiveLinkType.self: ApptiveLink(
            uri: Uri.parse(
              '/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/sviews/63d28a8a78d9ca55c2af8b45',
            ),
            method: 'GET',
          ),
        },
      );

      expect(direct, equals(jsonView));
      // ignore: deprecated_member_use_from_same_package
      expect(direct.fieldProperties, equals(null));
    });

    test('toString()', () {
      expect(
        jsonView.toString(),
        equals(
          'SView(name: Grid Ansicht, type: SViewType.spreadsheet, id: 63d28a8a78d9ca55c2af8b45, links: {ApptiveLinkType.self: ApptiveLink(uri: /api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/sviews/63d28a8a78d9ca55c2af8b45, method: get)}, slotProperties: null, field: null  slots: null, properties: null)',
        ),
      );
    });

    test('Hashcode', () {
      expect(
        jsonView.hashCode,
        equals(
          Object.hash(
            '63d28a8a78d9ca55c2af8b45',
            'Grid Ansicht',
            SViewType.spreadsheet,
            jsonView.links,
            null,
            null,
            null,
            null,
            null,
          ),
        ),
      );
    });
  });

  group('Parse deprecated format', () {
    test('Parse spreadsheet grid view', () {
      final sview = SView.fromJson(jsonDecode(depericatedSpreadsheetSViewJson));

      expect(sview.type, equals(SViewType.spreadsheet));
      // ignore: deprecated_member_use_from_same_package
      expect(sview.slotProperties, equals(sview.fieldProperties));
    });

    test('Parse old kanban', () {
      final sview = SView.fromJson(jsonDecode(deprecatedCanbanSViewJson));

      expect(sview.type, equals(SViewType.kanban));
      expect(
        // ignore: deprecated_member_use_from_same_package
        sview.fieldProperties!['77ugrb8mc6qy2ujwmw5bkimtd']['isKanbanState'],
        equals(true),
      );
      // ignore: deprecated_member_use_from_same_package
      expect(sview.slotProperties, equals(sview.fieldProperties));
    });
  });

  group('SViewSlots', () {
    final jsonSlot = SViewSlot.fromJson(
      {
        'position': 1,
        'name': 'name',
        'key': 'key',
        'type': {'name': 'string'},
      },
    );
    test('Direct, equals json', () {
      final direct = SViewSlot(
        position: 1,
        name: 'name',
        key: 'key',
        type: DataType.text,
      );

      expect(direct, equals(jsonSlot));
    });

    test('toString()', () {
      expect(
        jsonSlot.toString(),
        equals(
          'SViewSlot(position: 1, key: key, name: name type: DataType.text)',
        ),
      );
    });

    test('Hashcode', () {
      expect(
        jsonSlot.hashCode,
        equals(
          Object.hash(
            1,
            'key',
            'name',
            DataType.text,
          ),
        ),
      );
    });
  });
}
