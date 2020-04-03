import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterapp/screens/validation_screen.dart';
import 'package:flutterapp/services/photo_helper.dart';
import 'package:swipe_stack/swipe_stack.dart';

void main() => runApp(
      MaterialApp(
        title: 'GalleryCleaner',
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/validation': (context) => ValidationScreen(),
        },
        theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            backgroundColor: Colors.blueAccent,
            bottomAppBarColor: Colors.white),
      ),
    );

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GalleryHelper _galleryHelper;
  List<File> selectedPhotos = new List();

  @override
  void initState() {
    super.initState();
    _galleryHelper = GalleryHelper(directory: 'Camera');
    _galleryHelper.getPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: Text('GalleryCleaner'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.check),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/validation',
                    arguments: {'photos': selectedPhotos});
              }),
        ],
      ),
      body: _galleryHelper.photos == null
          ? Center(
              child: Container(
                child: Text('Loading...'),
              ),
            )
          : Container(
              color: Colors.black26,
              child: SwipeStack(
                children: _galleryHelper.photos.map((f) {
                  return SwiperItem(
                      builder: (SwiperPosition position, double progress) {
                    return Center(child: Image.file(f));
                  });
                }).toList(),
                visibleCount: 2,
                stackFrom: StackFrom.None,
                translationInterval: 1,
                scaleInterval: 0.01,
                onEnd: () => debugPrint("onEnd"),
                onSwipe: (int index, SwiperPosition position) =>
                    position == SwiperPosition.Right
                        ? selectedPhotos.add(_galleryHelper.photos[index])
                        : print('lol'),
                //debugPrint("onSwipe $index $position"),
                onRewind: (int index, SwiperPosition position) =>
                    debugPrint("onRewind $index $position"),
              ),
            ),
      //TODO remplacer BottomNavigationBar par des boutons avec un layout adapté
      bottomNavigationBar: Opacity(
        opacity: 0.6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_upward),
              onPressed: () {
                setState(() {
                  _galleryHelper.photos.sort((a, b) =>
                      b.lastModifiedSync().compareTo(a.lastModifiedSync()));
                });
                print('croissant');
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_downward),
              onPressed: () {
                setState(() {
                  _galleryHelper.photos.sort((a, b) =>
                      a.lastModifiedSync().compareTo(b.lastModifiedSync()));
                });
                print('decroissant');
              },
            ),
            IconButton(
              icon: Icon(Icons.repeat),
              onPressed: () {
                setState(() {
                  _galleryHelper.photos.shuffle();
                });
                print('hasard');
              },
            ),
          ],
        ),
      ),
    );
  }
}
