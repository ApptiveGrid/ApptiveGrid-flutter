import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apptive_grid_theme/apptive_grid_theme.dart';

class _TestApp extends StatelessWidget {
  _TestApp({Key? key, required Widget this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Column(
        children: [
          Expanded(
            child: Theme(
                data: ApptiveGridTheme(brightness: Brightness.light).theme(),
                child: child),
          ),
          Expanded(
            child: Theme(
                data: ApptiveGridTheme(brightness: Brightness.dark).theme(),
                child: child),
          ),
        ],
      ),
    );
  }
}

void main() {
}
