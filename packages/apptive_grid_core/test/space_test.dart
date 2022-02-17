import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
        ]
      });

      expect(jsonSpace.id, equals(id));
      expect(jsonSpace.name, equals(name));
      expect(jsonSpace.grids.length, equals(1));
      expect(jsonSpace.grids[0], equals(grid));
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

      expect(doubleParse, equals(jsonSpace));
    });
  });

  group('Equality', () {
    test('Plain and From json equal', () {
      const id = 'id';
      const name = 'name';
      final grid = GridUri(user: 'user', space: id, grid: 'gridId');

      final plain = Space(id: id, name: name, grids: [grid]);

      final jsonSpace = Space.fromJson({
        'id': 'id',
        'name': 'name',
        'gridUris': [
          '/api/users/user/spaces/id/grids/gridId',
        ]
      });

      expect(plain, equals(jsonSpace));
      expect(plain.hashCode, equals(jsonSpace.hashCode));
    });

    test('Plain and From json not equal with different values', () {
      const id = 'id';
      const name = 'name';

      final plain = Space(id: id, name: name, grids: []);

      final jsonSpace = Space.fromJson({
        'id': 'id',
        'name': 'name',
        'gridUris': [
          '/api/users/user/spaces/id/grids/gridId',
        ]
      });

      expect(plain, isNot(jsonSpace));
      expect(plain.hashCode, isNot(jsonSpace.hashCode));
    });
  });
}
