import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ValidationScreen extends StatefulWidget {
  @override
  _ValidationScreenState createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context).settings.arguments;
    final List<File> photos = data['photos'];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('GalleryCleaner'),
      ),
      body: new GridView.builder(
          itemCount: photos.length,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              elevation: 0,
              child: new InkResponse(
                child: Image.file(photos[index]),
                onTap: () {
                  photos.removeAt(index);
                  setState(() {});
                },
              ),
            );
          }),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Builder(builder: (BuildContext context) {
            return IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text("Removing from Library"),
                  ));
                });
          }),
        ],
      ),
    );
  }
}
