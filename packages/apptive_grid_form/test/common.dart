import 'package:apptive_grid_core/src/network/attachment_processor.dart';
import 'package:apptive_grid_form/apptive_grid_form.dart';
import 'package:apptive_grid_form/src/translation/apptive_grid_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockApptiveGridClient extends Mock implements ApptiveGridClient {}

class MockHttpClient extends Mock implements http.Client {}

class MockApptiveGridCache extends Mock implements ApptiveGridCache {}

class MockAttachmentProcessor extends Mock implements AttachmentProcessor {}

class MockFilePicker extends Mock
    with MockPlatformInterfaceMixin
    implements FilePicker {}

class MockImagePicker extends Mock
    with MockPlatformInterfaceMixin
    implements ImagePickerPlatform {}

class MockXFile extends Mock implements XFile {}

class MockGeolocator extends Mock
    with MockPlatformInterfaceMixin
    implements GeolocatorPlatform {}

class MockPermissionHandler extends Mock
    with MockPlatformInterfaceMixin
    implements PermissionHandlerPlatform {}

class MockMapPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements GoogleMapsFlutterPlatform {}

class TestApp extends StatelessWidget {
  const TestApp({
    super.key,
    this.client,
    this.child,
    this.options = const ApptiveGridOptions(),
    this.locale = const Locale('en', 'US'),
  });

  final Widget? child;

  final ApptiveGridClient? client;

  final ApptiveGridOptions options;

  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return ApptiveGrid.withClient(
      client: client ?? _fallbackClient,
      options: options,
      child: ApptiveGridLocalization(
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            locale,
          ],
          locale: locale,
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
    when(() => client.sendPendingActions())
        .thenAnswer((invocation) async => []);
    when(() => client.options).thenReturn(options);
    return client;
  }
}
