import 'dart:async';

import 'package:flutter/material.dart';
import 'package:voom_app/co-voiturage.dart';
import 'package:voom_app/login.dart';
import 'package:voom_app/no-location.dart';
import 'package:voom_app/personClass.dart';
import 'package:voom_app/services.dart';
import 'package:voom_app/theme.dart';
import 'package:voom_app/type.dart';
import 'mainList.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'VoomApp',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.red,
        ),
        routes: {
          '/liste': (BuildContext ctx) {
            return new MainListe();
          },
          '/login': (BuildContext ctx) {
            return new Login();
          },
          '/no-location': (BuildContext ctx) {
            return new NoLocation();
          },
          '/co-voiturage': (BuildContext ctx) {
            return new CoVoiturage();
          },
          '/types': (BuildContext ctx) {
            return new TypePage();
          }
        },
        home: new FutureBuilder(
            future: _getHomePage(),
            builder: (_, AsyncSnapshot<Widget> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return snapshot.hasError ? _circular() : snapshot.data;
                  break;
                case ConnectionState.waiting:
                  return _circular();
                  break;
                case ConnectionState.active:
                  return _circular();
                  break;
                case ConnectionState.none:
                  return _circular();
                  break;
                default:
                  return _circular();
              }
            },
            initialData: _circular()));
  }

  Scaffold _circular() {
    return new Scaffold(
        body: new Center(child: new CircularProgressIndicator()));
  }

  Future<Widget> _getHomePage() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String phoneNumber = preferences.getString(AppPreferences.phoneNumber);
      String password = preferences.getString(AppPreferences.password);
      Services.instance.jid = phoneNumber;
      Services.instance.pass = password;
      return (phoneNumber == null || password == null)
          ? new Home()
          : new MainListe();
    } catch (e) {
      return new Text(e.toString());
    }
  }
}

class Home extends StatefulWidget {
  @override
  createState() => new HomeState();
}

class HomeState extends State<Home> {
  TextStyle textStyle = const TextStyle(
      fontSize: 30.0, color: Colors.white, decoration: TextDecoration.none);

  Widget build(BuildContext context) {
    return new Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  primaryColor,
                  secondaryColor,
                  secondaryColor.withOpacity(0.5)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.5, 1.0])),
        child: new Center(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              new Image.asset('images/voiture.jpg', fit: BoxFit.contain),
              new Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: new Text("Voooom", style: textStyle))
            ])));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new Timer(new Duration(seconds: 5), () {
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (BuildContext context) {
        return new Login();
      }), ModalRoute.withName('/login'));
    });
  }
}
