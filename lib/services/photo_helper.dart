import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class GalleryHelper {
  String directory;

  GalleryHelper({this.directory});

//TODO gerer les vidéos avec autoplay
  bool isPhoto(FileSystemEntity fse) {
    return !fse.path
            .substring(fse.path.lastIndexOf('/') + 1, fse.path.length)
            .startsWith('.') &&
        !fse.path
            .substring(fse.path.lastIndexOf('/') + 1, fse.path.length)
            .endsWith('mp4');
  }

  Future<List<File>> getPhotos() async {
    if (await Permission.storage.request().isGranted) {
      return await ExtStorage.getExternalStoragePublicDirectory(
              ExtStorage.DIRECTORY_DCIM + '/$directory')
          .then((dir) => new Directory(dir)
              .listSync(followLinks: false, recursive: false)
              .where((fse) => isPhoto(fse))
              .map((f) => File(f.path))
              .toList());
    } else {
      print('not granted');
      return null;
    }
  }
}
