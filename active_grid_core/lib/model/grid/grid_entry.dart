part of active_grid_model;

class GridEntry {
  GridEntry(this.field, this.data);

  factory GridEntry.fromJson(dynamic jsonData, GridField field) {
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
    }
    return GridEntry(field, dataEntity);
  }

  final GridField field;

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
