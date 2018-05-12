import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voom_app/chat.dart';
import 'package:voom_app/personClass.dart';
import 'package:voom_app/searchbar.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:voom_app/src/theme.dart';

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

  final List<Person> Drivers = [
    new Person('Toto', "1345151", 12.2, 6.0),
    new Person('Tato', "1345151", 12.2, 6.0),
    new Person('Noto', "1345151", 12.2, 6.0),
    new Person('Voto', "1345151", 12.2, 6.0),
    new Person('Poto', "1345151", 12.2, 6.0),
    new Person('Eoto', "1345151", 12.2, 6.0),
    new Person('Loto', "1345151", 12.2, 6.0)
  ];

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
        print("Vous devez activer la géolocalisation");
        _scalfoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text("Vous devez activer la géolocalisation")));
        return;
      }
    }
    Location location = new Location();

// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _currentLocation = await location.getLocation;
    } on PlatformException {
      _currentLocation = {};
    }
    location.onLocationChanged.listen((Map<String, double> currentLocation) {
      _currentLocation = currentLocation;
    });
  }

  @override
  void initState() {
    super.initState();
    _getMyPosition();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scalfoldKey,
        appBar: _buildAppBar(),
        body: new Container(
            decoration: new BoxDecoration(color: Colors.grey.shade200),
            child: new ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                bool isSelected = this._contactOptionsPinned.contains(index);
                return new DriversList(this.Drivers[index], isSelected, index,
                    _onTap, _onLongPress);
              },
              itemCount: this.Drivers.length,
            )));
  }

  _onLongPress(int index) {
    print('onLongPress $index');
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
    print('details');
    if (!_contactsOptions) {
      Navigator
          .of(context)
          .push(new MaterialPageRoute(builder: (BuildContext cxt) {
        return new ChatPage(this.Drivers[i]);
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
                /*  setState(() {
                  _selection = result;
                }); */
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
                })
          ]);
    }
    return appBar;
  }

  _onSearch(String search) {
    setState(() {
      _search = search;
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
                              new Text(driver.name,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline
                                      .copyWith(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54)),
                              new Text(driver.phone,
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
                              new Text("3m",
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey)),
                              new Text("4/5",
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
