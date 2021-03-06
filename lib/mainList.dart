import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:voom_app/clients.dart';
import 'package:voom_app/co-voiturage.dart';
import 'package:voom_app/commands.dart';
import 'package:voom_app/details.dart';
import 'package:voom_app/no-location.dart';
import 'package:voom_app/personClass.dart';
import 'package:voom_app/searchbar.dart';
import 'package:location/location.dart';
import 'package:voom_app/services.dart';
import 'package:voom_app/settings.dart';
import 'package:voom_app/src/core.dart';
import 'package:voom_app/theme.dart';

class MainListe extends StatefulWidget {
  @override
  _MainListeState createState() => new _MainListeState();
}

class _MainListeState extends State<MainListe>
    with SingleTickerProviderStateMixin {
  bool _isSearch = false;
  bool _contactsOptions = false;
  List<int> _contactOptionsPinned = [];
  static const platform = const MethodChannel('samples.flutter.io/battery');
  static const String cle = "AIzaSyCaMHp0T6sTfyZRznY7AGcJXhuZtAZ2VRg";
  TextStyle inputStyle = const TextStyle(
    fontSize: 15.0,
    color: Colors.white,
  );
  static const geoKey = "AIzaSyD3t95XyJYnfRbP4mQHNIqJPxj5V9jkJ6w";
  List<Person> _contacts = [];

  var driver = new Map();
  GlobalKey<ScaffoldState> _scalfoldKey = new GlobalKey<ScaffoldState>();
  Map<String, double> _currentLocation = <String, double>{};
  String _search = '';

  TabController _tabCtrl;

  _getMyPosition() async {
    try {
      bool check = await SimplePermissions
          .checkPermission(Permission.AccessFineLocation);
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

      _currentLocation = await location.getLocation;
      Services.instance.lat = _currentLocation['latitude'];
      Services.instance.lon = _currentLocation['longitude'];
      if (!Services.instance.isConnected) {
        Services.instance.login(Services.instance.jid,
            (int status, condition, elem) {
          if (status == Strophe.Status['CONNECTED']) {
          } else if (status == Strophe.Status['CONNFAIL']) {}
        });
      }

      location.onLocationChanged.listen((Map<String, double> currentLocation) {
        _currentLocation = currentLocation;
        Services.instance.lat = _currentLocation['latitude'];
        Services.instance.lon = _currentLocation['longitude'];
        if (!Services.instance.isConnected) {
          Services.instance.login(Services.instance.jid,
              (int status, condition, elem) {
            if (status == Strophe.Status['CONNECTED']) {
            } else if (status == Strophe.Status['CONNFAIL']) {}
          });
        }
        if (Services.instance.isConnected) {
          num distance = distVincenty(
              Services.instance.lastSentLat,
              Services.instance.lastSentLon,
              Services.instance.lat,
              Services.instance.lon);
          if (distance > 100) {
            Services.instance.sendPresence();
          }
          // 6.356534 2.4047374 6.41070207 2.32084826
          print("distance $distance");
        }
      });
    } catch (e) {
      _scalfoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text("la recupération de votre position a echoué")));
      _currentLocation = {};
    }
  }

  @override
  void initState() {
    super.initState();
    _tabCtrl = new TabController(vsync: this, length: 2);
    _getMyPosition();
    _onLogin();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scalfoldKey,
        appBar: _buildAppBar(),
        body: new StreamBuilder(
            stream: Services.instance.persons,
            builder:
                (BuildContext context, AsyncSnapshot<List<Person>> snapchot) {
              if (snapchot.hasError ||
                  snapchot.data == null ||
                  snapchot.data.length == 0) {
                return new Center(
                    child: new Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: new Text('Pas de chauffeurs en ligne',
                            style: new TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18.0,
                                fontStyle: FontStyle.italic,
                                color: Colors.black45))));
              }
              _contacts = snapchot.data;
              return Services.instance.title == UserTitle.User
                  ? _isSimpleUser()
                  : _isDriverUser();
            }),
        floatingActionButton: new StreamBuilder(
            stream: Services.instance.commandsStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<UserCommand>> snapchot) {
              return _buildFloatingBtn();
            }));
  }

  Widget _buildFloatingBtn() {
    if (Services.instance.title == UserTitle.Driver &&
        Services.instance.commands.length > 0) {
      return new FloatingActionButton(
          tooltip: 'Les commandes',
          child: new Stack(fit: StackFit.expand, children: <Widget>[
            new Icon(Icons.shopping_cart),
            new Positioned(
                top: 15.0,
                right: 15.0,
                child:
                    new Icon(Icons.brightness_1, color: Colors.blue, size: 8.0))
          ]),
          onPressed: () {
            _showCommandsActionSheet();
          });
    }
    return new Container(width: 0.0, height: 0.0);
  }

  Widget _isDriverUser() {
    List<Widget> children = [];
    if (_contactsOptions || _isSearch) {
      children = [_isSimpleUser()];
    } else {
      children = [new ClientPage(), _isSimpleUser()];
    }
    var tab = new TabBarView(controller: _tabCtrl, children: children);
    return tab;
  }

  Widget _isSimpleUser() {
    return new Container(
        decoration: new BoxDecoration(color: Colors.grey.shade200),
        child: new ListView.builder(
            padding: new EdgeInsets.all(6.0),
            itemBuilder: (BuildContext context, int index) {
              bool isSelected = this._contactOptionsPinned.contains(index);
              return new DriversList(
                  _contacts[index], isSelected, index, _onTap, _onLongPress);
            },
            itemCount: _contacts.length));
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
      /*  Navigator
          .of(context)
          .push(new MaterialPageRoute(builder: (BuildContext cxt) {
        return ;
      })); */
      _showActionSheet(i);
    } else {
      _pressedToOptions(i);
      return;
    }
    setState(() {
      _contactOptionsPinned = [];
      _contactsOptions = false;
    });
  }

  _showActionSheet(int i) {
    Person contact = _contacts[i];
    bool canNote = false, hasCommand = false;
    if (Services.instance.hasCommandOf(contact.phone)) {
      hasCommand = true;
      canNote = true;
    }
    List<Widget> listChildren = <Widget>[];
    if (!hasCommand) {
      listChildren.add(new ListTile(
          leading: new Icon(Icons.add_shopping_cart, color: Colors.orange),
          title: new Text("Commander"),
          onTap: () {
            Navigator.of(context).pop();
            _showCommandDialog(i);
          }));
    }
    if (!hasCommand && canNote) {
      listChildren.add(new Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: new Divider(indent: 70.0)));
    }
    if (canNote) {
      listChildren.add(new ListTile(
          leading: new Icon(Icons.rate_review, color: Colors.purple.shade300),
          title: new Text("Noter"),
          onTap: () {
            Navigator.of(context).pop();
            _showNoteDialog(i);
          }));
    }
    listChildren.add(new ListTile(
        leading: new Icon(Icons.info_outline, color: Colors.grey),
        title: new Text("Details du driver"),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(new MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) {
                return new DetailsPage(contact);
              }));
        }));
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return new ListView(shrinkWrap: true, children: listChildren);
        });
  }

  AppBar _buildAppBar() {
    AppBar appBar;
    if (_contactsOptions) {
      String str = '';
      if (_contactOptionsPinned.length > 1) {
        str = " ${_contactOptionsPinned.length} taximans";
      }
      bool canNote = true, hasCommand = false;
      _contactOptionsPinned.forEach((int value) {
        Person contact = _contacts[value];
        if (Services.instance.hasCommandOf(contact.phone)) {
          hasCommand = true;
        }
        if (!Services.instance.hasCommandOf(contact.phone)) {
          canNote = false;
        }
      });
      List<PopupMenuEntry<WhyFarther>> popupActions =
          <PopupMenuEntry<WhyFarther>>[];
      if (!hasCommand) {
        popupActions.add(new PopupMenuItem<WhyFarther>(
            value: WhyFarther.Command, child: new Text('Commander$str')));
      }
      if (canNote) {
        popupActions.add(new PopupMenuItem<WhyFarther>(
            value: WhyFarther.Note, child: new Text('Noter$str')));
      }
      List<Widget> actions = <Widget>[];
      if (canNote || !hasCommand) {
        actions.add(new PopupMenuButton<WhyFarther>(
            onSelected: (WhyFarther result) {
              if (result == WhyFarther.Note) {
                _showNoteDialog();
              } else if (result == WhyFarther.Command) {
                _showCommandDialog();
              }
            },
            itemBuilder: (BuildContext context) => popupActions));
      }
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
          actions: actions);
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
                Services.instance.searchPerson(_search);
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
                  Services.instance.searchPerson(_search);
                })
          ]);
    } else {
      List<PopupMenuEntry<ActionsMenu>> actionsMenu =
          <PopupMenuEntry<ActionsMenu>>[];
      if (Services.instance.myCommands.length > 0) {
        actionsMenu.add(const PopupMenuItem<ActionsMenu>(
            value: ActionsMenu.MyCommands, child: const Text('Mes commandes')));
      }
      actionsMenu.add(const PopupMenuItem<ActionsMenu>(
          value: ActionsMenu.covoiturage, child: const Text('Co-voiturages')));
      actionsMenu.add(const PopupMenuItem<ActionsMenu>(
          value: ActionsMenu.Settings, child: const Text('Paramètres')));
      Widget title = new Text('Voom');
      if (!Services.instance.isConnected) {
        title = new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          new Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: new Text('Voom')),
          new SizedBox(
              width: 18.0,
              height: 18.0,
              child: new Theme(
                  data: new ThemeData(
                      accentColor: Colors.white, primaryColor: Colors.white),
                  child: new CircularProgressIndicator(
                      backgroundColor: Colors.white, strokeWidth: 2.0)))
        ]);
      }
      appBar = new AppBar(
          automaticallyImplyLeading: false,
          title: title,
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
                  if (result == ActionsMenu.covoiturage) {
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return new CoVoiturage();
                    }));
                  } else if (result == ActionsMenu.MyCommands) {
                    _showMyCommandsActionSheet();
                  } else if (result == ActionsMenu.Settings) {
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return new SettingsPage();
                    }));
                  }
                },
                itemBuilder: (BuildContext context) => actionsMenu)
          ],
          bottom: Services.instance.title == UserTitle.Driver
              ? new TabBar(controller: _tabCtrl, tabs: <Widget>[
                  new Tab(text: 'Clients'),
                  new Tab(text: 'Drivers')
                ])
              : null);
    }
    return appBar;
  }

  _onLogin() async {
    Services instance = Services.instance;
    if (!instance.isConnected &&
        instance.jid != null &&
        instance.jid.isNotEmpty) {
      instance.login(instance.jid, (int status, condition, elem) {
        if (status == Strophe.Status['CONNECTED']) {
          setState(() {});
        }
      });
    }
  }

  _showCommandsActionSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return new ListView.builder(
              shrinkWrap: true,
              itemCount: Services.instance.commands.length + 1,
              itemBuilder: (BuildContext cxt, int index) {
                if (index == 0) {
                  return new ListTile(
                      title: new Text("Les commandes",
                          style: new TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey)));
                }
                UserCommand command = Services.instance.commands[index - 1];
                String time = Services.instance.getTime(command.time);
                return new ListTile(
                    leading: new Text("$index",
                        style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey)),
                    title: new Text(command.client?.name ?? '',
                        overflow: TextOverflow.ellipsis),
                    subtitle: new Text(
                        "${command.depart}-${command.destination}",
                        overflow: TextOverflow.ellipsis),
                    trailing: new Text("$time",
                        style: new TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w300,
                            fontSize: 12.0)),
                    onTap: () {});
              });
        });
  }

  _showMyCommandsActionSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return new ListView.builder(
              shrinkWrap: true,
              itemCount: Services.instance.myCommands.length + 1,
              itemBuilder: (BuildContext cxt, int index) {
                if (index == 0) {
                  return new ListTile(
                      title: new Text("Mes commandes",
                          style: new TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey)));
                }
                UserCommand myCommand = Services.instance.myCommands[index - 1];
                String time = Services.instance.getTime(myCommand.time);
                return new ListTile(
                    title: new Text(myCommand.client.name ?? '',
                        overflow: TextOverflow.ellipsis),
                    subtitle: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                              "${myCommand.depart}-${myCommand.destination}",
                              overflow: TextOverflow.ellipsis),
                          new Text("à $time",
                              style: new TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12.0))
                        ]),
                    trailing: new Container(
                        decoration: new BoxDecoration(
                            border: new Border.all(),
                            borderRadius: new BorderRadius.circular(3.0)),
                        child: new FlatButton(
                            padding: new EdgeInsets.all(0.0),
                            child: new Text("Noter"),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _showNoteDialog(null, myCommand.client);
                            })),
                    onTap: () {});
              });
        });
  }

  _onSearch(String search) {
    setState(() {
      _search = search;
    });
    Services.instance.searchPerson(_search);
  }

  void _showCommandDialog([int i]) {
    if (_contactOptionsPinned.length == 0 && i == null) return;
    String str = '';
    if (_contactOptionsPinned.length == 1 || i != null) {
      str = 'Commander ';
      int index =
          _contactOptionsPinned.length == 1 ? _contactOptionsPinned[0] : i;
      str += _contacts[index].phone ?? '';
    } else {
      str = "Commander les ${_contactOptionsPinned.length} taximans";
    }
    Navigator
        .of(context)
        .push<CommandInfo>(new MaterialPageRoute(builder: (BuildContext cxt) {
      return new CommandPage(title: str);
    })).then((CommandInfo result) {
      if (result != null) {
        List<int> tabs = i != null ? [i] : _contactOptionsPinned;
        tabs.forEach((int value) {
          Person contact = _contacts[value];
          Services.instance.sendMessage(contact.phone, result.destinationText);
          UserCommand userCmd = new UserCommand(
              'depart',
              '${result.destinationText}',
              new DateTime.now().millisecondsSinceEpoch,
              contact);
          Services.instance.myCommands.add(userCmd);
        });
      }
      setState(() {
        _contactOptionsPinned = [];
        _contactsOptions = false;
      });
    });
  }

  void _showNoteDialog([int i, Person driver]) {
    if (_contactOptionsPinned.length == 0 && i == null && driver == null)
      return;
    String str = '', initialValue = '';
    if (_contactOptionsPinned.length == 1 || i != null || driver != null) {
      str = 'Noter ';
      if (driver == null) {
        int index =
            _contactOptionsPinned.length == 1 ? _contactOptionsPinned[0] : i;
        str += _contacts[index].phone ?? '';
        initialValue = _contacts[index].note ?? '';
      } else {
        str += driver.phone ?? '';
        initialValue = driver.note ?? '';
      }
    } else {
      str = "Noter les ${_contactOptionsPinned.length} taximans";
    }
    if (initialValue.isEmpty) initialValue = '0';
    /*  String phoneNumberText = '';
    TextEditingController noteCtrl =
        new TextEditingController(text: initialValue); 
    final phoneNumber = new TextField(
        keyboardType: TextInputType.number,
        autofocus: false,
        controller: noteCtrl,
        onChanged: (String value) {
          phoneNumberText = value;
        },
        decoration: InputDecoration(
            icon: new Icon(Icons.text_fields),
            labelText: "votre note",
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0))); */
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return new NoteDialog(
              str: str,
              initialValue: initialValue,
              contactOptionsPinned: _contactOptionsPinned,
              driver: driver,
              i: i,
              contacts: _contacts);
        }).then((result) {
      setState(() {
        _contactOptionsPinned = [];
        _contactsOptions = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.symmetric(vertical: 1.0),
        padding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
        color: Theme.of(context).cardColor,
        child: new Material(
            elevation: 1.0,
            child: new InkWell(
                splashColor: splashColor,
                onTap: () {
                  onTap(index);
                },
                onLongPress: () {
                  onLongPress(index);
                },
                child: new Container(
                  color:
                      isSelected ? Colors.grey.shade300.withOpacity(0.8) : null,
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                            margin: new EdgeInsets.only(right: 8.0),
                            padding: const EdgeInsets.all(0.0),
                            child: new Stack(children: _buildAvatar())),
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
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87)),
                              new Text(driver.phone,
                                  style: new TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15.0))
                            ])),
                        new Container(
                            padding: new EdgeInsets.all(8.0),
                            child: new Column(children: <Widget>[
                              new Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: new Text(driver.distance,
                                    overflow: TextOverflow.ellipsis,
                                    style: new TextStyle(
                                        color: Colors.black54, fontSize: 13.0)),
                              ),
                              new Text(driver.note,
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.black87,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w200))
                            ]))
                      ]),
                ))));
  }

  List<Widget> _buildAvatar() {
    List<Widget> children = [
      new Container(
          width: 57.0,
          height: 57.0,
          decoration:
              new BoxDecoration(shape: BoxShape.circle, color: primaryColor),
          child: new ClipRect(
              child: new InkWell(
                  child: new Center(
                      child: new Icon(!isSelected ? Icons.person : null,
                          color: isSelected ? Colors.black54 : Colors.white)))))
    ];

    if (isSelected) {
      children.add(new Center(
          child: new IconButton(
              alignment: Alignment.centerRight,
              onPressed: () {},
              icon: new Icon(Icons.check, size: 20.0, color: Colors.white))));
    }

    return children;
  }
}

