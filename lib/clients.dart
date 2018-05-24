import 'package:flutter/material.dart';
import 'package:voom_app/services.dart';

class ClientPage extends StatefulWidget {
  @override
  _ClientPageState createState() => new _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - (kToolbarHeight);
    return new Scaffold(
        body: new SingleChildScrollView(
            child: new Container(
                height: height,
                decoration: new BoxDecoration(color: Colors.grey.shade200),
                child: new Center(
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      new Text("4 clients à proximité",
                          style: Theme.of(context).textTheme.display1.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 20.0)),
                      new Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: new Text(
                            "Rendez-vous disponible pour qu'ils puissent vous commander",
                            softWrap: true,
                            maxLines: 5,
                            textAlign: TextAlign.center,
                            style: Theme
                                .of(context)
                                .textTheme
                                .display2
                                .copyWith(fontSize: 15.0)),
                      ),
                      new Container(
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(3.0),
                              border: new Border.all()),
                          margin: const EdgeInsets.only(top: 40.0, bottom: 5.0),
                          child: new FlatButton(
                              padding: const EdgeInsets.all(10.0),
                              child: new Text("Se rendre dispo"),
                              onPressed: () {
                                Services.instance.sendPresence();
                              }))
                    ])))));
  }
}
