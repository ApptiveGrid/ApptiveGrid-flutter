library apptive_grid_extension;

import 'dart:html' as html;

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:apptive_grid_extension/src/apptive_grid_event.dart';
import 'package:flutter/material.dart';

export 'package:apptive_grid_core/apptive_grid_core.dart';

class ApptiveGridExtension extends StatefulWidget {
  const ApptiveGridExtension({Key? key, required this.builder})
      : super(key: key);

  final Widget Function(BuildContext, Grid) builder;

  @override
  _ApptiveGridExtensionState createState() => _ApptiveGridExtensionState();
}

class _ApptiveGridExtensionState extends State<ApptiveGridExtension> {
  Grid? _grid;
  dynamic _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      html.window.addEventListener('message', (event) {
        final message = (event as html.MessageEvent);
        try {
          /*try {
            // Checking if this is a message
            final apptiveMessage = ApptiveMessage.fromJson(message.data);
            debugPrint('Received Message: $apptiveMessage');
          } on ArgumentError catch (_) {
            // This was not a ApptiveMessage
          }*/

          try {
            final gridEvent = ApptiveGridEvent.fromJson(message.data);
            if (gridEvent.call == ApptiveCall.gridViewUpdate) {
              setState(() {
                _grid = gridEvent.grid;
              });
            }
          } on ArgumentError catch (error) {
            // This was not a ApptiveGridEvent
          }
        } catch (error) {
          setState(() {
            _error = error;
          });
        }
      });

      html.window
          .postMessage({'message': 'apptiveLoaded'}, html.window.location.href);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_grid != null) {
      return Column(
        children: [
          widget.builder(context, _grid!),
        ],
      );
    } else if (_error != null) {
      return Center(
        child: Text('Error: $_error'),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
