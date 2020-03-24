import 'package:flutter/material.dart';
import 'package:flutterapp/services/photo_helper.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

//TODO peut etre virer cette partie de routes qui est inutile
class _LoadingState extends State<Loading> {
  GalleryHelper galleryHelper = new GalleryHelper(directory: 'Camera');

  @override
  void initState() {
    super.initState();
    loadGalleryHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Text('Loading...'),
      ),
    );
  }

  Future<void> loadGalleryHelper() async {
    await galleryHelper.getPhotos();
    Navigator.pushReplacementNamed(context, '/cleaner',
        arguments: {'photos': galleryHelper.photos});
  }
}
