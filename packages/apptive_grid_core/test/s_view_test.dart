import 'dart:convert';

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Parses Previews', () {
    const sviews = '''[
  {
    "type": "spreadsheet",
    "id": "63d28a8a78d9ca55c2af8b45",
    "name": "Grid Ansicht",
    "_links": {
      "self": {
        "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/sviews/63d28a8a78d9ca55c2af8b45",
        "method": "get"
      }
    }
  },
  {
    "type": "kanban",
    "id": "63e4a68393cf49ae03b08f1d",
    "name": "Grid Ansicht 3",
    "_links": {
      "self": {
        "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68293cf49beccb08f1b/sviews/63e4a68393cf49ae03b08f1d",
        "method": "get"
      }
    }
  },
  {
    "type": "calendar",
    "id": "63e4a68693cf49beccb08f23",
    "name": "Grid Ansicht 4",
    "_links": {
      "self": {
        "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f21/sviews/63e4a68693cf49beccb08f23",
        "method": "get"
      }
    }
  },
  {
    "type": "map",
    "id": "63e4a68893cf4966e0b08f28",
    "name": "Grid Ansicht 5",
    "_links": {
      "self": {
        "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25/sviews/63e4a68893cf4966e0b08f28",
        "method": "get"
      }
    }
  },
  {
    "type": "gallery",
    "id": "63e4a68893cf4966e0b08f15",
    "name": "Grid Ansicht 6",
    "_links": {
      "self": {
        "href": "/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25/sviews/63e4a68893cf4966e0b08f15",
        "method": "get"
      }
    }
  }
]''';

    final decoded = (jsonDecode(sviews) as List)
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
      const kanbanView =
          '''{"fieldProperties":{"63d28a8978d9ca3100af8b3f":{},"63e4a86993cf49fd11b08f2a":{"isKanbanState":true}},"fields":[{"key":null,"type":{"name":"string","typeName":"string","componentTypes":["textfield"]},"schema":{"type":"string"},"id":"63d28a8978d9ca3100af8b3f","name":"name","_links":{"patch":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f","method":"patch"},"query":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f/query","method":"get"},"self":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f","method":"get"},"extractToGrid":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f/extractToGrid","method":"post"}}},{"key":null,"type":{"options":["A"],"componentTypes":["selectBox","selectList"],"name":"enum","typeName":"enum","extended":false},"schema":{"type":"string","enum":["A"]},"id":"63e4a86993cf49fd11b08f2a","name":"New field","_links":{"patch":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63e4a86993cf49fd11b08f2a","method":"patch"},"query":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63e4a86993cf49fd11b08f2a/query","method":"get"},"self":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63e4a86993cf49fd11b08f2a","method":"get"},"extractToGrid":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63e4a86993cf49fd11b08f2a/extractToGrid","method":"post"}}}],"properties":{"version":2},"type":"kanban","id":"63e4a68393cf49ae03b08f1d","name":"Grid Ansicht 3","_links":{"addShare":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68293cf49beccb08f1b/sviews/63e4a68393cf49ae03b08f1d/shares","method":"post"},"entities":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68293cf49beccb08f1b/entities","method":"get"},"shares":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68293cf49beccb08f1b/sviews/63e4a68393cf49ae03b08f1d/shares","method":"get"},"self":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68293cf49beccb08f1b/sviews/63e4a68393cf49ae03b08f1d","method":"get"},"grid":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68293cf49beccb08f1b","method":"get"},"remove":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68293cf49beccb08f1b/sviews/63e4a68393cf49ae03b08f1d","method":"delete"},"patch":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68293cf49beccb08f1b/sviews/63e4a68393cf49ae03b08f1d","method":"patch"}},"_embedded":{"shares":[]}}''';

      final fromJson = SView.fromJson(jsonDecode(kanbanView));

      expect(fromJson.name, equals('Grid Ansicht 3'));
      expect(fromJson.id, equals('63e4a68393cf49ae03b08f1d'));
      expect(fromJson.type, equals(SViewType.kanban));
      expect(fromJson.fields!.length, 2);
      expect(
        fromJson.fieldProperties!['63e4a86993cf49fd11b08f2a']['isKanbanState'],
        equals(true),
      );

      expect(SView.fromJson(fromJson.toJson()), equals(fromJson));
    });

    test('Parses Full Calendar View', () {
      const calendarView =
          '''{"fieldProperties":{"63e4acde93cf492621b08f2e":{"isStartField":true},"63d28a8978d9ca3100af8b3f":{}},"fields":[{"key":null,"type":{"name":"string","typeName":"string","componentTypes":["textfield"]},"schema":{"type":"string"},"id":"63d28a8978d9ca3100af8b3f","name":"name","_links":{"patch":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f","method":"patch"},"query":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f/query","method":"get"},"self":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f","method":"get"},"extractToGrid":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f/extractToGrid","method":"post"}}},{"key":null,"type":{"name":"date-time","typeName":"date-time","componentTypes":["datePicker"]},"schema":{"type":"string","format":"date-time"},"id":"63e4acde93cf492621b08f2e","name":"Neues Feld 1","_links":{"patch":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63e4acde93cf492621b08f2e","method":"patch"},"query":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63e4acde93cf492621b08f2e/query","method":"get"},"self":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63e4acde93cf492621b08f2e","method":"get"},"extractToGrid":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63e4acde93cf492621b08f2e/extractToGrid","method":"post"}}}],"properties":{"version":2},"type":"calendar","id":"63e4a68693cf49beccb08f23","name":"Grid Ansicht 4","_links":{"addShare":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f21/sviews/63e4a68693cf49beccb08f23/shares","method":"post"},"entities":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f21/entities","method":"get"},"shares":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f21/sviews/63e4a68693cf49beccb08f23/shares","method":"get"},"self":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f21/sviews/63e4a68693cf49beccb08f23","method":"get"},"grid":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f21","method":"get"},"remove":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f21/sviews/63e4a68693cf49beccb08f23","method":"delete"},"patch":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f21/sviews/63e4a68693cf49beccb08f23","method":"patch"}},"_embedded":{"shares":[]}}''';
      final fromJson = SView.fromJson(jsonDecode(calendarView));

      expect(fromJson.name, equals('Grid Ansicht 4'));
      expect(fromJson.id, equals('63e4a68693cf49beccb08f23'));
      expect(fromJson.type, equals(SViewType.calendar));
      expect(fromJson.fields!.length, 2);
      expect(
        fromJson.fieldProperties!['63e4acde93cf492621b08f2e']['isStartField'],
        equals(true),
      );

      expect(SView.fromJson(fromJson.toJson()), equals(fromJson));
    });

    test('Parses Full MapView', () {
      const mapView =
          '''{"fieldProperties":{"63d28a8978d9ca3100af8b3f":{}},"fields":[{"key":null,"type":{"name":"string","typeName":"string","componentTypes":["textfield"]},"schema":{"type":"string"},"id":"63d28a8978d9ca3100af8b3f","name":"name","_links":{"patch":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f","method":"patch"},"query":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f/query","method":"get"},"self":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f","method":"get"},"extractToGrid":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f/extractToGrid","method":"post"}}}],"properties":{"zoomLevel":14,"version":1,"stateFieldId":"63e4ace493cf492621b08f32","mapCenter":{"lng":6.958303812540371,"lat":50.941248064035904}},"type":"map","id":"63e4a68893cf4966e0b08f28","name":"Grid Ansicht 5","_links":{"addShare":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25/sviews/63e4a68893cf4966e0b08f28/shares","method":"post"},"entities":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25/entities","method":"get"},"shares":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25/sviews/63e4a68893cf4966e0b08f28/shares","method":"get"},"self":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25/sviews/63e4a68893cf4966e0b08f28","method":"get"},"grid":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25","method":"get"},"remove":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25/sviews/63e4a68893cf4966e0b08f28","method":"delete"},"patch":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63e4a68693cf495e5ab08f25/sviews/63e4a68893cf4966e0b08f28","method":"patch"}},"_embedded":{"shares":[]}}''';
      final fromJson = SView.fromJson(jsonDecode(mapView));

      expect(fromJson.name, equals('Grid Ansicht 5'));
      expect(fromJson.id, equals('63e4a68893cf4966e0b08f28'));
      expect(fromJson.type, equals(SViewType.map));
      expect(fromJson.fields!.length, 1);
      expect(
        fromJson.properties!['stateFieldId'],
        equals('63e4ace493cf492621b08f32'),
      );

      expect(SView.fromJson(fromJson.toJson()), equals(fromJson));
    });

    test('Parses Full SpreadsheetView', () {
      const spreadSheetView =
          '''{"fieldProperties":{"63d28a8978d9ca3100af8b3f":{}},"fields":[{"key":null,"type":{"name":"string","typeName":"string","componentTypes":["textfield"]},"schema":{"type":"string"},"id":"63d28a8978d9ca3100af8b3f","name":"name","_links":{"patch":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f","method":"patch"},"query":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f/query","method":"get"},"self":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f","method":"get"},"extractToGrid":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca3100af8b3e/fields/63d28a8978d9ca3100af8b3f/extractToGrid","method":"post"}}}],"properties":{"version":1},"type":"spreadsheet","id":"63d28a8a78d9ca55c2af8b45","name":"Grid Ansicht","_links":{"addShare":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/sviews/63d28a8a78d9ca55c2af8b45/shares","method":"post"},"entities":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/entities","method":"get"},"shares":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/sviews/63d28a8a78d9ca55c2af8b45/shares","method":"get"},"self":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/sviews/63d28a8a78d9ca55c2af8b45","method":"get"},"grid":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43","method":"get"},"remove":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/sviews/63d28a8a78d9ca55c2af8b45","method":"delete"},"patch":{"href":"/api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/sviews/63d28a8a78d9ca55c2af8b45","method":"patch"}},"_embedded":{"shares":[]}}''';
      final fromJson = SView.fromJson(jsonDecode(spreadSheetView));

      expect(fromJson.name, equals('Grid Ansicht'));
      expect(fromJson.id, equals('63d28a8a78d9ca55c2af8b45'));
      expect(fromJson.type, equals(SViewType.spreadsheet));
      expect(fromJson.fields!.length, 1);

      expect(SView.fromJson(fromJson.toJson()), equals(fromJson));
    });

    test('Parses Full GalleryView', () {
      const galleryView =
          '''{"fields":[{"name":"Default","id":"639b05e0d8165f7cb0ac2e9b","key":null,"schema":{"type":"string","enum":["A","B","C"]},"type":{"options":["A","B","C"],"componentTypes":["selectBox","selectList"],"name":"enum","typeName":"enum","extended":false},"_links":{"patch":{"href":"/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/639b05e0d8165f7cb0ac2e9a/fields/639b05e0d8165f7cb0ac2e9b","method":"patch"},"query":{"href":"/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/639b05e0d8165f7cb0ac2e9a/fields/639b05e0d8165f7cb0ac2e9b/query","method":"get"},"self":{"href":"/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/639b05e0d8165f7cb0ac2e9a/fields/639b05e0d8165f7cb0ac2e9b","method":"get"},"extractToGrid":{"href":"/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/639b05e0d8165f7cb0ac2e9a/fields/639b05e0d8165f7cb0ac2e9b/extractToGrid","method":"post"}}}],"name":"Radio Test Ansicht 2","id":"64197559dbe97e4cf0b3c4db","fieldProperties":{"639b061fd8165f7cb0ac2eac":{},"639b05e0d8165f7cb0ac2e9b":{},"639b0d42d8165f7301ac2eb7":{},"639b0614d8165f7cb0ac2ea9":{},"639b05fed8165f7cb0ac2ea4":{}},"type":"gallery","properties":{"version":1},"_links":{"addShare":{"href":"/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/64197559dbe97e4cf0b3c4d9/sviews/64197559dbe97e4cf0b3c4db/shares","method":"post"},"entities":{"href":"/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/64197559dbe97e4cf0b3c4d9/entities","method":"get"},"shares":{"href":"/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/64197559dbe97e4cf0b3c4d9/sviews/64197559dbe97e4cf0b3c4db/shares","method":"get"},"self":{"href":"/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/64197559dbe97e4cf0b3c4d9/sviews/64197559dbe97e4cf0b3c4db","method":"get"},"grid":{"href":"/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/64197559dbe97e4cf0b3c4d9","method":"get"},"remove":{"href":"/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/64197559dbe97e4cf0b3c4d9/sviews/64197559dbe97e4cf0b3c4db","method":"delete"},"patch":{"href":"/api/users/614c5440b50f51e3ea8a2a50/spaces/639b05dcd8165f7cb0ac2e98/grids/64197559dbe97e4cf0b3c4d9/sviews/64197559dbe97e4cf0b3c4db","method":"patch"}},"_embedded":{"shares":[]}}''';
      final fromJson = SView.fromJson(jsonDecode(galleryView));

      expect(fromJson.name, equals('Radio Test Ansicht 2'));
      expect(fromJson.id, equals('64197559dbe97e4cf0b3c4db'));
      expect(fromJson.type, equals(SViewType.gallery));
      expect(fromJson.fields!.length, 1);

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
          "method": "get"
        }
      }
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
    });

    test('toString()', () {
      expect(
        jsonView.toString(),
        equals(
          'SView(name: Grid Ansicht, type: SViewType.spreadsheet}, id: 63d28a8a78d9ca55c2af8b45, links: {ApptiveLinkType.self: ApptiveLink(uri: /api/users/609bd67b9fcca3ea397e70c6/spaces/63d28a8578d9ca55c2af8b3c/grids/63d28a8978d9ca2750af8b43/sviews/63d28a8a78d9ca55c2af8b45, method: get)})',
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
          ),
        ),
      );
    });
  });
}
