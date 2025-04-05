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
    if (photosStatus.isDenied) {
      // Request permission
      final photosResult = await Permission.photos.request();
      if (photosResult.isGranted) {
        if (function != null) {
          function();
        }
      } else if (photosResult.isPermanentlyDenied) {
        // Open app settings
        openAppSettings();
      }
    } else if (photosStatus.isGranted) {
      if (function != null) {
        function();
      }
    }
  }
}
