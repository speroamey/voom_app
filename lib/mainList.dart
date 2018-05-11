import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voom_app/personClass.dart';
import 'package:voom_app/services.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';



class MainListe extends StatefulWidget {
  @override
  _MainListeState createState() => new _MainListeState();
} 




class _MainListeState extends State<MainListe> {
   static const platform = const MethodChannel('samples.flutter.io/battery');
  static const String cle="AIzaSyCaMHp0T6sTfyZRznY7AGcJXhuZtAZ2VRg";
  TextStyle inputStyle = const TextStyle(
    fontSize: 15.0,
    color: Colors.white,
  );
  List<bool> _data = new List<bool>();
   static const geoKey="AIzaSyD3t95XyJYnfRbP4mQHNIqJPxj5V9jkJ6w";
   final chauf= new Person();
   

  final List<Map> Drivers= [
        {"name":"Toto","age":"51","msg":"mmy mesg from"},
        {"name":"Tato","age":"51","msg":"mmy mesg from"},
        {"name":"Noto","age":"51","msg":"mmy mesg from"},
        {"name":"Voto","age":"51","msg":"mmy mesg from"},
        {"name":"Poto","age":"51","msg":"mmy mesg from"},
        {"name":"Mmy","age":"51","msg":"mmy mesg from"},
        {"name":"Noto","age":"51","msg":"mmy mesg from"},
        {"name":"Eoto","age":"51","msg":"mmy mesg from"},
        {"name":"Loto","age":"51","msg":"mmy mesg from"},
        {"name":"HIto","age":"51","msg":"mmy mesg from"},
        {"name":"Sato","age":"51","msg":"mmy mesg from"},
        {"name":"Binto","age":"51","msg":"mmy mesg from"},
        {"name":"Nori","age":"51","msg":"mmy mesg from"},
        {"name":"Pasta","age":"51","msg":"mmy mesg from"},
        {"name":"Coll","age":"51","msg":"mmy mesg from"},
        {"name":"Vommy mesg from","age":"51","msg":"mmy mesg from"},
        {"name":"Fast","age":"51","msg":"mmy mesg from"},
        {"name":"Slow","age":"51","msg":"mmy mesg from"},
        {"name":"kask","age":"51","msg":"mmy mesg from"},
        {"name":"Wak","age":"51","msg":"mmy mesg from"},
        {"name":"Lest","age":"51","msg":"mmy mesg from"},
        {"name":"First","age":"51","msg":"mmy mesg from"},
        {"name":"Mmy ","age":"51","msg":"mmy mesg from"},
        {"name":"Xavier","age":"51","msg":"mmy mesg from"},
  ];
  
   var driver = new Map();

   Future <String> getMyPosition()async {

    final int result = await platform.invokeMethod('getBatteryLevel');
    http.Response resposition= await http.post(
        Uri.encodeFull("https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyD3t95XyJYnfRbP4mQHNIqJPxj5V9jkJ6w"),
        
       );
        List resp=new List();
       resp.add(json.decode(resposition.body));
       print(resposition.body);
  }


   @override
    void initState() {
       
      /* getMyPosition(); */
       var currentLocation = <String, double>{};
       var location = new Location();

        location.onLocationChanged.listen((Map<String,double> currentLocation) {
          print(currentLocation["latitude"]);
          print(currentLocation["longitude"]);
          /* print(currentLocation["accuracy"]);
          print(currentLocation["altitude"]); */
        });
      

      setState(() {
         /*  getMyPosition(); */
        /* var myDriver=driver.toString(); */
            for (int i = 0; i < 10; i++) {
              _data.add(false);
            }
      });

       
    }
 
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:  new AppBar(
        automaticallyImplyLeading: false,
        title: new Text('VoomApp'),
      ),
       body: new Container(
          padding: new EdgeInsets.all(5.0),
          child: new ListView.builder(
            itemBuilder: (BuildContext context, int index){
              return new DriversList(this.Drivers[index]);
            },
            itemCount: this.Drivers.length,
          ),
        )
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       /*  new Container(
        
         child: new ListView.builder(
          
           itemCount: _data.length,
            itemBuilder: (BuildContext context,int index){
              return Card(
                child: new Container(
                  padding: new EdgeInsets.all(5.0),
                  child: new Column(
                    children: <Widget>[
                      new Text("this is item $index"),
                      new CheckboxListTile(
                        value: _data[index],
                        controlAffinity: ListTileControlAffinity.leading,
                        title: new Text("Click me item $index"),
                        onChanged:null ,
                      )
                    ],
                  ),
                ),
              );
            },
         )
       ) */
    );
  }
}




class DriversList extends StatelessWidget {
  final driver;
 /*  static const JsonCodec json = const JsonCodec(); */
  DriversList(this.driver);
 

 

  Future <String> getData() async {
        http.Response response= await http.get(
        Uri.encodeFull("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=Washington,DC&destinations=New+York+City,NY"),
        headers:{
          "key":"AIzaSyCaMHp0T6sTfyZRznY7AGcJXhuZtAZ2VRg",
          "Accept":"application/json"
        }
       );
       List data=new List();
       data.add(json.decode(response.body));
       print(data);
     }

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new ListTile(
                leading: new CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  child:new Icon(Icons.person),
                ),
                title:  new Text(driver['name'], style: TextStyle(fontSize: 18.0),),
                subtitle: new Text(driver["msg"]),
                onTap: getData,
              )
    );
  }
}