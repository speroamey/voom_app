import 'package:flutter/material.dart';

class CoVoiturage extends StatefulWidget {
  @override
  _CoVoiturageState createState() => new _CoVoiturageState();
}

class _CoVoiturageState extends State<CoVoiturage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: new AppBar(title: new Text("Co")));
  }
}
