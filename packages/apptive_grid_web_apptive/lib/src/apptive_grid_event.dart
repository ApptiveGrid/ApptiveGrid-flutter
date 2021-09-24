import 'package:apptive_grid_core/apptive_grid_core.dart';

/// Calls that happen between ApptiveGrid and Apptives
enum ApptiveCall {
  /// Call when the visible GridView updated
  gridViewUpdate,
}

/// Parses [value] into the respective [ApptiveCall]
ApptiveCall apptiveCallFromJson(String value) {
  switch (value) {
    case 'gridViewUpdate':
      return ApptiveCall.gridViewUpdate;
    default:
      throw ArgumentError('Unknown ApptiveCall $value');
  }
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
    if (json is Map && json.containsKey('call') && json.containsKey('grid')) {
      return ApptiveGridEvent(
        call: apptiveCallFromJson(json['call']),
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
