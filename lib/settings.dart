import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voom_app/personClass.dart';
import 'package:voom_app/services.dart';
import 'package:voom_app/theme.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TapDownDetails _details;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Paramètrages")),
        body: new SingleChildScrollView(
            child: new Container(
                color: Colors.grey.shade200,
                child: new Column(children: buildContent()))));
  }

  List<Widget> buildContent() {
    List<Widget> children = [];
    if (Services.instance.title == UserTitle.Driver) {
      children.addAll([
        new Container(
            padding: const EdgeInsets.all(12.0),
            child: new Row(children: <Widget>[
              new Expanded(
                child: new Text('Conducteurs',
                    overflow: TextOverflow.ellipsis,
                    style: Theme
                        .of(context)
                        .textTheme
                        .display1
                        .copyWith(fontWeight: FontWeight.w600, fontSize: 15.0)),
              ),
              new Icon(Icons.drive_eta, size: 15.0, color: Colors.black38)
            ])),
        new Card(
            margin: new EdgeInsets.all(0.0),
            elevation: 0.0,
            child:
                new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              new GestureDetector(
                onTapDown: (TapDownDetails details) {
                  _details = details;
                },
                onTap: () {
                  if (_details == null) return;
                  showMenu(
                      context: context,
                      position: new RelativeRect.fromLTRB(
                        _details.globalPosition.dx,
                        _details.globalPosition.dy,
                        _details.globalPosition.dx,
                        _details.globalPosition.dy,
                      ),
                      items: [1, 2, 3, 4, 5].map((int value) {
                        return new PopupMenuItem(
                            value: value, child: new Text("${value}Km"));
                      }).toList()).then((int result) {
                    _details = null;
                    if (result != null) {
                      setState(() {
                        Services.settings.distanceToShow = result;
                      });
                    }
                  });
                },
                child: new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Row(children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 3.0),
                        child:
                            const Icon(Icons.ev_station, color: Colors.brown),
                      ),
                      new Expanded(
                          child: new ListTile(
                        title: new Text("Distance des conducteurs disponible"),
                      )),
                      new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              new Text('${Services.settings.distanceToShow}km'))
                    ])),
              ),
              new Divider(),
              new GestureDetector(
                onTap: () {
                  _showNoteDialog();
                },
                child: new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Row(children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 3.0),
                        child: const Icon(Icons.note, color: Colors.brown),
                      ),
                      new Expanded(
                          child: new ListTile(
                              title: new Text(
                                  "Voir les conducteurs avec une note"))),
                      new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Text(">${Services.settings.noteSetting}"))
                    ])),
              ),
              new Divider(),
              new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Row(children: <Widget>[
                    new Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 3.0),
                        child: const Icon(Icons.filter_list,
                            color: Colors.blueGrey)),
                    new Expanded(
                        child: new ListTile(
                            title:
                                new Text("Ordonner les conducteurs par nom"))),
                    new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Switch(
                            value: Services.settings.orderDriverByName,
                            onChanged: (value) {
                              setState(() {
                                Services.settings.orderDriverByName = value;
                              });
                            }))
                  ])),
              new Divider(),
              new GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext cxt) {
                        TextEditingController priceCtrl =
                            new TextEditingController(
                                text: Services.settings.taxation);
                        return new SimpleDialog(
                            titlePadding: new EdgeInsets.all(0.0),
                            title: new Container(
                              padding: const EdgeInsets.fromLTRB(
                                  24.0, 24.0, 24.0, 20.0),
                              color: Colors.grey[200],
                              child: new RichText(
                                  text: new TextSpan(children: [
                                new TextSpan(
                                    text: "Le prix sur ",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400)),
                                new TextSpan(
                                    text: "1km",
                                    style: new TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w300))
                              ])),
                            ),
                            children: <Widget>[
                              new Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 3.0),
                                child: new TextField(
                                    controller: priceCtrl,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      new WhitelistingTextInputFormatter(
                                          new RegExp(r"[0-9]")),
                                      new LengthLimitingTextInputFormatter(8)
                                    ],
                                    decoration: new InputDecoration(
                                        labelText: "Entrer votre prix")),
                              ),
                              new ButtonTheme.bar(
                                  child: new ButtonBar(children: <Widget>[
                                new FlatButton(
                                    child: new Text("Valider"),
                                    onPressed: () {
                                      setState(() {
                                        Services.settings.taxation =
                                            priceCtrl.text;
                                      });
                                      Navigator.of(context).pop();
                                    })
                              ]))
                            ]);
                      });
                },
                child: new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Row(children: <Widget>[
                      new Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 3.0),
                          child: new Icon(Icons.monetization_on,
                              color: Colors.green.shade300)),
                      new Expanded(
                          child: new ListTile(
                        title: new Text("Votre taxation"),
                        subtitle: new Text("Par Kilomètre"),
                      )),
                      new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Text("${Services.settings.taxation}f",
                              style: new TextStyle(
                                  fontSize: 13.0, fontWeight: FontWeight.w300)))
                    ])),
              )
            ])),
      ]);
    }

    children.add(new Container(
        padding: const EdgeInsets.all(12.0),
        child: new Row(children: <Widget>[
          new Expanded(
              child: new Text('Notifications',
                  overflow: TextOverflow.ellipsis,
                  style: Theme
                      .of(context)
                      .textTheme
                      .display1
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 15.0))),
          new Icon(Icons.notifications, size: 15.0, color: Colors.black38)
        ])));
    children.addAll([
      new Card(
          margin: new EdgeInsets.all(0.0),
          elevation: 0.0,
          child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Row(children: <Widget>[
                  new Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 3.0),
                      child: const Icon(Icons.notifications_active,
                          color: Colors.teal)),
                  new Expanded(
                      child: new ListTile(
                          title: new Text(
                              "Activer la notifications pour une commande"))),
                  new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Switch(
                          value: Services.settings.commandNotif,
                          onChanged: (bool value) {
                            setState(() {
                              Services.settings.commandNotif = value;
                            });
                          }))
                ])),
            new Divider(),
            new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Row(children: <Widget>[
                  new Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 3.0),
                      child: const Icon(Icons.notifications_none,
                          color: Colors.teal)),
                  new Expanded(
                      child: new ListTile(
                          title: new Text(
                              "Activer la notification pour une publication de covoiturage"))),
                  new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Switch(
                          value: Services.settings.covoiturageNotif,
                          onChanged: (bool value) {
                            setState(() {
                              Services.settings.covoiturageNotif = value;
                            });
                          }))
                ]))
          ]))
    ]);
    return children;
  }

  void _showNoteDialog() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return new SettingsNote();
        }).then((result) {
      setState(() {});
    });
  }
}

