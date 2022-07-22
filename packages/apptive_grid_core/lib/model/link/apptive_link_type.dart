part of apptive_grid_model;

/// Available Links
enum ApptiveLinkType {
  /// A link to the ApptiveObject itself
  self,

  /// Updates a [Space], [Grid], [Form], [GridRow] or [GridField]
  patch,

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

  /// Copy the space to the current user
  copy,

  /// Lists [Grid]s
  grids,

  /// Removes a [Space], [Grid], [Form], [GridRow]
  remove,

  /// Rename a [Space], [Grid], [Form]
  @Deprecated('Use ApptiveLinkType.patch instead')
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

  /// Gets available currency for a [GridField] with [GridField.type] == [DataType.currency]
  currencies,

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

  /// Returns a List of virtual [Grid]s of a persistent [Grid]
  virtualGrids,

  //Form Related Links
  /// Submit [FormData]
  submit,

  /// Update a [FormData], [GrdiRow]
  update,

  // Row/Entity Related Link Types
  /// Partially Update a [GridRow]
  partialUpdate,

  /// Create a Link to a [FormData] for this [GridRow]
  addEditionLink,

  //Field Related Links
  /// Query for Collaborators in a [DataType.user] Field
  collaborators,
}
