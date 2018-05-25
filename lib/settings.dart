import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Paramètrages")),
        body: new SingleChildScrollView(
          child: new Container(
              color: Colors.grey.shade200,
              child: new Column(children: <Widget>[
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
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.0)),
                      ),
                      new Icon(Icons.drive_eta,
                          size: 15.0, color: Colors.black38)
                    ])),
                new Card(
                    margin: new EdgeInsets.all(0.0),
                    elevation: 0.0,
                    child:
                        new Column(mainAxisSize: MainAxisSize.min, children: <
                            Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Row(children: <Widget>[
                          new Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 3.0),
                            child: const Icon(Icons.ev_station,
                                color: Colors.brown),
                          ),
                          new Expanded(
                              child: new ListTile(
                            title:
                                new Text("Distance des conducteurs disponible"),
                          )),
                          new Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Text("2km"))
                        ]),
                      ),
                      new Divider(),
                      new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Row(children: <Widget>[
                            new Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, right: 3.0),
                              child:
                                  const Icon(Icons.note, color: Colors.brown),
                            ),
                            new Expanded(
                                child: new ListTile(
                              title: new Text(
                                  "Voir les conducteurs avec une note"),
                            )),
                            new Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Text(">5"))
                          ])),
                      new Divider(),
                      new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Row(children: <Widget>[
                            new Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, right: 3.0),
                              child: const Icon(Icons.filter_list,
                                  color: Colors.brown),
                            ),
                            new Expanded(
                                child: new ListTile(
                              title:
                                  new Text("Ordonner les conducteurs par nom"),
                            )),
                            new Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: new Switch(
                                    value: false, onChanged: (value) {}))
                          ])),
                      new Divider(),
                      new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Row(children: <Widget>[
                            new Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, right: 3.0),
                              child: const Icon(Icons.notifications_active,
                                  color: Colors.brown),
                            ),
                            new Expanded(
                                child: new ListTile(
                                    title: new Text("Votre taxation"))),
                            new Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: new Text("1km/150f"))
                          ]))
                    ])),
                new Container(
                    padding: const EdgeInsets.all(12.0),
                    child: new Row(children: <Widget>[
                      new Expanded(
                        child: new Text('Notifications',
                            overflow: TextOverflow.ellipsis,
                            style: Theme
                                .of(context)
                                .textTheme
                                .display1
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.0)),
                      ),
                      new Icon(Icons.notifications,
                          size: 15.0, color: Colors.black38)
                    ])),
                new Card(
                    margin: new EdgeInsets.all(0.0),
                    elevation: 0.0,
                    child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Row(children: <Widget>[
                                new Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 3.0),
                                  child: const Icon(Icons.notifications_active,
                                      color: Colors.brown),
                                ),
                                new Expanded(
                                    child: new ListTile(
                                        title: new Text(
                                            "Activer la notifications pour une commande"))),
                                new Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: new Switch(
                                        value: false, onChanged: (value) {}))
                              ])),
                          new Divider(),
                          new Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Row(children: <Widget>[
                                new Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 3.0),
                                  child: const Icon(Icons.notifications_active,
                                      color: Colors.brown),
                                ),
                                new Expanded(
                                    child: new ListTile(
                                        title: new Text(
                                            "Activer la notification pour une publication de covoiturage"))),
                                new Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: new Switch(
                                        value: false, onChanged: (value) {}))
                              ]))
                        ]))
              ])),
        ));
  }
}
