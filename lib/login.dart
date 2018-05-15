import 'package:flutter/material.dart';
import 'package:voom_app/mainList.dart';
import 'package:voom_app/services.dart';
import 'package:voom_app/src/core.dart';

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
  @override
  void initState() {
    // TODO: implement initState
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
        radius: 48.0,
        child: Image.asset("images/voiture.jpg"),
      ),
    );

    final phoneNumber = new TextFormField(
      controller: phoneCtrl,
      keyboardType: TextInputType.phone,
      autofocus: false,
      onFieldSubmitted: (String value) {
        _onLogin();
      },
      decoration: InputDecoration(
        hintText: "Numéro de téléphone",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = new Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: new Material(
            borderRadius: BorderRadius.circular(30.0),
            shadowColor: phoneCtrl.text.trim().isEmpty
                ? Colors.transparent
                : Colors.redAccent.shade100,
            elevation: 5.0,
            child: new FlatButton(
                textColor: Colors.white,
                disabledColor: Colors.grey.shade300,
                disabledTextColor: Colors.black26,
                onPressed: phoneCtrl.text.trim().isEmpty ? null : _onLogin,
                color: Colors.redAccent,
                child: new Text("Validez"))));

    return new Scaffold(
        backgroundColor: Colors.white,
        body: new Center(
            child: new ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
              logo,
              SizedBox(height: 48.0),
              phoneNumber,
              SizedBox(height: 8.0),
              loginButton
            ])));
  }

  _onLogin() {
    /* if (true == true) {
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (BuildContext context) {
        return new MainListe();
      }), ModalRoute.withName('/liste'));
      return;
    } */
    Services instance = Services.instance();
    instance.login(phoneCtrl.text, "jesuis123", (int status, condition, elem) {
      if (status == Strophe.Status['CONNECTED']) {
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (BuildContext context) {
          return new MainListe();
        }), ModalRoute.withName('/liste'));
      } else if (status == Strophe.Status['CONNFAIL']) {
        /* Navigator.of(context, rootNavigator: true).pop();
        Scaffold.of(context).showSnackBar(new SnackBar(
            content:
                new Text(""))); */
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
                      overflow: TextOverflow.ellipsis),
                ))
              ],
            )
          ]);
        });
  }
}
