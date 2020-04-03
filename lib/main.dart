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
  GalleryHelper _galleryHelper = GalleryHelper(directory: 'Camera');
  List<File> galleryPhotos = new List();
  List<File> selectedPhotos = new List();

  @override
  void initState() {
    super.initState();
    _galleryHelper.getPhotos().then(
      (photos) {
        setState(
          () {
            galleryPhotos = photos;
          },
        );
      },
    );
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
              Navigator.pushNamed(context, '/validation',
                  arguments: {'photos': selectedPhotos});
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black26,
        child: galleryPhotos == null
            ? Center(
                child: Text('Loading...'),
              )
            : SwipeStack(
                children: galleryPhotos.map(
                  (f) {
                    return SwiperItem(
                      builder: (SwiperPosition position, double progress) {
                        return Center(child: Image.file(f));
                      },
                    );
                  },
                ).toList(),
                visibleCount: 2,
                stackFrom: StackFrom.None,
                translationInterval: 1,
                scaleInterval: 0.01,
                onEnd: () => debugPrint("onEnd"),
                onSwipe: (int index, SwiperPosition position) => {
                  if (position == SwiperPosition.Right)
                    selectedPhotos.add(galleryPhotos[index])
                },
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
                setState(
                  () {
                    galleryPhotos.sort((a, b) =>
                        b.lastModifiedSync().compareTo(a.lastModifiedSync()));
                  },
                );
                print('croissant');
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_downward),
              onPressed: () {
                setState(
                  () {
                    galleryPhotos.sort((a, b) =>
                        a.lastModifiedSync().compareTo(b.lastModifiedSync()));
                  },
                );
                print('decroissant');
              },
            ),
            IconButton(
              icon: Icon(Icons.repeat),
              onPressed: () {
                setState(
                  () {
                    galleryPhotos.shuffle();
                  },
                );
                print('hasard');
              },
            ),
          ],
        ),
      ),
    );
  }
}
