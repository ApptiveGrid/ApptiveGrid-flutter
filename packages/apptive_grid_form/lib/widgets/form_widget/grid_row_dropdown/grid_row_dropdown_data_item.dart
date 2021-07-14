part of grid_row_dropdown;

/// Data Item to use in Dropwdown Menu for [CrossReferenceFormWidget] to sync between a [GridRow] and [CrossReferenceDataEntity]
class GridRowDropdownDataItem {
  /// Creates a new GridRowDropdownDataItem
  GridRowDropdownDataItem({this.entityUri, this.displayValue});

  /// [EntityUri] representing the [GridRow]
  final EntityUri? entityUri;

  /// Display Value. Normally this should be a String representation of the first item of the [GridRow]
  final String? displayValue;

  @override
  String toString() {
    return '_DropdownDataItem(entityUri: $entityUri, displayValue: $displayValue)';
  }

  @override
  bool operator ==(Object other) {
    return other is GridRowDropdownDataItem &&
        other.entityUri == entityUri &&
        other.displayValue == displayValue;
  }

  @override
  int get hashCode => toString().hashCode;
}
