import 'package:flutter/material.dart';
import 'package:voom_app/theme.dart';

class CommandPage extends StatefulWidget {
  final String title;

  CommandPage({this.title});
  @override
  _CommandPageState createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {
  String destinationText = '';
  TextField destination;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    repeat: ImageRepeat.repeat,
                    fit: BoxFit.contain,
                    image: AssetImage("images/map.jpg"))),
            child: Stack(children: <Widget>[
              Positioned(
                  top: MediaQuery.of(context).padding.top + 5.0,
                  left: 2.0,
                  right: 2.0,
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Card(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        elevation: 12.0,
                        child: Container(
                            color: Theme.of(context).cardColor,
                            child: destination)),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 2.0),
                            child: Row(
                                children: [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
                                    .map((int value) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                child: Chip(
                                    backgroundColor: Colors.red[400],
                                    label: Text('Chip $value',
                                        style: TextStyle(color: Colors.white))),
                              );
                            }).toList())))
                  ])),
              Positioned(
                  bottom: 5.0,
                  left: 2.0,
                  child: Container(
                      padding: new EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black45),
                      child: BackButton(color: Colors.white)))
            ])));
  }

  void initialize() {
    destination = TextField(
        autofocus: false,
        onChanged: (String value) {
          destinationText = value;
        },
        decoration: InputDecoration(
            suffixIcon: Icon(Icons.location_city),
            labelText: "Voulez-vous aller à",
            hintText: 'Saisissez votre destination',
            contentPadding: EdgeInsets.all(10.0)));
  }
}

class CommandInfo {
  String destinationText;
  double lat;
  double lon;
  CommandInfo({this.destinationText, this.lat, this.lon});
}

/*
  Container(
            padding:  EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            color: secondaryColor,
            child:  Text("${widget.title}",
                style:  TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w800))),
         ButtonTheme.bar(
            child:  ButtonBar(children: <Widget>[
           FlatButton(
              child:  Text("Valider"),
              onPressed: () {
                CommandInfo info =
                     CommandInfo(destinationText: destinationText);
                Navigator.of(context).pop(info);
              })
        ])),
        SafeArea(
            top: true,
            child:  Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: destination))
                */
