import 'package:flutter/material.dart';
import 'package:voom_app/personClass.dart';

class DetailsPage extends StatefulWidget {
  final Person driver;

  DetailsPage(this.driver);
  @override
  _DetailsPageState createState() => new _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    //double width = MediaQuery.of(context).size.width;
    return new Scaffold(
        //appBar: new AppBar(title: new Text("A propos du conducteur")),
        body: new Column(children: <Widget>[
      new Card(
        margin: const EdgeInsets.all(0.0),
        shape: new RoundedRectangleBorder(),
        elevation: 4.0,
        child: new Container(
            width: double.infinity,
            height: height * 0.7,
            child: new Stack(children: <Widget>[
              new Column(children: <Widget>[
                new Expanded( 
                    child: new Container(
                        decoration: new BoxDecoration(
                            image: new DecorationImage(
                                image: new AssetImage("images/background.jpeg"),
                                fit: BoxFit.cover)))),
                new Expanded(
                    child: new Container(
                        color: Colors.black.withOpacity(0.9),
                        child: new Center(
                            child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                              new Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: new Center(
                                      child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                        new Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: new Text(
                                              widget.driver.name ?? '',
                                              style: new TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 20.0)),
                                        ),
                                        new Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: new Icon(Icons.verified_user,
                                                color: Colors.redAccent,
                                                size: 15.0))
                                      ]))),
                              new Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Text(widget.driver.phone ?? '',
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 17.0)),
                              ),
                              new Container(
                                  margin:
                                      new EdgeInsets.symmetric(vertical: 8.0),
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          new BorderRadius.circular(3.0),
                                      border: new Border.all()),
                                  child: new FlatButton(
                                      padding: new EdgeInsets.all(15.0),
                                      child: new Text("Commander",
                                          style: new TextStyle(
                                              color: Colors.black)),
                                      onPressed: () {}))
                            ]))))
              ]),
              new Positioned(
                  left: 0.0,
                  right: 0.0,
                  top: MediaQuery.of(context).padding.top,
                  height: kToolbarHeight,
                  child: new Row(children: <Widget>[
                    new BackButton(color: Colors.white),
                    new Expanded(child: new Container()),
                    new Material(
                        shape: new CircleBorder(),
                        color: Colors.transparent,
                        child: new InkWell(
                            onTap: () {},
                            child: new IconButton(
                                icon: new Icon(Icons.more_vert,
                                    color: Colors.white),
                                onPressed: () {})))
                  ])),
              new Center(
                  child: new Container(
                      padding: new EdgeInsets.all(1.0),
                      decoration: new BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                          border: new Border.all(color: Colors.grey)),
                      child: new ClipOval(
                          child: new Image.asset("images/voiture.jpg",
                              fit: BoxFit.contain, width: 90.0, height: 90.0))))
            ])),
      ),
      new Expanded(
          child: new Container(
              child: new ListView(children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: new Text("Autres details",
              style:
                  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
        ),
        new ListTile(
            title: new Text("N. matricule"),
            subtitle: new Text("21-31REQFQDSF23RD")),
        new Container(height: 1.0, color: Theme.of(context).dividerColor),
        new ListTile(
            title: new Text("1.5 km de chez moi"), subtitle: new Text("12/100"))
      ])))
    ]));
  }
}
