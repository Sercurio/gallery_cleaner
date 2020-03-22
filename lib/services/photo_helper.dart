import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class GalleryHelper {
  String directory;
  List<File> photos;

  GalleryHelper({this.directory});

  Future<bool> askPermissionForStorage() async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    Map result =
        await _permissionHandler.requestPermissions([PermissionGroup.storage]);
    if (result[PermissionGroup.storage] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  bool isPhoto(FileSystemEntity fse) {
    return !fse.path
            .substring(fse.path.lastIndexOf('/') +1, fse.path.length)
            .startsWith('.') &&
        !fse.path
            .substring(fse.path.lastIndexOf('/') + 1, fse.path.length)
            .endsWith('mp4');
  }

  Future<void> getPhotos() async {
    bool permissionGranted = await askPermissionForStorage();

    if (permissionGranted) {
      this.photos = await ExtStorage.getExternalStoragePublicDirectory(
              ExtStorage.DIRECTORY_DCIM + '/$directory')
          .then((dir) => new Directory(dir)
              .listSync(followLinks: false, recursive: false)
              .where((fse) => isPhoto(fse))
              .map((f) => File(f.path))
              .toList());
    } else
      print('not granted');
  }
}
