import 'package:apptive_grid_core/src/apptive_grid_model.dart';

abstract class ApptiveGridObject {
  const ApptiveGridObject();

  factory ApptiveGridObject.fromJson(Type type, dynamic json) {
    assert(isParsable(type));
    switch (type) {
      case Grid:
        return Grid.fromJson(json);
      default:
        throw Exception(
            'Type $type is either not an ApptiveGridObject or was not added to the fromJson method');
    }
  }

  static List<ApptiveGridObject> fromJsonList(Type type, List jsonList) {
    assert(isParsable(type));
    return jsonList.map((item) {
      switch (type) {
        case List<Grid>:
          return Grid.fromJson(item);
        default:
          throw Exception(
              'Type $type is either not an ApptiveGridObject or was not added to the fromJson method');
      }
    }).toList();
  }

  static bool isParsable(Type type) {
    final parsableTypes = <Type>[Grid];

    final regex = RegExp('List<(.+)>');
    if (regex.hasMatch(type.toString())) {
      final match = regex.firstMatch(type.toString())![1];
      for (final Type checkType in parsableTypes) {
        if (checkType.toString() == match) {
          return true;
        }
      }
    }

    return parsableTypes.contains(type);
  }

  Map<String, dynamic> toJson();
}
