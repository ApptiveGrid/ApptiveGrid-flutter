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
}