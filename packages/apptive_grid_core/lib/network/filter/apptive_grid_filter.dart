import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/foundation.dart';

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
    return toJson().toString();
  }
}

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
  int get hashCode => toString().hashCode;
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

/// Filter Operators for Filters that check on a Field
enum _FieldOperator {
  substring(operation: 'substring'),
  equal(operation: '='),
  greaterThan(operation: 'gt'),
  lesserThan(operation: 'lt'),

  // Collections
  any(operation: 'hasAnyOf'),
  all(operation: 'hasAllOf'),
  none(operation: 'hasNoneOf');

  const _FieldOperator({required this.operation});

  final String operation;
}

/// Filter to check for a single Field with [fieldId]
abstract class _FieldFilter extends ApptiveGridFilter {
  const _FieldFilter._({
    required this.operator,
    required this.fieldId,
    required this.value,
  }) : super._();

  final _FieldOperator operator;
  final String fieldId;
  final DataEntity value;

  @override
  Map<String, dynamic> toJson() {
    if (operator == _FieldOperator.equal) {
      return {fieldId: value.schemaValue};
    }
    return {
      fieldId: {'\$${operator.operation}': value.schemaValue}
    };
  }

  @override
  bool operator ==(Object other) {
    return other is _FieldFilter &&
        operator == other.operator &&
        fieldId == other.fieldId &&
        value == other.value;
  }

  @override
  int get hashCode => toString().hashCode;
}

/// Filter to check for a Substring
///
/// Only available with [StringDataEntity]
class SubstringFilter extends _FieldFilter {
  /// Creates a Filter that checks if the [StringDataEntity.schemaValue] of [value] is a substring in a [GridField] with [fieldId]
  const SubstringFilter({
    required super.fieldId,
    required StringDataEntity super.value,
  }) : super._(
          operator: _FieldOperator.substring,
        );
}

/// Filter to check if a [GridField]'s value is equal to [value]
class EqualsFilter extends _FieldFilter {
  /// Creates a Filter that checks if [DataEntity.value] equals the [fieldId] [GridField]
  const EqualsFilter({
    required super.fieldId,
    required super.value,
  }) : super._(
          operator: _FieldOperator.equal,
        );
}

/// Filter to check if a value is greater than [value]
class GreaterThanFilter extends _FieldFilter {
  /// Creates a Filter that checks if [value] is greater than the [GridField] with [fieldId]
  ///
  /// Only possible with [ComparableDataEntity]
  const GreaterThanFilter({
    required super.fieldId,
    required ComparableDataEntity super.value,
  }) : super._(
          operator: _FieldOperator.greaterThan,
        );
}

/// Filter to check if a value is lesser than [value]
class LesserThanFilter extends _FieldFilter {
  /// Creates a Filter that checks if [value] is lesser than the [GridField] with [fieldId]
  ///
  /// Only possible with [ComparableDataEntity]
  const LesserThanFilter({
    required super.fieldId,
    required ComparableDataEntity super.value,
  }) : super._(
          operator: _FieldOperator.lesserThan,
        );
}

/// Filter to check if a [CollectionDataEntity] contains any of the values in [value]
class AnyOfFilter extends _FieldFilter {
  /// Creates a Filter that checks if [GridField] with [fieldId] value contains any of the values present in [values]
  ///
  /// Only possible with [CollectionDataEntity]
  const AnyOfFilter({
    required super.fieldId,
    required CollectionDataEntity super.value,
  }) : super._(
          operator: _FieldOperator.any,
        );
}

/// Filter to check if a [CollectionDataEntity] contains all of the values in [value]
class AllOfFilter extends _FieldFilter {
  /// Creates a Filter that checks if [GridField] with [fieldId] value contains all of the values present in [values]
  ///
  /// Only possible with [CollectionDataEntity]
  const AllOfFilter({
    required super.fieldId,
    required CollectionDataEntity super.value,
  }) : super._(
          operator: _FieldOperator.all,
        );
}

/// Filter to check if a [CollectionDataEntity] contains none of the values in [value]
class NoneOfFilter extends _FieldFilter {
  /// Creates a Filter that checks if [GridField] with [fieldId] value contains none of the values present in [values]
  ///
  /// Only possible with [CollectionDataEntity]
  const NoneOfFilter({
    required super.fieldId,
    required CollectionDataEntity super.value,
  }) : super._(
          operator: _FieldOperator.none,
        );
}
