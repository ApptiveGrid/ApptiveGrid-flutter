import 'package:apptive_grid_core/apptive_grid_core.dart';

/// Wrapper class to use in [ApptiveGridCache]
class ActionItem {
  /// Creates a new Action Item
  ActionItem({
    required this.link,
    required this.data,
  });

  /// Creates a ActionItem base on a [json] map
  factory ActionItem.fromJson(Map<String, dynamic> json) => switch (json) {
        {
          'action': dynamic action,
          'link': dynamic link,
          'data': dynamic data,
        } =>
          ActionItem(
            link: ApptiveLink.fromJson(link ?? action),
            data: FormData.fromJson(data),
          ),
        _ => throw ArgumentError.value(
            json,
            'Invalid ActionItem json: $json',
          ),
      };

  /// Action to be performed
  // ignore: deprecated_member_use_from_same_package
  final ApptiveLink link;

  /// Data to be send in the Action
  final FormData data;

  /// Serializes the ActionItem to a json map
  Map<String, dynamic> toJson() => {
        'link': link.toJson(),
        'data': data.toJson(),
      };

  @override
  String toString() {
    return 'ActionItem(link: $link, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return other is ActionItem && link == other.link && data == other.data;
  }

  @override
  int get hashCode => Object.hash(link, data);
}
