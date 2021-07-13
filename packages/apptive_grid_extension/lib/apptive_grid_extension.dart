library apptive_grid_extension;

import 'dart:html' as html;

import 'package:apptive_grid_core/apptive_grid_core.dart';
import 'package:flutter/material.dart';

export 'package:apptive_grid_core/apptive_grid_core.dart';

class ApptiveGridExtension extends StatefulWidget {
  const ApptiveGridExtension({Key? key, required this.builder}) : super(key: key);

  final Widget Function(BuildContext, Grid) builder;

  @override
  _ApptiveGridExtensionState createState() => _ApptiveGridExtensionState();
}

class _ApptiveGridExtensionState extends State<ApptiveGridExtension> {

  Grid? _grid;
  dynamic _data;
  dynamic _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      html.window.addEventListener('message', (event) {
        final message = (event as html.MessageEvent);
        if((message.data as Map).containsKey('grid')) {
          setState(() {
            _data = message.data;
            try {
              _grid = Grid.fromJson(message.data['grid'].cast<String, dynamic>());
            } catch (err) {
              _error = err;
            }
          });
        }
      });

      html.window.postMessage('Extension Connected', 'http://localhost:1234');
    });

  }

  @override
  Widget build(BuildContext context) {
    if(_grid != null) {
      return Column(
        children: [
          widget.builder(context, _grid!),
        ],
      );
    } else if(_error != null) {
      return Center(child: Text('Error: $_error'),);
  } else{
      return const Center(child: CircularProgressIndicator(),);
    }
  }
}

