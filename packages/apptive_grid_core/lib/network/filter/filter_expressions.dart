part of 'package:apptive_grid_core/network/filter/apptive_grid_filter.dart';

abstract class _FilterExpression with FilterableMixin {
  const _FilterExpression({required this.expression});

  final String expression;

  @override
  dynamic get filterValue => '{{ $expression }}';

  @override
  operator ==(covariant other) {
    return other is _FilterExpression && expression == other.expression;
  }

  @override
  int get hashCode => toString().hashCode;
}

/// Filter Columns with Type [DataType.date] to today.
class Today extends _FilterExpression with ComparableFilterableMixin {
  /// Creates a Filterable Object that can be used to filter a [DataType.date] column for today
  const Today() : super(expression: 'today()');
}


