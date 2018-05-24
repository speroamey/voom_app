import 'package:flutter/material.dart';
import 'package:voom_app/publish_covoiturage.dart';

class CoVoiturage extends StatefulWidget {
  @override
  _CoVoiturageState createState() => new _CoVoiturageState();
}

class _CoVoiturageState extends State<CoVoiturage> {
  FilterEnum currentFilter = FilterEnum.Name;

  @override
  Widget build(BuildContext context) {
    TapDownDetails _details;
    return new Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: _buildAppBar(),
        body: new ListView.builder(
            padding: new EdgeInsets.all(0.0),
            itemCount: 15,
            itemBuilder: (BuildContext cxt, int index) {
              return new Container(
                  margin:
                      new EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                  color: Theme.of(context).cardColor,
                  child: new ListTile(
                      dense: true,
                      leading: null,
                      title: new Text("Nom du pusher",
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: 22.0)),
                      subtitle: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Text("Lomé-Cotonou",
                                style: new TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15.0)),
                            new Row(children: <Widget>[
                              new Padding(
                                  padding: const EdgeInsets.only(right: 1.0),
                                  child: new Icon(Icons.av_timer, size: 10.0)),
                              new Text("dans 35mn",
                                  style: new TextStyle(
                                      color: Colors.black54, fontSize: 11.0))
                            ])
                          ]),
                      trailing: new Container(
                        alignment: Alignment.centerRight,
                        child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              new GestureDetector(
                                  onTapDown: (TapDownDetails details) {
                                    _details = details;
                                  },
                                  onTap: () {
                                    showMenu(
                                        context: context,
                                        position: new RelativeRect.fromLTRB(
                                            _details.globalPosition.dx,
                                            _details.globalPosition.dy,
                                            0.0,
                                            0.0),
                                        items: [
                                          new PopupMenuItem(
                                              value: CoActions.Interest,
                                              child: new Text(
                                                  'Se mettre en contact'))
                                        ]).then((CoActions result) {
                                      if (result == CoActions.Interest) {
                                        //Services.instance.sendMessage();
                                      }
                                    });
                                  },
                                  child: new Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: new Icon(Icons.more_vert,
                                          color: Colors.black))),
                              new Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Padding(
                                      padding:
                                          const EdgeInsets.only(right: 1.0),
                                      child: new Icon(Icons.access_time,
                                          size: 10.0),
                                    ),
                                    new Text("21 min ago",
                                        style: new TextStyle(
                                            fontSize: 10.0,
                                            color:
                                                Colors.black87.withOpacity(0.7),
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w200))
                                  ])
                            ]),
                      ),
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
              new Text('32 publications',
                  style: new TextStyle(
                      fontWeight: FontWeight.w100, fontSize: 10.0))
            ]),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.filter_list),
              onPressed: () {
                _filterList();
              }),
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

  void _filterList() {
    if (currentFilter == FilterEnum.Name) {
      // filter by name
      currentFilter = FilterEnum.HourDeparture;
    } else if (currentFilter == FilterEnum.HourDeparture) {
      // filter by hour departure
      currentFilter = FilterEnum.TimePublished;
    } else if (currentFilter == FilterEnum.TimePublished) {
      // filter by time published
      currentFilter = FilterEnum.Trajet;
    } else if (currentFilter == FilterEnum.Trajet) {
      // filter by depart-arrive
      currentFilter = FilterEnum.Name;
    }
  }
}

enum CoActions { Publier, Interest }
enum FilterEnum { Name, HourDeparture, TimePublished, Trajet }
enum WhyFarther { harder, smarter, selfStarter, tradingCharter }