class SettingsNote extends StatefulWidget {
  @override
  _SettingsNoteState createState() => new _SettingsNoteState();
}

class _SettingsNoteState extends State<SettingsNote> {
  @override
  Widget build(BuildContext context) {
    return new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      new Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [1, 2, 3, 4, 5].map((int value) {
                      return new Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: new GestureDetector(
                              onTap: () {
                                setState(() {
                                  Services.settings.noteSetting = value;
                                });
                              },
                              child: new CircleAvatar(
                                  backgroundColor:
                                      Services.settings.noteSetting == value
                                          ? primaryColor
                                          : Colors.grey.shade300,
                                  child: new Text('$value'))));
                    }).toList()),
                new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [6, 7, 8, 9, 10].map((int value) {
                      return new Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: new GestureDetector(
                              onTap: () {
                                setState(() {
                                  Services.settings.noteSetting = value;
                                });
                              },
                              child: new CircleAvatar(
                                  backgroundColor:
                                      Services.settings.noteSetting == value
                                          ? primaryColor
                                          : Colors.grey.shade300,
                                  child: new Text('$value'))));
                    }).toList())
              ])),
      new ButtonTheme.bar(
          child: new ButtonBar(children: <Widget>[
        new FlatButton(
            child: new Text("Ok"),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ]))
    ]);
  }
}
