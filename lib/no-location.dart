import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:voom_app/mainList.dart';

class NoLocation extends StatefulWidget {
  @override
  _NoLocationState createState() {
    return new _NoLocationState();
  }
}

class _NoLocationState extends State<NoLocation> {
  bool _isActive = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
            color: Colors.grey.shade300,
            child: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  new Text("Géolocalisation désactivée",
                      style: new TextStyle(
                          color: Colors.black,
                          fontSize: 19.0,
                          fontWeight: FontWeight.w400)),
                  new Switch(
                      onChanged: (bool value) {
                        setState(() {
                          _isActive = value;
                          if (_isActive) {
                            checkPermissions();
                          }
                        });
                      },
                      value: _isActive)
                ]))));
  }

  checkPermissions() async {
    bool check =
        await SimplePermissions.checkPermission(Permission.AccessFineLocation);
    if (!check) {
      bool request = await SimplePermissions
          .requestPermission(Permission.AccessFineLocation);
      if (request) {
        this._navigateToList();
      } else {
        setState(() {
          _isActive = false;
        });
      }
    } else {
      this._navigateToList();
    }
  }

  _navigateToList() {
    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (BuildContext context) {
      return new MainListe();
    }), ModalRoute.withName('/liste'));
  }
}
