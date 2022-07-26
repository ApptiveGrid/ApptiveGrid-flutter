/// Defines the Layout of an Entity that is returned by ApptiveGrid
///
/// When using this manually for example when calling [ApptiveGridClient.performApptiveLink] add this to `queryParamters` as
/// ```dart
/// 'layout': ApptiveGridLayout.field.queryParameter,
/// ```
enum ApptiveGridLayout {
  /// This is the layout that returns a JSON where the JSON keys are the field ids
  field(queryParameter: 'field'),

  /// This is the layout that returns a JSON array containing all fields
  indexed(queryParameter: 'indexed'),

  /// This is the layout the returns a JSON where the JSON keys are the name of the fields
  property(queryParameter: 'property'),

  /// This is the layout that returns a JSON where the JSON keys are the key of a field.
  key(queryParameter: 'key'),

  /// This is the layout that returns a JSON where the JSON keys are either field id or field key. When a field has a key this is used if not the field id which is always present
  keyAndField(queryParameter: 'keyAndField');

  /// Creates a new ApptiveGrid Layout enum Entry
  const ApptiveGridLayout({required this.queryParameter});

  /// The query Parameter that should be used when adding this to a request to ApptiveGrid
  final String queryParameter;
}
