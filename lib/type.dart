import 'package:flutter/material.dart';
import 'package:voom_app/mainList.dart';
import 'package:voom_app/services.dart';

class TypePage extends StatefulWidget {
  @override
  _TypePageState createState() => new _TypePageState();
}

class _TypePageState extends State<TypePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Log in")),
        body: new Container(
            color: Colors.grey.shade200,
            child: new Column(children: <Widget>[
              new Expanded(
                  child: new Center(
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                    new Image.asset("images/voiture.jpg"),
                    new Text(
                        "Vous pouvez choisir driver si vous êtes un chauffeur....")
                  ]))),
              new Expanded(
                  child: new ListView(children: <Widget>[
                new ListTile(
                    leading: null,
                    title: new Text("Choisi ton compte",
                        style: new TextStyle(fontWeight: FontWeight.bold))),
                new ListTile(
                    leading: new CircleAvatar(child: new Text("C")),
                    title: new Text("Chauffeur"),
                    onTap: () {
                      Services.instance.title = 'Chauffeur';
                      Navigator.of(context).pushAndRemoveUntil(
                          new MaterialPageRoute(
                              builder: (BuildContext context) {
                        return new MainListe();
                      }), ModalRoute.withName('/liste'));
                    }),
                new ListTile(
                    leading: new CircleAvatar(child: new Text("U")),
                    title: new Text("Utilisateur"),
                    onTap: () {
                      Services.instance.title = 'Utilisateur';
                      Navigator.of(context).pushAndRemoveUntil(
                          new MaterialPageRoute(
                              builder: (BuildContext context) {
                        return new MainListe();
                      }), ModalRoute.withName('/liste'));
                    })
              ]))
            ])));
  }
}
