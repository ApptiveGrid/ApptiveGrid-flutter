import 'dart:convert';

import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:apptive_grid_form/src/widgets/form_widget/form_widget_helpers.dart';
import 'package:flutter/material.dart';

/// FormComponent Widget to display a [FormComponent<ResourceDataEntity>]
///
/// The selectable resources are loaded from the [ApptiveLinkType.resources]
/// link of the component's field and grouped by their
/// [DataResourceMetaType], the same way the web frontend does it.
class ResourceFormWidget extends StatefulWidget {
  /// Creates a Dropdown to select a [DataResource] contained in [component]
  const ResourceFormWidget({
    super.key,
    required this.component,
  });

  /// Component this Widget should reflect
  final FormComponent<ResourceDataEntity> component;

  @override
  State<ResourceFormWidget> createState() => _ResourceFormWidgetState();
}

class _ResourceFormWidgetState extends State<ResourceFormWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  /// The selectable resources. `null` while loading.
  List<DataResource>? _resources;
  dynamic _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_resources == null && _error == null) {
      _loadResources();
    }
  }

  Future<void> _loadResources() async {
    final link = widget.component.field.links[ApptiveLinkType.resources];
    if (link == null) {
      // Without a link there is nothing to choose from. The current value is
      // still displayed and submitted.
      setState(() {
        _resources = [];
      });
      return;
    }
    try {
      final resources = await ApptiveGrid.getClient(context, listen: false)
          .performApptiveLink<List<DataResource>>(
        link: link,
        parseResponse: (response) async {
          final json = jsonDecode(response.body);
          final items = json is Map ? json['items'] : json;
          return (items as List? ?? [])
              .map((item) => DataResource.fromJson(item))
              // Flow instances are listed by the backend but are not meant to
              // be picked in a form. Matches the frontend's filter.
              .where(
                (resource) => resource.type != DataResourceType.flowInstance,
              )
              .toList();
        },
      );
      if (mounted) {
        setState(() {
          _resources = resources ?? [];
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final decoration = widget.component.baseDecoration;
    if (_error != null) {
      return InputDecorator(
        decoration: decoration.copyWith(errorText: _error.toString()),
        child: const SizedBox(height: 24),
      );
    }
    final resources = _resources;
    if (resources == null) {
      return InputDecorator(
        decoration: decoration,
        child: const SizedBox(
          height: 24,
          child: Center(child: LinearProgressIndicator()),
        ),
      );
    }

    // Resolve the current value against the loaded list by uri, so a value
    // that only carries an href (e.g. from a cached form) still matches.
    // A value that is not in the list stays selectable so it isn't lost.
    final current = widget.component.data.value;
    final options = [...resources];
    DataResource? selected;
    if (current != null) {
      selected = options.cast<DataResource?>().firstWhere(
            (resource) => resource!.href.uri == current.href.uri,
            orElse: () => null,
          );
      if (selected == null) {
        options.add(current);
        selected = current;
      }
    }
    final entries = _groupedEntries(options);

    return DropdownButtonFormField<DataResource>(
      isExpanded: true,
      items: [
        for (final entry in entries)
          switch (entry) {
            _GroupHeader(:final metaType) => DropdownMenuItem<DataResource>(
                enabled: false,
                child: _GroupHeaderWidget(metaType: metaType),
              ),
            _Option(:final resource) => DropdownMenuItem<DataResource>(
                value: resource,
                child: DataResourceWidget(resource: resource),
              ),
          },
      ],
      selectedItemBuilder: (_) => [
        for (final entry in entries)
          switch (entry) {
            _GroupHeader() => const SizedBox.shrink(),
            _Option(:final resource) => DataResourceWidget(resource: resource),
          },
      ],
      onChanged: widget.component.enabled
          ? (resource) {
              setState(() {
                widget.component.data.value = resource;
              });
            }
          : null,
      validator: (resource) {
        if (widget.component.required && resource == null) {
          return ApptiveGridLocalization.of(context)!
              .fieldIsRequired(widget.component.property);
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: selected,
      decoration: decoration,
    );
  }

  /// Groups [resources] by meta type, keeping the order in which the meta
  /// types first appear, with a header entry in front of each group.
  List<_Entry> _groupedEntries(List<DataResource> resources) {
    final groups = <DataResourceMetaType, List<DataResource>>{};
    for (final resource in resources) {
      groups.putIfAbsent(resource.metaType, () => []).add(resource);
    }
    return [
      for (final group in groups.entries) ...[
        _GroupHeader(group.key),
        for (final resource in group.value) _Option(resource),
      ],
    ];
  }
}

sealed class _Entry {
  const _Entry();
}

class _GroupHeader extends _Entry {
  const _GroupHeader(this.metaType);

  final DataResourceMetaType metaType;
}

class _Option extends _Entry {
  const _Option(this.resource);

  final DataResource resource;
}

class _GroupHeaderWidget extends StatelessWidget {
  const _GroupHeaderWidget({required this.metaType});

  final DataResourceMetaType metaType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      ApptiveGridLocalization.of(context)!.resourceGroupLabel(metaType),
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// A Widget to display a [DataResource] with an icon for its type and its name
class DataResourceWidget extends StatelessWidget {
  /// Creates a Widget that displays [resource]
  const DataResourceWidget({super.key, required this.resource});

  /// The [DataResource] to display
  final DataResource resource;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(_iconFor(resource), size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            resource.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  static IconData _iconFor(DataResource resource) => switch (resource.type) {
        DataResourceType.space => Icons.workspaces_outlined,
        DataResourceType.persistentGrid ||
        DataResourceType.virtualGrid ||
        DataResourceType.spreadsheetView =>
          Icons.grid_on_outlined,
        DataResourceType.kanbanView => Icons.view_kanban_outlined,
        DataResourceType.calendarView => Icons.calendar_month_outlined,
        DataResourceType.mapView => Icons.map_outlined,
        DataResourceType.galleryView => Icons.photo_library_outlined,
        DataResourceType.listView => Icons.view_list_outlined,
        DataResourceType.timelineView => Icons.timeline_outlined,
        DataResourceType.form => Icons.assignment_outlined,
        DataResourceType.pageBlock => Icons.article_outlined,
        DataResourceType.flow ||
        DataResourceType.flowInstance ||
        DataResourceType.externalFlowTrigger =>
          Icons.account_tree_outlined,
        DataResourceType.addEntity => Icons.post_add_outlined,
        DataResourceType.unknown => switch (resource.metaType) {
            DataResourceMetaType.grid ||
            DataResourceMetaType.view ||
            DataResourceMetaType.gridView =>
              Icons.grid_on_outlined,
            DataResourceMetaType.form => Icons.assignment_outlined,
            DataResourceMetaType.block => Icons.article_outlined,
            DataResourceMetaType.space => Icons.workspaces_outlined,
            DataResourceMetaType.flowNode => Icons.account_tree_outlined,
            DataResourceMetaType.externalHook ||
            DataResourceMetaType.unknown =>
              Icons.link,
          },
      };
}
