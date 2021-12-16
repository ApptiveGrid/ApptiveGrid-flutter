import 'package:apptive_grid_form/managers/permission_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import '../common.dart';

void main() {
  late PermissionManager permissionManager;

  setUp(() {
    permissionManager = const PermissionManager();
  });

  group('requestPermission', () {
    test('requestPermission calls permissionHandler', () async {
      final permissionHandler = MockPermissionHandler();

      PermissionHandlerPlatform.instance = permissionHandler;

      final permission = Permission.camera;
      const permissionStatus = PermissionStatus.granted;

      when(() => permissionHandler.requestPermissions([permission]))
          .thenAnswer((invocation) async => {permission: permissionStatus});

      expect(
        await permissionManager.requestPermission(Permission.camera),
        permissionStatus,
      );
    });
  });

  group('checkPermission', () {
    test('checkPermission calls permissionHandler', () async {
      final permissionHandler = MockPermissionHandler();

      PermissionHandlerPlatform.instance = permissionHandler;

      final permission = Permission.camera;
      const permissionStatus = PermissionStatus.granted;

      when(() => permissionHandler.checkPermissionStatus(permission))
          .thenAnswer((invocation) async => permissionStatus);

      expect(
        await permissionManager.checkPermission(Permission.camera),
        permissionStatus,
      );
    });
  });

  group('openAppSettings', () {
    test('openAppSettings calls permissionHandler', () async {
      final permissionHandler = MockPermissionHandler();

      PermissionHandlerPlatform.instance = permissionHandler;

      when(() => permissionHandler.openAppSettings())
          .thenAnswer((invocation) async => true);

      expect(await permissionManager.openAppSettings(), true);
      verify(permissionManager.openAppSettings).called(1);
    });
  });
}
