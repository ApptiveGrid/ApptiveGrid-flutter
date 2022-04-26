part of apptive_grid_model;

/// Available Links
enum ApptiveLinkType {
  /// A link to the ApptiveObject itself
  self,

  // User Related
  /// Returns a List of Access Credentials
  accessCredentials,

  /// Adds Access Credentials
  addAccessCredentials,

  /// Adds a Hook
  addHook,

  /// Add a new Space
  addSpace,

  /// List of Hooks
  hooks,

  /// List of [Space]s
  spaces,

  // Space Related
  /// Adds a new Grid
  addGrid,

  /// Adds a new Share
  addShare,

  /// Lists [Grid]s
  grids,

  /// Removes a [Space], [Grid], [Form]
  remove,

  /// Rename a [Space], [Grid], [Form]
  rename,

  /// List Shares
  shares,

  // Grid Related
  /// Adds a new [GridRow]
  addEntity,

  /// Adds a new [GridField]
  addField,

  /// Adds a new Form
  addForm,

  /// Adds a new Link
  addLink,

  /// Adds a View
  addView,

  /// List Entities
  entities,

  /// List Forms
  forms,

  /// Perform a query on a [Grid]
  query,

  /// Remove a field
  removeField,

  /// Get the schema of a [Grid]
  schema,

  /// Update the key of a field
  updateFieldKey,

  /// Update the [GridField.name]
  updateFieldName,

  /// Update the [GridField.type]
  updateFieldType,

  /// Check if there have been updates to the Grid
  updates,

  /// List Views of a [Grid]
  views,

  //Form Related Links
  /// Submit [FormData]
  submit,

  /// Update a Form
  update,
}
