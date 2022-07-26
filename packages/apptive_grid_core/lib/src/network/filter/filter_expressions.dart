part of 'package:apptive_grid_core/src/network/filter/apptive_grid_filter.dart';

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
  int get hashCode => expression.hashCode;
}

/// Filter Columns with Type [DataType.date] to today.
class Today extends _FilterExpression with ComparableFilterableMixin {
  /// Creates a Filterable Object that can be used to filter a [DataType.date] column for today
  const Today() : super(expression: 'today()');
}

/// Filter columns by the logged in user
/// This works for [DataType.createdBy] and [DataType.assignee]
/// If filtering for a field with [DataType.createdBy] you should combine it with [ActorFilter]
class LoggedInUser extends _FilterExpression with ActorFilterableMixin {
  /// Creates a Filter Expression to check the loggedIn User
  const LoggedInUser() : super(expression: 'loggedInUser()');
}
