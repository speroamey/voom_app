import 'package:flutter/material.dart';
import 'package:voom_app/publish_covoiturage.dart';
import 'package:voom_app/searchbar.dart';
import 'package:voom_app/services.dart';

class CoVoiturage extends StatefulWidget {
  @override
  _CoVoiturageState createState() => _CoVoiturageState();
}

class _CoVoiturageState extends State<CoVoiturage> {
  FilterEnum currentFilter = FilterEnum.Name;

  GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  bool isSearch = false;

  String _search = '';

  @override
  Widget build(BuildContext context) {
    TapDownDetails _details;
    return Scaffold(
        key: _scaffold,
        backgroundColor: Colors.grey.shade300,
        appBar: _buildAppBar(),
        body: ListView.builder(
            padding: EdgeInsets.all(0.0),
            itemCount: 15,
            itemBuilder: (BuildContext cxt, int index) {
              return Container(
                  margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                      dense: true,
                      leading: null,
                      title: Text("Nom du pusher",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                              fontSize: 16.0)),
                      subtitle: Container(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                            Text("Lomé-Cotonou",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0)),
                            Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(right: 1.0),
                                      child: Icon(Icons.av_timer, size: 10.0)),
                                  Text("dans 35mn",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 11.0))
                                ])
                          ])),
                      trailing: Container(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              GestureDetector(
                                  onTapDown: (TapDownDetails details) {
                                    _details = details;
                                  },
                                  onTap: () {
                                    showMenu(
                                        context: context,
                                        position: RelativeRect.fromLTRB(
                                            _details.globalPosition.dx,
                                            _details.globalPosition.dy,
                                            0.0,
                                            0.0),
                                        items: [
                                          PopupMenuItem(
                                              value: CoActions.Interest,
                                              child: Text('Reserver la place'))
                                        ]).then((CoActions result) {
                                      if (result == CoActions.Interest) {
                                        //Services.instance.sendMessage();
                                        reservePlace();
                                      }
                                    });
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Icon(Icons.more_vert,
                                          color: Colors.black))),
                              Row(mainAxisSize: MainAxisSize.min, children: <
                                  Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 1.0),
                                  child: Icon(Icons.access_time, size: 10.0),
                                ),
                                Text("21 min ago",
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.black87.withOpacity(1.0),
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w300))
                              ])
                            ]),
                      ),
                      onTap: () {
                        showPublishDetails();
                      }));
            }));
  }

  AppBar _buildAppBar() {
    if (isSearch) {
      return AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  isSearch = false;
                  _search = '';
                });
              }),
          title: SearchBar(_search, (String search) {
            setState(() {
              _search = search;
            });
          }, 'rechercher un trajet'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close,
                    color: _search.isEmpty ? Colors.transparent : null),
                onPressed: () {
                  setState(() {
                    _search = '';
                  });
                })
          ]);
    }
    return AppBar(
        title: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Co voiturage"),
              Text('32 publications',
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 10.0))
            ]),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                _filterList();
              }),
          PopupMenuButton<CoActions>(
              onSelected: (CoActions result) {
                if (result == CoActions.Search) {
                  setState(() {
                    isSearch = true;
                  });
                } else if (result == CoActions.Publier) {
                  if (Services.instance.isConnected) {
                    Navigator.of(context).push(MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (BuildContext context) {
                          return PublishCoVoiturage();
                        }));
                  } else {
                    _scaffold.currentState.showSnackBar(
                        SnackBar(content: Text("Vous n'êtes pas connecté")));
                  }
                }
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<CoActions>>[
                    PopupMenuItem<CoActions>(
                        value: CoActions.Search, child: Text('Rechercher')),
                    PopupMenuItem<CoActions>(
                        value: CoActions.Publier, child: Text('Publier'))
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

  void showPublishDetails() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext cxt) {
          return ListView(
              padding: EdgeInsets.only(
                  left: 0.0, top: 8.0, right: 0.0, bottom: 15.0),
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                    isThreeLine: true,
                    title: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "Aujourd'hui à 18h30\n",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                      TextSpan(
                          text: "Lomé-Cotonou",
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black))
                    ])),
                    subtitle: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "De Hedranawoe",
                          style: TextStyle(color: Colors.black45)),
                      TextSpan(
                          text: " à Cotonou St Michel",
                          style: TextStyle(color: Colors.black45))
                    ])),
                    trailing: RichText(
                        textAlign: TextAlign.end,
                        text: TextSpan(children: [
                          TextSpan(
                              text: "500F\n",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: "par place\n\n",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: "2 places restantes",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black))
                        ]))),
                ButtonTheme.bar(
                    child: ButtonBar(children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(3.0)),
                      child: FlatButton(
                          child: Text("Reserver la place"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            reservePlace();
                          }))
                ]))
              ]);
        });
  }

  void reservePlace() {
    showDialog(
        context: context,
        builder: (BuildContext cxt) {
          return AlertDialog(
              title: Text("Reserver la place"),
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[]),
              actions: <Widget>[
                FlatButton(
                    child: Text("Annuler"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                FlatButton(
                    child: Text("Reserver"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }
}

enum CoActions { Publier, Interest, Search }
enum FilterEnum { Name, HourDeparture, TimePublished, Trajet }
enum WhyFarther { harder, smarter, selfStarter, tradingCharter }
