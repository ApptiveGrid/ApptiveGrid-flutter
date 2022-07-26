import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Space', () {
    group('Parsing', () {
      test('From Json maps correctly', () {
        const id = 'id';
        const name = 'name';

        final jsonSpace = Space.fromJson({
          'id': 'id',
          'name': 'name',
          '_links': {
            'self': {
              'href': '/api/users/user/spaces/id',
              'method': 'get',
            }
          },
        });

        expect(jsonSpace.id, equals(id));
        expect(jsonSpace.name, equals(name));
        expect(jsonSpace.links.length, equals(1));
      });

      test('From Json, toJson equals', () {
        final jsonSpace = Space.fromJson({
          'id': 'id',
          'name': 'name',
          'type': 'space',
          'key': 'key',
          'belongsTo': 'belongsTo',
          '_links': {
            'self': {
              'href': '/api/users/user/spaces/id',
              'method': 'get',
            },
          },
          '_embedded': {
            'grids': [
              {
                'id': 'gridId',
                'name': 'Grid',
                '_links': {
                  'self': {
                    'href': '/api/users/user/spaces/id/grid/gridId',
                    'method': 'get',
                  },
                },
              },
            ],
          },
        });

        final doubleParse = Space.fromJson(jsonSpace.toJson());

        expect(doubleParse, equals(jsonSpace));
        expect(jsonSpace.key, equals('key'));
        expect(jsonSpace.category, equals('belongsTo'));
      });
    });

    group('Equality', () {
      test('Plain and From json equal', () {
        const id = 'id';
        const name = 'name';

        final plain = Space(
          id: id,
          name: name,
          embeddedGrids: [
            Grid(
              id: 'gridId',
              name: 'Grid',
              links: {
                ApptiveLinkType.self: ApptiveLink(
                  uri: Uri.parse('/api/users/user/spaces/id/grids/gridId'),
                  method: 'get',
                )
              },
            ),
          ],
          links: {
            ApptiveLinkType.self: ApptiveLink(
              uri: Uri.parse('/api/users/user/spaces/id'),
              method: 'get',
            ),
          },
        );

        final jsonSpace = Space.fromJson({
          'id': 'id',
          'name': 'name',
          '_embedded': {
            'grids': [
              {
                'id': 'gridId',
                'name': 'Grid',
                '_links': {
                  'self': {
                    'href': '/api/users/user/spaces/id/grids/gridId',
                    'method': 'get',
                  },
                },
              },
            ],
          },
          'type': 'space',
          '_links': {
            'self': {
              'href': '/api/users/user/spaces/id',
              'method': 'get',
            }
          },
        });

        expect(plain, equals(jsonSpace));
      });

      test('Plain and From json not equal with different values', () {
        const id = 'id';
        const name = 'name';

        final plain = Space(
          id: id,
          name: name,
          links: {
            ApptiveLinkType.self: ApptiveLink(
              uri: Uri.parse('/api/users/user/spaces/id'),
              method: 'get',
            ),
          },
        );

        final jsonSpace = Space.fromJson({
          'id': 'id',
          'name': 'name',
          'type': 'space',
        });

        expect(plain, isNot(jsonSpace));
      });
    });

    test('Hashcode', () {
      final space = Space(id: 'id', name: 'name', links: {});

      expect(
        space.hashCode,
        equals(Object.hash('id', 'name', null, null, space.links, null)),
      );
    });

    test('toString()', () {
      final space = Space(id: 'id', name: 'name', links: {});

      expect(
        space.toString(),
        equals(
          'Space(name: name, id: id, key: null, category: null, links: {}, embeddedGrids: null)',
        ),
      );
    });
  });

  group('sharedSpace', () {
    group('Parsing', () {
      test('From Json maps correctly', () {
        const id = 'id';
        const name = 'name';

        final jsonSharedSpace = SharedSpace.fromJson({
          'id': 'id',
          'name': 'name',
          'realSpace': 'realSpace.uri',
          '_links': {
            'self': {
              'href': '/api/users/user/spaces/id',
              'method': 'get',
            }
          },
        });

        expect(jsonSharedSpace.id, equals(id));
        expect(jsonSharedSpace.name, equals(name));
        expect(jsonSharedSpace.links.length, equals(1));
      });

      test('From Json, toJson equals', () {
        final jsonSharedSpace = SharedSpace.fromJson({
          'id': 'id',
          'name': 'name',
          'realSpace': 'realSpace.uri',
          'type': 'sharedSpace',
          '_links': {
            'self': {
              'href': '/api/users/user/spaces/id',
              'method': 'get',
            }
          },
        });

        final doubleParse = SharedSpace.fromJson(jsonSharedSpace.toJson());

        expect(doubleParse, equals(jsonSharedSpace));
      });

      test('Space.fromJson returns shared Space', () {
        final space = Space.fromJson({
          'id': 'id',
          'name': 'name',
          'type': 'sharedSpace',
          'realSpace': 'realSpace.uri',
          '_links': {
            'self': {
              'href': '/api/users/user/spaces/id',
              'method': 'get',
            },
          },
        });

        expect(space.runtimeType, equals(SharedSpace));
      });
    });

    group('Equality', () {
      test('Plain and From json equal', () {
        const id = 'id';
        const name = 'name';
        final realSpace = Uri.parse('realSpace.uri');

        final plain = SharedSpace(
          id: id,
          name: name,
          realSpace: realSpace,
          links: {
            ApptiveLinkType.self: ApptiveLink(
              uri: Uri.parse('/api/users/user/spaces/id'),
              method: 'get',
            ),
          },
        );

        final jsonSharedSpace = SharedSpace.fromJson({
          'id': 'id',
          'name': 'name',
          'realSpace': 'realSpace.uri',
          'type': 'sharedSpace',
          '_links': {
            'self': {
              'href': '/api/users/user/spaces/id',
              'method': 'get',
            }
          },
        });

        expect(plain, equals(jsonSharedSpace));
      });

      test('Plain and From json not equal with different values', () {
        const id = 'id';
        const name = 'name';
        final realSpace = Uri.parse('realSpace.uri');

        final plain = SharedSpace(
          id: id,
          name: name,
          realSpace: realSpace,
          embeddedGrids: [
            Grid(
              id: 'gridId',
              name: 'Grid',
              links: {
                ApptiveLinkType.self: ApptiveLink(
                  uri: Uri.parse('/api/users/user/spaces/id/grids/gridId'),
                  method: 'get',
                ),
              },
            ),
          ],
          links: {
            ApptiveLinkType.self: ApptiveLink(
              uri: Uri.parse('/api/users/user/spaces/id'),
              method: 'get',
            ),
          },
        );

        final jsonSharedSpace = SharedSpace.fromJson({
          'id': 'id',
          'name': 'name',
          'type': 'sharedSpace',
          'realSpace': 'realSpace.uri',
          '_embedded': {
            'grids': [
              {
                'id': 'gridId',
                'name': 'Grid',
                '_links': {
                  'self': {
                    'href': '/api/users/user/spaces/id/grid/gridId',
                    'method': 'get',
                  },
                },
              },
            ],
          },
        });

        expect(plain, isNot(jsonSharedSpace));
      });
    });
    test('Hashcode', () {
      final space = SharedSpace(
        realSpace: Uri(path: 'realSpace'),
        id: 'id',
        name: 'name',
        links: {},
      );

      expect(
        space.hashCode,
        equals(
          Object.hash(
            'id',
            'name',
            Uri(path: 'realSpace'),
            null,
            null,
            space.links,
            null,
          ),
        ),
      );
    });

    test('toString()', () {
      final space = SharedSpace(
        realSpace: Uri(path: 'realSpace'),
        id: 'id',
        name: 'name',
        links: {},
      );

      expect(
        space.toString(),
        equals(
          'SharedSpace(name: name, id: id, key: null, category: null, realSpace: realSpace, links: {}, embeddedGrids: null)',
        ),
      );
    });
  });
}
