import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<void> checkCameraPermission(Function? function) async {
    final status = await Permission.camera.status;
    if (status.isDenied) {
      // Request permission
      final result = await Permission.camera.request();
      if (result.isGranted) {
        if (function != null) {
          function();
        }
      } else if (result.isPermanentlyDenied) {
        // Open app settings
        openAppSettings();
      }
    } else if (status.isGranted) {
      if (function != null) {
        function();
      }
    }
  }

  static Future<void> requestGalleryPermission(Function? function) async {
    final photosStatus = await Permission.photos.status;
    final storageStatus = await Permission.storage.status;
    if (photosStatus.isDenied || storageStatus.isDenied) {
      // Request permission
      final result = await Permission.photos.request();
      final storageResult = await Permission.storage.request();
      if (result.isGranted && storageResult.isGranted) {
        if (function != null) {
          function();
        }
      } else if (result.isPermanentlyDenied ||
          storageResult.isPermanentlyDenied) {
        // Open app settings
        openAppSettings();
      }
    } else if (photosStatus.isGranted && storageStatus.isGranted) {
      if (function != null) {
        function();
      }
    }
  }
}
