import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voom_app/mainList.dart';
import 'package:voom_app/personClass.dart';
import 'package:voom_app/services.dart';
import 'package:image_picker/image_picker.dart';

class TypePage extends StatefulWidget {
  @override
  _TypePageState createState() => new _TypePageState();
}

class _TypePageState extends State<TypePage> {
  File image;
  bool imgExiste = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Color _color = Colors.red[400];
    return new Scaffold(
        appBar: new AppBar(
            backgroundColor: _color,
            elevation: 0.0,
            title: new Text("Profile",
                style: new TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w400))),
        body: new Container(
            color: _color,
            child: new Column(children: <Widget>[
              new Expanded(
                child: new Container(
                    decoration: BoxDecoration(color: _color),
                    child: new Center(
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                          new Container(
                              constraints: new BoxConstraints(
                                  maxHeight: height / 5, minHeight: 100.0),
                              child: new Stack(
                                alignment: const Alignment(1.2, 1.1),
                                children: <Widget>[
                                  new Container(
                                    width: 120.0,
                                    height: 120.0,
                                    child: new Container(
                                      decoration: new BoxDecoration(
                                        color: Colors.white24,
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipOval(
                                          child: imgExiste
                                              ? new Image.file(image,
                                                  fit: BoxFit.cover)
                                              : new Icon(
                                                  Icons.person,
                                                  size: 70.0,
                                                  color: Colors.white,
                                                )),
                                    ),
                                  ),
                                  new Card(
                                    color: Colors.redAccent,
                                    elevation: 15.0,
                                    shape: CircleBorder(),
                                    child: new CircleAvatar(
                                      radius: 25.0,
                                      child: new IconButton(
                                        icon: new Icon(Icons.camera_alt,
                                            size: 25.0, color: Colors.white),
                                        onPressed: setImage,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          new Padding(
                            padding: new EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal:
                                    MediaQuery.of(context).size.width / 4),
                          )
                        ]))),
              ),
              new Expanded(
                  child: new Container(
                color: Theme.of(context).cardColor,
                child: new ListView(children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 3.0),
                    child: new ListTile(
                        leading: null,
                        title: new Text("Choisissez Votre Profile",
                            style: new TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  new ListTile(
                      leading: new CircleAvatar(
                          backgroundColor: _color, child: new Text("C")),
                      title: new Text("Chauffeur"),
                      onTap: () {
                        setTitleAndNavigate(UserTitle.Driver);
                      }),
                  new Container(
                      height: 1.0,
                      color: Theme.of(context).dividerColor.withOpacity(0.05),
                      margin: new EdgeInsets.only(left: 70.0, right: 10.0)),
                  new ListTile(
                      leading: new CircleAvatar(
                          backgroundColor: _color, child: new Text("U")),
                      title: new Text("Utilisateur"),
                      onTap: () {
                        setTitleAndNavigate(UserTitle.User);
                      })
                ]),
              ))
            ])));
  }

  setImage() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    image = img;
    print(img.path);

    setState(() {
      imgExiste = true;
    });
  }

  setTitleAndNavigate(UserTitle title) async {
    if (title == null) return;
    Services.instance.title = title;
    String _title = title == UserTitle.User ? 'User' : 'Driver';
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString(AppPreferences.title, _title);
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (BuildContext context) {
      return new MainListe();
    }), ModalRoute.withName('/liste'));
  }
}
