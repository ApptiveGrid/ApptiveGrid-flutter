// ignore: depend_on_referenced_packages
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

/// A Wrapper around [PermissionManager]
class PermissionManager {
  /// Creates the Wrapper
  const PermissionManager();

  /// Request a permission by calling [PermissionActions.request]
  Future<PermissionStatus?> requestPermission(Permission permission) =>
      permission.request();

  /// Checks the status of a permission by calling [PermissionActions.status]
  Future<PermissionStatus?> checkPermission(Permission permission) =>
      permission.status;

  /// Opens the Permission Section in the System Settings for the App
  ///
  /// Uses [PermissionHandlerPlatform.openAppSettings]
  Future<bool> openAppSettings() =>
      PermissionHandlerPlatform.instance.openAppSettings();
}
