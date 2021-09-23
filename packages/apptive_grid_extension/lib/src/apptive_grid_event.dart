import 'package:apptive_grid_core/apptive_grid_core.dart';


enum ApptiveCall {
  gridViewUpdate,
}


  ApptiveCall apptiveCallFromJson(String value) {
    switch(value) {
      case 'gridViewUpdate': return ApptiveCall.gridViewUpdate;
      default: throw ArgumentError('Unknown ApptiveCall $value');
    }
  }

class ApptiveGridEvent {
  const ApptiveGridEvent({
    required this.call,
    required this.grid,});

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

  final ApptiveCall call;
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
