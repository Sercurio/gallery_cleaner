import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterapp/screens/loading.dart';
import 'package:swipe_stack/swipe_stack.dart';

void main() => runApp(
      MaterialApp(
        title: 'GalleryCleaner',
        initialRoute: '/',
        routes: {
          '/': (context) => Loading(),
          '/cleaner': (context) => Home(),
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
  Map data = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    final List<File> photos = data['photos'];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: Text('GalleryCleaner'),
      ),
      body: Container(
        color: Colors.black26,
        child: SwipeStack(
          children: photos.map((f) {
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
              debugPrint("onSwipe $index $position"),
          onRewind: (int index, SwiperPosition position) =>
              debugPrint("onRewind $index $position"),
        ),
      ),
      //TODO remplacer BottomNavigationBar par des boutons avec un layout adapté
      //TODO croissant, decroissant, shuffle, undo
      bottomNavigationBar: Opacity(
        opacity: 0.6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_upward),
              onPressed: () {
                setState(() {
                  photos.sort((a, b) =>
                      b.lastModifiedSync().compareTo(a.lastModifiedSync()));
                });
                print('croissant');
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_downward),
              onPressed: () {
                setState(() {
                  photos.sort((a, b) =>
                      a.lastModifiedSync().compareTo(b.lastModifiedSync()));
                });
                print('decroissant');
              },
            ),
            IconButton(
              icon: Icon(Icons.repeat),
              onPressed: () {
                setState(() {
                  photos.shuffle();
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
