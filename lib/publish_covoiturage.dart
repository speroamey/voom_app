import 'package:flutter/material.dart';

class PublishCoVoiturage extends StatefulWidget {
  @override
  _PublishCoVoiturageState createState() => new _PublishCoVoiturageState();
}

class _PublishCoVoiturageState extends State<PublishCoVoiturage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Publier un trajet")),
        body: new SingleChildScrollView(
            child: new Column(children: <Widget>[
          new TextField(decoration: new InputDecoration(hintText: "From")),
          new TextField(decoration: new InputDecoration(hintText: "to")),
          new TextField(decoration: new InputDecoration(hintText: "Hour"))
        ])),
        bottomNavigationBar: new ButtonTheme.bar(
            child: new ButtonBar(children: <Widget>[
          new FlatButton(child: new Text("Publish"), onPressed: () {})
        ])));
  }
}
