import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voom_app/personClass.dart';
import 'package:voom_app/services.dart';
import 'package:voom_app/src/core.dart';
import 'package:voom_app/type.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneCtrl = new TextEditingController();
  TextStyle inputStyle = const TextStyle(
    fontSize: 15.0,
    color: Colors.white,
  );

  GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    phoneCtrl.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final logo = new Hero(
        tag: "log",
        child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 50.0,
            child: new Container(
                width: 90.0,
                height: 90.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new AssetImage("images/voiture.jpg"))))));

    final phoneNumber = new Theme(
        data: new ThemeData(
            primaryColor: Colors.white30, hintColor: Colors.white30),
        child: new TextFormField(
            controller: phoneCtrl,
            style: new TextStyle(color: Colors.white),
            keyboardType: TextInputType.phone,
            autofocus: true,
            onFieldSubmitted: (String value) {
              signUp();
            },
            decoration: InputDecoration(
                hintText: "Numéro de téléphone",
                contentPadding: EdgeInsets.fromLTRB(20.0, 11.0, 20.0, 11.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)))));

    final loginButton = new Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: new Material(
            borderRadius: BorderRadius.circular(30.0),
            shadowColor: phoneCtrl.text.trim().isEmpty
                ? Colors.transparent
                : Colors.redAccent.shade700,
            elevation: 12.0,
            child: new FlatButton(
                textColor: Colors.white,
                disabledColor: Colors.white,
                disabledTextColor: Colors.black38,
                onPressed: phoneCtrl.text.trim().isEmpty ? null : signUp,
                color: Colors.red[600],
                child: new Text("Validez"))));

    return new Scaffold(
        key: _scaffold,
        body: new Container(
            color: Colors.red,
            child: new Center(
                child: new ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    children: <Widget>[
                  logo,
                  SizedBox(height: 48.0),
                  phoneNumber,
                  SizedBox(height: 8.0),
                  loginButton
                ]))));
  }

  _onLogin() async {
    if (phoneCtrl.text.isEmpty) return;
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    Services instance = Services.instance;
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    instance.login(phoneCtrl.text, (int status, condition, elem) {
      if (status == Strophe.Status['CONNECTED']) {
        sharedPrefs.setString(AppPreferences.phoneNumber, phoneCtrl.text);
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (BuildContext context) {
          return new TypePage();
        }), ModalRoute.withName('/types'));
      } else if (status == Strophe.Status['AUTHFAIL'] ||
          status == Strophe.Status['CONNFAIL'] ||
          status == Strophe.Status['CONNTIMEOUT'] ||
          status == Strophe.Status['DISCONNECTING']) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      } else if (status == -1) {
        _scaffold.currentState.showSnackBar(new SnackBar(
            content: new Text("Le serveur est inaccessible,dev mode")));
      }
    });
  }

  signUp() async {
    if (phoneCtrl.text.isEmpty) return;
    /* if (true == true) {
      Services.instance.jid = phoneCtrl.text + '@localhost';
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (BuildContext context) {
        return new TypePage();
      }), ModalRoute.withName('/types'));
      return;
    } */
    Services instance = Services.instance;
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    instance.register(phoneCtrl.text, (int status, condition, elem) {
      print('$status');
      if (status == Strophe.Status['CONNECTED']) {
        sharedPrefs.setString(AppPreferences.phoneNumber, phoneCtrl.text);
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (BuildContext context) {
          return new TypePage();
        }), ModalRoute.withName('/types'));
      } else if (status == Strophe.Status['AUTHFAIL'] ||
          status == Strophe.Status['CONNFAIL'] ||
          status == Strophe.Status['CONNTIMEOUT'] ||
          status == Strophe.Status['DISCONNECTING'] ||
          status == Strophe.Status['REGIFAIL'] ||
          status == Strophe.Status['NOTACCEPTABLE']) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          _scaffold.currentState.showSnackBar(new SnackBar(
              content: new Text("une erreur inattendue lors de la connexion")));
        }
      } else if (status == Strophe.Status['CONFLICT']) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          _onLogin();
          /*  _scaffold.currentState.showSnackBar(
              new SnackBar(content: new Text("Le contact existe deja"))); */
        }
      } else if (status == -1) {
        _scaffold.currentState.showSnackBar(new SnackBar(
            content: new Text("Le serveur est inaccessible,dev mode")));
      }
    });
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return new SimpleDialog(children: <Widget>[
            new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: const CircularProgressIndicator()),
                  new Expanded(
                      child: new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Text("Connexion en cours",
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w300))))
                ])
          ]);
        });
  }
}
