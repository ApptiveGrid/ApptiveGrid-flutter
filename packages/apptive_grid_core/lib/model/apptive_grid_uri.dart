part of apptive_grid_model;

/// Base class used to represent Objects with a Uri
abstract class ApptiveGridUri {
  /// Generates the uriString used for ApiCalls referencing this
  String get uriString;
}