class NoteDialog extends StatefulWidget {
  final Person driver;
  final String str;
  final List<Person> contacts;
  final int i;
  final String initialValue;
  final List<int> contactOptionsPinned;

  NoteDialog(
      {this.str,
      this.contacts,
      this.i,
      this.initialValue,
      this.contactOptionsPinned,
      this.driver});
  @override
  _NoteDialogState createState() => new _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  String initialValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
        titlePadding: new EdgeInsets.all(0.0),
        contentPadding: new EdgeInsets.only(
            top: 12.0, bottom: 16.0, left: 10.0, right: 10.0),
        title: new Container(
            padding: new EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            color: secondaryColor,
            child: new Text("${widget.str}",
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w800))),
        children: <Widget>[
          new Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: new Text("Choisissez la note")),
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
                                      initialValue = value.toString();
                                    });
                                  },
                                  child: new CircleAvatar(
                                      backgroundColor:
                                          int.parse(initialValue) == value
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
                                  initialValue = value.toString();
                                });
                              },
                              child: new CircleAvatar(
                                  backgroundColor:
                                      int.parse(initialValue) == value
                                          ? primaryColor
                                          : Colors.grey.shade300,
                                  child: new Text('$value')),
                            ),
                          );
                        }).toList())
                  ])),
          new ButtonTheme.bar(
              child: new ButtonBar(children: <Widget>[
            new FlatButton(
                child: new Text("Valider"),
                onPressed: () {
                  List<int> tabs = [];
                  if (widget.driver == null) {
                    tabs = widget.i != null
                        ? [widget.i]
                        : widget.contactOptionsPinned;
                    tabs.forEach((int value) {
                      Person contact = widget.contacts[value];
                      Services.instance.sendNote(contact.phone, initialValue);
                      contact.note = initialValue;
                    });
                  } else {
                    Services.instance
                        .sendNote(widget.driver.phone, initialValue);
                    widget.driver.note = initialValue;
                  }
                  Navigator.of(context).pop();
                })
          ]))
        ]);
  }
}

enum WhyFarther { Note, Command }
enum ActionsMenu { covoiturage, MyCommands, Settings }
