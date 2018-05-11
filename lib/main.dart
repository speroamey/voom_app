import 'dart:async';

import 'package:flutter/material.dart';
import 'login.dart';
import 'mainList.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: ' VoomApp',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home:new Container(
        decoration: new BoxDecoration(color: Colors.red),
        child: new Center(
          child: new Home(),
        ),
      )
    );
  }
}

class Home extends StatefulWidget{
  /* Home({Key key, this.title}) : super(key: key); */
  @override
  createState() => new HomeState();

}

class HomeState extends State<Home> {
    TextStyle textStyle = const TextStyle(
    fontSize: 30.0,
    color: Colors.white,
    decoration: TextDecoration.none
  );
     final username=null;
     final password=null;

     Widget build(BuildContext context){
      /*  return new Text("data"); */

      return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
/*         crossAxisAlignment: CrossAxisAlignment.center,*/
         children: [
            new Image.asset(
              'images/voiture.jpg',
              fit: BoxFit.contain,
            ),
            new Text("Vooooom",style: textStyle)
          ],
      );
      
     }
     @override
     void initState() {
         // TODO: implement initState
         super.initState();
         new Timer(new Duration(seconds: 5),(){
           Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
             builder: (BuildContext context){
               return new MainListe();
             }
           ),(route){ return true;});
         });
       }
}

