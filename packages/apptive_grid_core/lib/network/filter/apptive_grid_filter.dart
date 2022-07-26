import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/foundation.dart';

part 'package:apptive_grid_core/network/filter/field_filter.dart';
part 'package:apptive_grid_core/network/filter/filter_expressions.dart';

/// Filter to load a Grid with a specific Filter
///
/// Available Filters are
///
/// Compositional Filters
/// [AndFilterComposition], [OrFilterComposition]
///
/// Available for all [DataEntity]
/// [EqualsFilter]
///
/// String Filter
/// [SubstringFilter]
///
/// [ComparableDataEntity] Filter
/// [GreaterThanFilter], [LesserThanFilter]
///
/// [CollectionDataEntity] Filter
/// [AnyOfFilter], [AllOfFilter], [NoneOfFilter]
///
abstract class ApptiveGridFilter {
  const ApptiveGridFilter._();

  /// Creates a Map Object that can be send to the Backend. (Should be json encoded)
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return '$runtimeType(${toJson().toString()})';
  }
}

/// Mixin for DataEntities that can be used in Filters
mixin FilterableMixin {
  /// The value that is used to create the filter
  /// For implementations of [DataEntity] this is usually the [DataEntity.schemaValue]
  dynamic get filterValue;
}

/// Mixin for DataEntities that support Comparison Filters like [LesserThanFilter] and [GreaterThanFilter]
mixin ComparableFilterableMixin on FilterableMixin {}

/// Mixin for DataEntities that support Collection Filters like [AnyOfFilter], [AllOfFilter] and [NoneOfFilter]
mixin CollectionFilterableMixin on FilterableMixin {}

/// Mixin for Filtering on [DataType.createdBy] to check if they have been created by a specific Actor
mixin ActorFilterableMixin on FilterableMixin {}

enum _ComposeOperator {
  and,
  or,
}

/// Super class for Filter Compositions to combine multiple filters
abstract class _FilterComposition extends ApptiveGridFilter {
  const _FilterComposition._({
    required this.operator,
    required this.conditions,
  }) : super._();

  final _ComposeOperator operator;
  final List<ApptiveGridFilter> conditions;

  @override
  Map<String, dynamic> toJson() => {
        '\$${operator.name}':
            conditions.map((condition) => condition.toJson()).toList(),
      };

  @override
  bool operator ==(Object other) {
    return other is _FilterComposition &&
        operator == other.operator &&
        listEquals(conditions, other.conditions);
  }

  @override
  int get hashCode => Object.hash(operator, conditions);
}

/// Creates a Filter that checks that all [conditions] are true
class AndFilterComposition extends _FilterComposition {
  /// Creates a Filter that checks that all [conditions] are true
  const AndFilterComposition({required super.conditions})
      : super._(operator: _ComposeOperator.and);
}

/// Creates a Filter that checks that one [FilterCondition] in [conditions] is true
class OrFilterComposition extends _FilterComposition {
  /// Creates a Filter that checks that one [FilterCondition] in [conditions] is true
  const OrFilterComposition({required super.conditions})
      : super._(operator: _ComposeOperator.or);
}

/// Filter to negate a specific [filter]
class NotFilter extends ApptiveGridFilter {
  /// Creates a new [ApptiveGridFilter] that negates a given [filter]
  const NotFilter({required this.filter}) : super._();

  /// The [ApptiveGridFilter] that should be negated
  final ApptiveGridFilter filter;

  @override
  Map<String, dynamic> toJson() => {
        '\$not': filter.toJson(),
      };

  @override
  bool operator ==(Object other) {
    return other is NotFilter && filter == other.filter;
  }

  @override
  int get hashCode => filter.hashCode;
}
