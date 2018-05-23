import 'package:flutter/material.dart';
import 'package:voom_app/publish_covoiturage.dart';

class CoVoiturage extends StatefulWidget {
  @override
  _CoVoiturageState createState() => new _CoVoiturageState();
}

class _CoVoiturageState extends State<CoVoiturage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: _buildAppBar(),
        body: new ListView.builder(
            itemCount: 15,
            itemBuilder: (BuildContext cxt, int index) {
              return new Container(
                  margin:
                      new EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
                  color: Theme.of(context).cardColor,
                  child: new ListTile(
                      leading: null,
                      title: new Text("Nom du pusher"),
                      subtitle: new Text("Trajet"),
                      trailing: new Center(
                          child: new Column(children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Icon(Icons.more_vert),
                        ),
                        new Text("23m")
                      ])),
                      onTap: () {}));
            }));
  }

  AppBar _buildAppBar() {
    return new AppBar(
        title: new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text("Co voiturage"),
              new Text('32 publications', style: new TextStyle(fontSize: 10.0))
            ]),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.filter_list), onPressed: () {}),
          new PopupMenuButton<CoActions>(
              onSelected: (CoActions result) {
                if (result == CoActions.Publier) {
                  Navigator.of(context).push(new MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) {
                        return new PublishCoVoiturage();
                      }));
                }
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<CoActions>>[
                    new PopupMenuItem<CoActions>(
                        value: CoActions.Publier, child: new Text('Publier'))
                  ])
        ]);
  }
}

enum CoActions { Publier }
