import 'package:flutter/material.dart';
import 'package:voom_app/personClass.dart';

class DetailsPage extends StatefulWidget {
  final Person driver;

  DetailsPage(this.driver);
  @override
  _DetailsPageState createState() => new _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("A propos du conducteur")));
  }
}
