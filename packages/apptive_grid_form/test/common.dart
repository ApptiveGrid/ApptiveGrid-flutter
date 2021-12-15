import 'package:apptive_grid_core/cache/apptive_grid_cache.dart';
import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockApptiveGridClient extends Mock implements ApptiveGridClient {}

class MockHttpClient extends Mock implements http.Client {}

class MockApptiveGridCache extends Mock implements ApptiveGridCache {}

class MockFilePicker extends Mock
    with MockPlatformInterfaceMixin
    implements FilePicker {}

class MockGeolocator extends Mock
    with MockPlatformInterfaceMixin
    implements GeolocatorPlatform {}

class MockPermissionHandler extends Mock
  with MockPlatformInterfaceMixin
implements PermissionHandlerPlatform {}

class TestApp extends StatelessWidget {
  const TestApp({
    Key? key,
    this.client,
    this.child,
    this.options = const ApptiveGridOptions(),
  }) : super(key: key);

  final Widget? child;

  final ApptiveGridClient? client;

  final ApptiveGridOptions options;

  @override
  Widget build(BuildContext context) {
    return ApptiveGrid.withClient(
      client: client ?? _fallbackClient,
      options: options,
      child: ApptiveGridLocalization(
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return Material(child: child);
            },
          ),
        ),
      ),
    );
  }

  ApptiveGridClient get _fallbackClient {
    final client = MockApptiveGridClient();
    when(() => client.sendPendingActions()).thenAnswer((invocation) async {});

    return client;
  }
}
