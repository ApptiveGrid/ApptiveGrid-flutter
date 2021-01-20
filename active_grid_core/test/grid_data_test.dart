import 'package:active_grid_core/active_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    final json = {
      'fieldNames': [
        'TextC',
        'NumberC',
        'DateTimeC',
        'DateC',
        'New field',
        'New field 2',
        'CheckmarkC'
      ],
      'entities': [
        {
          'fields': [
            'Hello',
            1,
            '2020-12-08T01:00:00.000Z',
            '2020-12-13',
            null,
            null,
            true
          ],
          '_id': '3ojhtqm2bgtwzpdbktuv6syv5'
        },
        {
          'fields': [
            'Hola Web',
            1,
            '2020-12-14T09:12:00.000Z',
            '2020-12-15',
            null,
            null,
            true
          ],
          '_id': '6bs7tqexlcy88cry3qzzvjbyz'
        },
        {
          'fields': [null, null, null, null, null, null, false],
          '_id': '6bs7tqf61rppn1nixxb6cr7se'
        },
        {
          'fields': [null, null, null, null, null, null, false],
          '_id': '6bs7tqk85swyk8x1bzxmyowav'
        },
        {
          'fields': [null, null, null, null, null, null, false],
          '_id': '6bs7tqilroemy8o3jl54ece6k'
        },
        {
          'fields': [null, null, null, null, null, null, false],
          '_id': '6bs7tqge7fusxbtwes1pejda8'
        },
        {
          'fields': [null, null, null, null, null, null, false],
          '_id': '6bs7tqi3951seact9e97wiec4'
        },
        {
          'fields': [null, null, null, null, null, null, false],
          '_id': '6bs7tqf01nyoe1rcf3p44rhmr'
        },
        {
          'fields': [null, null, null, null, null, null, false],
          '_id': '6bs7tqlp4zblujta5kxqi8snl'
        },
        {
          'fields': [null, null, null, null, null, null, false],
          '_id': '6bs7tqgw6vmem61thjsnaiepz'
        },
        {
          'fields': [null, null, null, null, null, null, false],
          '_id': '6bs7tqhjv1ir7cl67gng1t9ik'
        },
        {
          'fields': [null, null, null, null, null, null, false],
          '_id': '6bs7tqj5789pomp1y3gmcq1o2'
        },
        {
          'fields': [null, null, null, null, null, null, false],
          '_id': '6bs7tqju10ilc0szdhdgx8z65'
        },
        {
          'fields': [null, null, null, null, null, null, false],
          '_id': '6bs7tqibqyrbw49dm238bkw2p'
        },
        {
          'fields': [
            'AAA',
            null,
            '2020-12-14T11:42:00.000Z',
            '2020-12-17',
            null,
            null,
            true
          ],
          '_id': 'bxzfxf43vaeefhje6xcmnofa8'
        },
        {
          'fields': [
            'TTTTTTT',
            12312344,
            '2020-12-14T06:00:00.000Z',
            '2020-12-16',
            null,
            null,
            true
          ],
          '_id': 'bxzfxf72k3j4d5fcmk6w0pa4s'
        },
        {
          'fields': [null, null, null, null, null, null, false],
          '_id': '2ft7hl2x5ah4np2u3i36264ys'
        },
        {
          'fields': [null, null, null, null, null, null, false],
          '_id': '2ft7hl4vmy025mn7evqn5h78x'
        },
        {
          'fields': [null, null, null, null, null, null, true],
          '_id': '2ft7hl49f1da42yjld9i7623y'
        }
      ],
      'fieldIds': [
        '4zc4l45nmww7ujq7y4axlbtjg',
        '4zc4l48ffin5v8pa2emyx9s15',
        '4zc4l4c5coyi7qh6q1ozrg54u',
        '4zc4l49to77dhfagr844flaey',
        '4zc4l48ez9l3p0gni56z9obo4',
        '4zc4l4ale6sfv3y40hly478z9',
        '4zc4l456pca5ursrt9rxefpsc'
      ],
      'schema': {
        'type': 'object',
        'properties': {
          'fields': {
            'type': 'array',
            'items': [
              {'type': 'string'},
              {'type': 'integer'},
              {'type': 'string', 'format': 'date-time'},
              {'type': 'string', 'format': 'date'},
              {'type': 'string'},
              {'type': 'string'},
              {'type': 'boolean'}
            ]
          },
          '_id': {'type': 'string'}
        }
      },
      'name': 'New grid'
    };

    test('Parses json Response', () {
      final gridData = GridData.fromJson(json);

      expect(gridData.name, 'New grid');
      expect(gridData.schema, isNot(null));
      expect(gridData.fields.length, 7);
      expect(gridData.rows.length, 19);

      final firstRow = gridData.rows[0];
      expect(firstRow.entries[0].data.value, 'Hello');
      expect(firstRow.entries[1].data.value, 1);
    });

    test('From Json == To Json -> FromJson', () {
      final initialData = GridData.fromJson(json);
      final saved = initialData.toJson();
      final restored = GridData.fromJson(saved);

      expect(saved, json);
      expect(restored, initialData);
      expect(restored.hashCode, initialData.hashCode);
    });
  });
}
