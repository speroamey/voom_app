import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voom_app/mainList.dart';
import 'package:voom_app/personClass.dart';
import 'package:voom_app/services.dart';

class TypePage extends StatefulWidget {
  @override
  _TypePageState createState() => new _TypePageState();
}

class _TypePageState extends State<TypePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Color _color = Colors.blueGrey.shade300.withOpacity(0.5);
    return new Scaffold(
        appBar: new AppBar(
            backgroundColor: _color,
            elevation: 0.0,
            title: new Text("Log in",
                style: new TextStyle(color: Colors.black38))),
        body: new Container(
            color: _color,
            child: new Column(children: <Widget>[
              new Expanded(
                  child: new Center(
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                    new Container(
                        color: Colors.red,
                        constraints: new BoxConstraints(
                            minWidth: 60.0,
                            maxWidth: 60.0,
                            maxHeight: height / 5,
                            minHeight: 60.0),
                        child: new Image.asset("images/voiture.jpg",
                            fit: BoxFit.cover)),
                    new Padding(
                        padding: new EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: MediaQuery.of(context).size.width / 4),
                        child: new Text(
                            "Vous pouvez choisir driver si vous êtes un chauffeur....",
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                color: Colors.black38,
                                fontWeight: FontWeight.w400,
                                fontSize: 20.0)))
                  ]))),
              new Expanded(
                  child: new Container(
                color: Theme.of(context).cardColor,
                child: new ListView(children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 3.0),
                    child: new ListTile(
                        leading: null,
                        title: new Text("Choisissez votre compte",
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
