import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voom_app/chat.dart';
import 'package:voom_app/no-location.dart';
import 'package:voom_app/personClass.dart';
import 'package:voom_app/searchbar.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:voom_app/services.dart';
import 'package:voom_app/theme.dart';

class MainListe extends StatefulWidget {
  @override
  _MainListeState createState() => new _MainListeState();
}

class _MainListeState extends State<MainListe> {
  bool _isSearch = false;
  bool _contactsOptions = false;
  List<int> _contactOptionsPinned = [];
  static const platform = const MethodChannel('samples.flutter.io/battery');
  static const String cle = "AIzaSyCaMHp0T6sTfyZRznY7AGcJXhuZtAZ2VRg";
  TextStyle inputStyle = const TextStyle(
    fontSize: 15.0,
    color: Colors.white,
  );
  List<bool> _data = new List<bool>();
  static const geoKey = "AIzaSyD3t95XyJYnfRbP4mQHNIqJPxj5V9jkJ6w";
  List<Person> _contacts = [];

  var driver = new Map();
  GlobalKey<ScaffoldState> _scalfoldKey = new GlobalKey<ScaffoldState>();
  Map<String, double> _currentLocation = <String, double>{};
  String _search = '';

  _getMyPosition() async {
    bool check =
        await SimplePermissions.checkPermission(Permission.AccessFineLocation);
    if (!check) {
      bool request = await SimplePermissions
          .requestPermission(Permission.AccessFineLocation);
      if (!request) {
        _scalfoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text("Vous devez activer la géolocalisation")));
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (BuildContext context) {
          return new NoLocation();
        }), ModalRoute.withName('/no-location'));
        return;
      }
    }
    Location location = new Location();
    try {
      _currentLocation = await location.getLocation;
      print("_currentLocation $_currentLocation");
      /* Services.instance().lat = _currentLocation['latitude'];
      Services.instance().lon = _currentLocation['longitude']; */
    } on PlatformException {
      _currentLocation = {};
    }
    location.onLocationChanged.listen((Map<String, double> currentLocation) {
      _currentLocation = currentLocation;
      /*  Services.instance().lat = _currentLocation['latitude'];
      Services.instance().lon = _currentLocation['longitude']; */
    });
  }

  @override
  void initState() {
    super.initState();
    _getMyPosition();
  }

  @override
  Widget build(BuildContext context) {
    Stream<List<Person>> contacts = Services.instance().getPersons(_search);
    return new Scaffold(
        key: _scalfoldKey,
        appBar: _buildAppBar(),
        body: new StreamBuilder(
            stream: contacts,
            builder:
                (BuildContext context, AsyncSnapshot<List<Person>> snapchot) {
              if (snapchot.hasError || snapchot.data == null) {
                return new Center(child: new CircularProgressIndicator());
              }
              _contacts = snapchot.data;
              return new Container(
                  decoration: new BoxDecoration(color: Colors.grey.shade200),
                  child: new ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        bool isSelected =
                            this._contactOptionsPinned.contains(index);
                        return new DriversList(_contacts[index], isSelected,
                            index, _onTap, _onLongPress);
                      },
                      itemCount: _contacts.length));
            }));
  }

  _onLongPress(int index) {
    this._pressedToOptions(index);
  }

  void _pressedToOptions(int i) {
    if (i == null) return;
    setState(() {
      if (_contactOptionsPinned.contains(i)) {
        _contactOptionsPinned.remove(i);
      } else {
        _contactOptionsPinned.add(i);
      }
      if (_contactOptionsPinned.length <= 0) {
        _contactsOptions = false;
      } else
        _contactsOptions = true;
    });
  }

  _onTap(int i) {
    if (!_contactsOptions) {
      Navigator
          .of(context)
          .push(new MaterialPageRoute(builder: (BuildContext cxt) {
        return new ChatPage(_contacts[i]);
      }));
    } else {
      _pressedToOptions(i);
      return;
    }
    setState(() {
      _contactOptionsPinned = [];
      _contactsOptions = false;
    });
  }

  AppBar _buildAppBar() {
    AppBar appBar;
    if (_contactsOptions) {
      appBar = new AppBar(
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _contactsOptions = false;
                  _contactOptionsPinned = [];
                });
              }),
          title: new Text(_contactOptionsPinned.length.toString()),
          actions: <Widget>[
            new PopupMenuButton<WhyFarther>(
              onSelected: (WhyFarther result) {
                if (result == WhyFarther.Note) {
                  _showNoteDialog();
                }
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<WhyFarther>>[
                    const PopupMenuItem<WhyFarther>(
                        value: WhyFarther.Note, child: const Text('Noter'))
                  ],
            )
          ]);
    } else if (_isSearch) {
      appBar = new AppBar(
          backgroundColor: Colors.white,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: thirdColor),
              onPressed: () {
                setState(() {
                  _isSearch = false;
                  _search = '';
                });
              }),
          title: new SearchBar(_search, _onSearch, "Rechercher ..."),
          elevation: 10.0,
          actions: <Widget>[
            new IconButton(
              padding: new EdgeInsets.all(0.0),
              tooltip: "Effacer la recherche",
              iconSize: 20.0,
              icon: new Icon(Icons.close,
                  color: _search.isEmpty ? Colors.transparent : Colors.black),
              onPressed: () {
                setState(() {
                  _search = '';
                });
              },
            )
          ]);
    } else {
      appBar = new AppBar(
          automaticallyImplyLeading: false,
          title: new Text('Voom'),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    this._isSearch = true;
                  });
                }),
            new PopupMenuButton<ActionsMenu>(
              onSelected: (ActionsMenu result) {
                /*  setState(() {
                                    _selection = result;
                                  }); */
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<ActionsMenu>>[
                    const PopupMenuItem<ActionsMenu>(
                        value: ActionsMenu.covoiturage,
                        child: const Text('Co-voiturages'))
                  ],
            )
          ]);
    }
    return appBar;
  }

  _onSearch(String search) {
    setState(() {
      _search = search;
    });
  }

  void _showNoteDialog() {
    String str = '';
    if (_contactOptionsPinned.length == 1) {
      str = 'Noter ';
    } else {
      str = "Noter les ${_contactOptionsPinned.length} persons";
    }
    final phoneNumber = new TextFormField(
        keyboardType: TextInputType.number,
        autofocus: true,
        onFieldSubmitted: (String value) {
          //_onLogin();
        },
        decoration: InputDecoration(
            labelText: "votre note",
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0)));
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return new SimpleDialog(
              titlePadding: new EdgeInsets.all(0.0),
              contentPadding: new EdgeInsets.only(
                  top: 12.0, bottom: 16.0, left: 10.0, right: 10.0),
              title: new Container(
                  padding: new EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 18.0),
                  color: secondaryColor,
                  child: new Text("$str",
                      style: new TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w600))),
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: phoneNumber,
                ),
                new ButtonTheme.bar(
                    child: new ButtonBar(children: <Widget>[
                  new FlatButton(child: new Text("Valider"), onPressed: () {})
                ]))
              ]);
        });
  }
}

