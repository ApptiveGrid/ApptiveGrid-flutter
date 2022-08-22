import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:collection/collection.dart';

/// Calls that happen between ApptiveGrid and Apptives
enum ApptiveCall {
  /// Call when the displayed virtualGrid updated
  virtualGridUpdate(call: 'virtualGridUpdate');

  /// Creates a new ApptiveCall
  const ApptiveCall({required this.call});

  /// The Call event send by the Web App
  final String call;

  /// Call when the displayed virtualGrid updated
  @Deprecated('Use ApptiveCall.virtualGridUpdate instead')
  static const gridViewUpdate = ApptiveCall.virtualGridUpdate;
}

/// Events happening in the communication between ApptiveGrid and Apptives
class ApptiveGridEvent {
  /// Creates a new [ApptiveGridEvent] for [call] with the new [grid] data
  const ApptiveGridEvent({
    required this.call,
    required this.grid,
  });

  /// Creates a [ApptiveGridEvent] from a [json] object
  factory ApptiveGridEvent.fromJson(dynamic json) {
    if (json is Map &&
        json.containsKey('call') &&
        json.containsKey('grid') &&
        ApptiveCall.values
                .firstWhereOrNull((call) => call.call == json['call']) !=
            null) {
      return ApptiveGridEvent(
        call:
            ApptiveCall.values.firstWhere((call) => call.call == json['call']),
        grid: Grid.fromJson(json['grid']),
      );
    } else {
      throw ArgumentError('$json is not a valid ApptiveGridEvent');
    }
  }

  /// [ApptiveCall] for this event
  final ApptiveCall call;

  /// Data for this event
  final Grid grid;

  @override
  String toString() {
    return 'ApptiveGridEvent(call: $call, grid: $grid)';
  }

  @override
  bool operator ==(Object other) {
    return other is ApptiveGridEvent &&
        other.call == call &&
        other.grid == grid;
  }

  @override
  int get hashCode => toString.hashCode;
}
