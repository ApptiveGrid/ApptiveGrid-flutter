import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Space', () {
    group('Parsing', () {
      test('From Json maps correctly', () {
        const id = 'id';
        const name = 'name';
        final grid = GridUri(user: 'user', space: id, grid: 'gridId');

        final jsonSpace = Space.fromJson({
          'id': 'id',
          'name': 'name',
          'gridUris': [
            '/api/users/user/spaces/id/grids/gridId',
          ],
          '_links': {
            'self': {
              'href': '/api/users/user/spaces/id',
              'method': 'get',
            }
          },
        });

        expect(jsonSpace.id, equals(id));
        expect(jsonSpace.name, equals(name));
        expect(jsonSpace.gridUris!.length, equals(1));
        expect(jsonSpace.gridUris![0], equals(grid));
        expect(jsonSpace.links.length, equals(1));
      });

      test('From Json, toJson equals', () {
        final jsonSpace = Space.fromJson({
          'id': 'id',
          'name': 'name',
          'gridUris': [
            '/api/users/user/spaces/id/grids/gridId',
          ],
          'type': 'space',
          '_links': {
            'self': {
              'href': '/api/users/user/spaces/id',
              'method': 'get',
            }
          },
        });

        final doubleParse = Space.fromJson(jsonSpace.toJson());

        expect(doubleParse, equals(jsonSpace));
      });
    });

    group('Equality', () {
      test('Plain and From json equal', () {
        const id = 'id';
        const name = 'name';
        final grid = GridUri(user: 'user', space: id, grid: 'gridId');

        final plain = Space(
          id: id,
          name: name,
          gridUris: [grid],
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
          'gridUris': [
            '/api/users/user/spaces/id/grids/gridId',
          ],
          'type': 'space',
          '_links': {
            'self': {
              'href': '/api/users/user/spaces/id',
              'method': 'get',
            }
          },
        });

        expect(plain, equals(jsonSpace));
        expect(plain.hashCode, equals(jsonSpace.hashCode));
      });

      test('Plain and From json not equal with different values', () {
        const id = 'id';
        const name = 'name';

        final plain = Space(
          id: id,
          name: name,
          gridUris: [],
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
          'gridUris': [
            '/api/users/user/spaces/id/grids/gridId',
          ]
        });

        expect(plain, isNot(jsonSpace));
        expect(plain.hashCode, isNot(jsonSpace.hashCode));
      });
    });
  });

  group('sharedSpace', () {
    group('Parsing', () {
      test('From Json maps correctly', () {
        const id = 'id';
        const name = 'name';
        final grid = GridUri(user: 'user', space: id, grid: 'gridId');

        final jsonSharedSpace = SharedSpace.fromJson({
          'id': 'id',
          'name': 'name',
          'gridUris': [
            '/api/users/user/spaces/id/grids/gridId',
          ],
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
        expect(jsonSharedSpace.gridUris!.length, equals(1));
        expect(jsonSharedSpace.gridUris![0], equals(grid));
        expect(jsonSharedSpace.links.length, equals(1));
      });

      test('From Json, toJson equals', () {
        final jsonSharedSpace = SharedSpace.fromJson({
          'id': 'id',
          'name': 'name',
          'gridUris': [
            '/api/users/user/spaces/id/grids/gridId',
          ],
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
        final space = Space.fromJson({'id': 'id',
          'name': 'name',
          'gridUris': [
            '/api/users/user/spaces/id/grids/gridId',
          ],
          'type': 'sharedSpace',
          'realSpace': 'realSpace.uri',
          '_links': {
            'self': {
              'href': '/api/users/user/spaces/id',
              'method': 'get',
            }
          },});

        expect(space.runtimeType, equals(SharedSpace));
      });
    });

    group('Equality', () {
      test('Plain and From json equal', () {
        const id = 'id';
        const name = 'name';
        final grid = GridUri(user: 'user', space: id, grid: 'gridId');
        final realSpace = Uri.parse('realSpace.uri');

        final plain = SharedSpace(
          id: id,
          name: name,
          gridUris: [grid],
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
          'gridUris': [
            '/api/users/user/spaces/id/grids/gridId',
          ],
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
        expect(plain.hashCode, equals(jsonSharedSpace.hashCode));
      });

      test('Plain and From json not equal with different values', () {
        const id = 'id';
        const name = 'name';
        final realSpace = Uri.parse('realSpace.uri');

        final plain = SharedSpace(
          id: id,
          name: name,
          gridUris: [],
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
          'type': 'sharedSpace',
          'gridUris': [
            '/api/users/user/spaces/id/grids/gridId',
          ],
          'realSpace': 'realSpace.uri',
        });

        expect(plain, isNot(jsonSharedSpace));
        expect(plain.hashCode, isNot(jsonSharedSpace.hashCode));
      });
    });
  });
}