class DriversList extends StatelessWidget {
  final Person driver;
  final Function onTap;
  final Function onLongPress;
  final int index;
  final bool isSelected;

  DriversList(
      this.driver, this.isSelected, this.index, this.onTap, this.onLongPress);

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(
            "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=Washington,DC&destinations=New+York+City,NY"),
        headers: {
          "key": "AIzaSyCaMHp0T6sTfyZRznY7AGcJXhuZtAZ2VRg",
          "Accept": "application/json"
        });
    List data = new List();
    data.add(json.decode(response.body));
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.all(isSelected ? 0.0 : 2.0),
        padding: new EdgeInsets.symmetric(
            vertical: isSelected ? 0.0 : 2.0, horizontal: 1.0),
        color: Theme.of(context).cardColor,
        child: new Material(
            child: new InkWell(
                splashColor: splashColor,
                onTap: () {
                  onTap(index);
                },
                onLongPress: () {
                  onLongPress(index);
                },
                child: new Container(
                  color: isSelected ? Colors.grey.shade300 : null,
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 8.0, left: 5.0, right: 8.0),
                          child: new Stack(children: _buildAvatar()),
                        ),
                        new Expanded(
                            child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              new Text(driver.name ?? driver.phone,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline
                                      .copyWith(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54)),
                              new Text(driver.phone,
                                  maxLines: 2,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .subhead
                                      .copyWith(color: Colors.black54),
                                  overflow: TextOverflow.ellipsis)
                            ])),
                        new Container(
                            padding: new EdgeInsets.all(8.0),
                            child: new Column(children: <Widget>[
                              new Text(driver.distance,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey)),
                              new Text(driver.note,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade900))
                            ]))
                      ]),
                ))));
  }

  List<Widget> _buildAvatar() {
    List<Widget> children = [
      new Container(
          width: 50.0,
          height: 50.0,
          decoration:
              new BoxDecoration(shape: BoxShape.circle, color: primaryColor),
          child: new ClipOval(
              child: new InkWell(
                  child: new Center(
                      child: new Icon(Icons.person,
                          color: isSelected ? Colors.black54 : Colors.white)))))
    ];

    if (isSelected) {
      children.add(new Center(
          child: new IconButton(
              onPressed: () {},
              icon: new Icon(Icons.check, size: 30.0, color: Colors.white))));
    }

    return children;
  }
}

enum WhyFarther { Note, smarter, selfStarter, tradingCharter }
enum ActionsMenu { covoiturage }
