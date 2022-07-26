part of 'package:apptive_grid_core/network/filter/apptive_grid_filter.dart';

/// Filter Operators for Filters that check on a Field
enum _FieldOperator {
  substring(operation: 'substring'),
  equal(operation: 'eq'),
  greaterThan(operation: 'gt'),
  lesserThan(operation: 'lt'),
  empty(operation: 'isEmpty'),

  // Collections
  any(operation: 'hasAnyOf'),
  all(operation: 'hasAllOf'),
  none(operation: 'hasNoneOf'),

  // Other
  actor(operation: 'isActor');

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
  final FilterableMixin value;

  @override
  Map<String, dynamic> toJson() {
    return {
      fieldId: {'\$${operator.operation}': value.filterValue}
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
  int get hashCode => Object.hash(operator, fieldId, value);
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
///
/// Note: previously this was used to check for the value of Fields with [DataType.createdBy]. If you for example used a EqualsFilter with [LoggedInUser] please switch to a [ActorFilter]
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
    required ComparableFilterableMixin super.value,
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
    required ComparableFilterableMixin super.value,
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
    required CollectionFilterableMixin super.value,
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
    required CollectionFilterableMixin super.value,
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
    required CollectionFilterableMixin super.value,
  }) : super._(
          operator: _FieldOperator.none,
        );
}

/// Filter to check if a Field is Empty
class IsEmptyFilter extends _FieldFilter {
  /// Checks if a field with [fieldId] is empty
  const IsEmptyFilter({
    required super.fieldId,
  }) : super._(
          operator: _FieldOperator.empty,
          value: const _EmptyOperatorValue(),
        );
}

class _EmptyOperatorValue with FilterableMixin {
  const _EmptyOperatorValue();

  @override
  get filterValue => true;
}

/// Filter to use with [DataType.createdBy] to filter for a Specific [ActorFilterableMixin]
class ActorFilter extends _FieldFilter {
  /// Creates a Filter that checks if the [value] in the column of [fieldId] is equal
  const ActorFilter({
    required super.fieldId,
    required ActorFilterableMixin super.value,
  }) : super._(
          operator: _FieldOperator.actor,
        );
}
