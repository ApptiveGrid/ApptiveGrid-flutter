part of active_grid_model;

class GridRow {
  GridRow(this.id, this.entries);

  factory GridRow.fromJson(dynamic json, List<GridField> fields) {
    final data = json['fields'] as List;
    final entries = List<GridEntry>.filled(data.length, null);
    for (var i = 0; i < data.length; i++) {
      entries[0] = GridEntry.fromJson(entries[i], fields[i]);
    }
    return GridRow(json['_id'], entries);
  }
  final String id;

  final List<GridEntry> entries;
}

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
}
