library apptive_grid_web_apptive;

import 'dart:async';
import 'dart:html' as html;

import 'package:apptive_grid_web_apptive/src/apptive_grid_event.dart';
import 'package:apptive_grid_web_apptive/src/apptive_message.dart';
import 'package:flutter/material.dart';

export 'package:apptive_grid_core/apptive_grid_core.dart';

/// A wrapper around Widgets to show an Apptive on the ApptiveGrid Web client
class ApptiveGridWebApptive extends StatefulWidget {
  /// Creates an Apptive Wrapper to use Flutter Apptives on the web ApptiveGrid Client
  /// [builder] gets called with a [ApptiveGridEvent] everytime the Data visible to the user in the main window is changed.
  /// It gets called either if the data is changed in a Grid or if the user switches to a different view,
  /// possibly changing which [Grid] is displayed
  ///
  /// Received [ApptiveMessages] are passed into [messageController]
  const ApptiveGridWebApptive({
    Key? key,
    required this.builder,
    this.messageController,
  }) : super(key: key);

  /// Called when there is a [ApptiveGridEvent] changing the data
  final Widget Function(BuildContext, ApptiveGridEvent) builder;

  /// Controller to receive [ApptiveMessage]
  final StreamController<ApptiveMessage>? messageController;

  @override
  _ApptiveGridWebApptiveState createState() => _ApptiveGridWebApptiveState();
}

class _ApptiveGridWebApptiveState extends State<ApptiveGridWebApptive> {
  ApptiveGridEvent? _gridEvent;
  dynamic _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      html.window.addEventListener('message', (event) {
        final message = (event as html.MessageEvent);
        try {
          try {
            // Checking if this is a message
            final apptiveMessage = ApptiveMessage.fromJson(message.data);
            widget.messageController?.add(apptiveMessage);
          } on ArgumentError {
            // This was not a ApptiveMessage
          }

          try {
            final gridEvent = ApptiveGridEvent.fromJson(message.data);
            if (gridEvent.call == ApptiveCall.gridViewUpdate) {
              setState(() {
                _gridEvent = gridEvent;
              });
            }
          } on ArgumentError {
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
    if (_gridEvent != null) {
      return Column(
        children: [
          widget.builder(context, _gridEvent!),
        ],
      );
    } else if (_error != null) {
      return Center(
        child: Text('Error: $_error'),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
  }
}
