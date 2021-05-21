import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Parsing', () {
    test('From Json maps correctly', () {
      final id = 'id';
      final name = 'name';
      final grid = GridUri(user: 'user', space: id, grid: 'gridId');

      final jsonSpace = Space.fromJson({
        'id': 'id',
        'name': 'name',
        'gridUris': [
          '/api/users/user/spaces/id/grids/gridId',
        ]
      });

      expect(jsonSpace.id, id);
      expect(jsonSpace.name, name);
      expect(jsonSpace.grids.length, 1);
      expect(jsonSpace.grids[0], grid);
    });

    test('From Json, toJson equals', () {
      final jsonSpace = Space.fromJson({
        'id': 'id',
        'name': 'name',
        'gridUris': [
          '/api/users/user/spaces/id/grids/gridId',
        ]
      });

      final doubleParse = Space.fromJson(jsonSpace.toJson());

      expect(doubleParse, jsonSpace);
    });
  });

  group('Equality', () {
    test('Plain and From json equal', () {
      final id = 'id';
      final name = 'name';
      final grid = GridUri(user: 'user', space: id, grid: 'gridId');

      final plain = Space(id: id, name: name, grids: [grid]);

      final jsonSpace = Space.fromJson({
        'id': 'id',
        'name': 'name',
        'gridUris': [
          '/api/users/user/spaces/id/grids/gridId',
        ]
      });

      expect(plain, jsonSpace);
      expect((plain.hashCode - jsonSpace.hashCode) == 0, true);
    });

    test('Plain and From json not equal with different values', () {
      final id = 'id';
      final name = 'name';

      final plain = Space(id: id, name: name, grids: []);

      final jsonSpace = Space.fromJson({
        'id': 'id',
        'name': 'name',
        'gridUris': [
          '/api/users/user/spaces/id/grids/gridId',
        ]
      });

      expect(plain == jsonSpace, false);
      expect((plain.hashCode - jsonSpace.hashCode) == 0, false);
    });
  });
}
