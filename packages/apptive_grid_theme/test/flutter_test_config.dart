// flutter_test_config.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:apptive_grid_theme/apptive_grid_theme.dart';
import 'package:flutter/services.dart';

import 'font_util.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final isRunningInCi = Platform.environment['CI'] == 'true';

  final theme = ApptiveGridTheme(brightness: Brightness.light)
      .theme()
      .stripFontPackages();

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      theme: theme,
      platformGoldensConfig: PlatformGoldensConfig(
        enabled: !isRunningInCi,
      ),
    ),
    run: testMain,
  );
}

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final data = await load(key);
    return utf8.decode(data.buffer.asUint8List());
  }

  @override
  Future<ByteData> load(String key) {
    return rootBundle.load(key);
  }
}
