part of apptive_grid_model;

/// Model for a Cell Entry in a Grid
class GridEntry {
  /// Creates a GridEntry
  GridEntry(this.field, this.data);

  /// Creates a GridEntry with value [jsonData]
  ///
  /// [field.type] is used for determining the [DataEntity] runtimeType of [data]
  factory GridEntry.fromJson(
      dynamic jsonData, GridField field, dynamic schema) {
    DataEntity dataEntity;
    switch (field.type) {
      case DataType.text:
        dataEntity = StringDataEntity(jsonData);
        break;
      case DataType.dateTime:
        dataEntity = DateTimeDataEntity.fromJson(jsonData);
        break;
      case DataType.date:
        dataEntity = DateDataEntity.fromJson(jsonData);
        break;
      case DataType.integer:
        dataEntity = IntegerDataEntity(jsonData);
        break;
      case DataType.checkbox:
        dataEntity = BooleanDataEntity(jsonData);
        break;
      case DataType.selectionBox:
        dataEntity = EnumDataEntity(value: jsonData, options: schema['enum']);
        break;
      case DataType.crossReference:
        dataEntity = CrossReferenceDataEntity(jsonValue: jsonData, gridUri: schema['gridUri']);
        break;
    }
    return GridEntry(field, dataEntity);
  }

  /// Column this Entry belongs to
  final GridField field;

  /// Data that is held in the cell
  final DataEntity data;

  @override
  String toString() {
    return 'GridEntry(field: $field, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return other is GridEntry && field == other.field && data == other.data;
  }

  @override
  int get hashCode => toString().hashCode;
}
