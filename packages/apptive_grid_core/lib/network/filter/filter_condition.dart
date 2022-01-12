import 'package:apptive_grid_core/apptive_grid_core.dart';

abstract class FilterCondition {
  const FilterCondition();

  Map<String, dynamic> toJson();
}

enum _ComposeOperator {
  and,
  or,
}

abstract class _ComposedFilterCondition extends FilterCondition {
  const _ComposedFilterCondition(
      {required this.conditions, required this.operator,})
      : super();

  final List<FilterCondition> conditions;
  final _ComposeOperator operator;

  @override
  Map<String, dynamic> toJson() => {
        '\$${operator.name}': conditions.map((condition) => condition.toJson()).toList(),
      };
}

class AndFilterCondition extends _ComposedFilterCondition {
  const AndFilterCondition({required List<FilterCondition> conditions})
      : super(conditions: conditions, operator: _ComposeOperator.and);
}

class OrFilterCondition extends _ComposedFilterCondition {
  const OrFilterCondition({required List<FilterCondition> conditions})
      : super(conditions: conditions, operator: _ComposeOperator.or);
}

enum _FieldOperator {
  substring,
  equal,
  greaterThan,
  lesserThan,

  // Collections
  any,
  all,
  none
}

extension _FieldOperatorX on _FieldOperator {
  String get operation {
    switch (this) {
      case _FieldOperator.substring:
        return 'substring';
      case _FieldOperator.equal:
        return '=';
      case _FieldOperator.greaterThan:
        return 'gt';
      case _FieldOperator.lesserThan:
        return 'lt';
      case _FieldOperator.any:
        return 'any';
      case _FieldOperator.all:
        return 'all';
      case _FieldOperator.none:
        return 'none';
    }
  }
}

abstract class _FieldFilterCondition extends FilterCondition {
  const _FieldFilterCondition(
      {required this.fieldId,
      required this.value,
      required this.operator,});

  final String fieldId;
  final DataEntity value;
  final _FieldOperator operator;

  @override
  Map<String, dynamic> toJson() => {
        fieldId: {'\$${operator.operation}': value.schemaValue}
      };
}

class SubstringFilter extends _FieldFilterCondition {
  const SubstringFilter(
      {required String fieldId, required StringDataEntity value,})
      : super(
          fieldId: fieldId,
          value: value,
          operator: _FieldOperator.substring,
        );
}

class EqualFilter extends FilterCondition {
  const EqualFilter(
      {required String this.fieldId, required this.value,})
      : super();

  final String fieldId;
  final DataEntity value;

  @override
  Map<String, dynamic> toJson() => {
    fieldId: value.schemaValue
  };
}

class GreaterThanFilter extends _FieldFilterCondition {
  const GreaterThanFilter(
      {required String fieldId, required ComparableDataEntity value,})
      : super(
    fieldId: fieldId,
    value: value,
    operator: _FieldOperator.greaterThan,
  );
}

class LesserThanFilter extends _FieldFilterCondition {
  const LesserThanFilter(
      {required String fieldId, required ComparableDataEntity value,})
      : super(
    fieldId: fieldId,
    value: value,
    operator: _FieldOperator.lesserThan,
  );
}

class AnyOfFilter extends _FieldFilterCondition {
  const AnyOfFilter(
      {required String fieldId, required CollectionDataEntity value,})
      : super(
    fieldId: fieldId,
    value: value,
    operator: _FieldOperator.any,
  );
}

class AllOfFilter extends _FieldFilterCondition {
  const AllOfFilter(
      {required String fieldId, required CollectionDataEntity value,})
      : super(
    fieldId: fieldId,
    value: value,
    operator: _FieldOperator.all,
  );
}

class NoneOfFilter extends _FieldFilterCondition {
  const NoneOfFilter(
      {required String fieldId, required CollectionDataEntity value,})
      : super(
    fieldId: fieldId,
    value: value,
    operator: _FieldOperator.none,
  );
}


