// ignore: depend_on_referenced_packages
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart'
    as platform;

class PermissionManager {
  const PermissionManager();

  Future<PermissionStatus?> requestPermission(Permission permission) =>
      permission.request();

  Future<PermissionStatus?> checkPermission(Permission permission) =>
      permission.status;

  Future<bool> openAppSettings() =>
      platform.PermissionHandlerPlatform.instance.openAppSettings();
}
