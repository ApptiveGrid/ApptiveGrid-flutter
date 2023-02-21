import 'package:apptive_grid_core/apptive_grid_core.dart';

/// Available Links
enum ApptiveLinkType {
  /// A link to the ApptiveObject itself
  self,

  /// Updates a ApptiveObject
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

  /// Add a Flow
  addFlow,

  /// List Flows
  flows,

  // Space Related
  /// Adds a new Grid
  addGrid,

  /// Adds a new Share
  addShare,

  /// Copy the space to the current user
  copy,

  /// Lists [Grid]s
  grids,

  /// Removes an ApptiveObject
  remove,

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

  /// Update an ApptiveObject
  update,

  // Row/Entity Related Link Types
  /// Partially Update a [GridRow]
  partialUpdate,

  /// Create a Link to a [FormData] for this [GridRow]
  addEditionLink,

  //Field Related Links
  /// Query for Collaborators in a [DataType.user] Field
  collaborators,

  // AGExternalLinkPresenter
  /// Processes an External ApptiveGridLink
  process,

  /// Write an external Link
  write,

  /// Read an external Link
  read,

  // AGVirtualGridPresenter
  /// List Stateful Views of a Grid
  sviews,

  /// Rename an ApptiveGridObject
  rename,

  /// Add a new Stateful View
  addSView,

  /// Update a Filter
  updateFilter,

  /// Export View/Grid as a CSV
  exportAsCsv,

  // AGCommonFieldPresenter
  /// Extract Fields with a Filter to a new Grid
  extractToGrid,

  // AGHookPresenter
  /// Test an ApptiveGridHook
  test,

  // AGGridPresenterHAL
  /// Add a Virtual Grid
  addVirtualGrid,

  // AGActivationPresenter
  /// List Events of a Hook Activation
  events,

  // AGFlowPresenter
  /// Remove a transition in a Flow
  removeTransition,

  /// List nodes in a flow
  nodes,

  /// Add a transition in a Flow between nodes
  addTransition,

  /// Add a Node to a flow
  addNode,

  /// List instances of a flow
  instances,

  /// List transitions in a flow
  transitions,

  // AGFlowInstanceEventPresenter

  // AGNodePresenter
  /// List outgoing connections of a Node
  outgoing,

  /// List incoming connections of a Node
  incoming,

  // AGSpacePresenter
  /// Create a new Grid from a CSV
  uploadCSV,

  // SView
  /// Link to the respective Grid of a SView
  grid,
}
