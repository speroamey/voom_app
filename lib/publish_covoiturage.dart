import 'package:flutter/material.dart';
import 'package:voom_app/services.dart';

class PublishCoVoiturage extends StatefulWidget {
  @override
  _PublishCoVoiturageState createState() => new _PublishCoVoiturageState();
}

class _PublishCoVoiturageState extends State<PublishCoVoiturage> {
  List<TypeEngin> _engins = [
    new TypeEngin("Voiture", 'images/voiture.jpg'),
    new TypeEngin("Moto", 'images/voiture.jpg')
  ];
  TypeEngin _selectedEngin;
  TextEditingController _fromCtrl, _toCtrl, _hourCtrl;

  GlobalKey<ScaffoldState> _scafold = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _fromCtrl = new TextEditingController(text: '');
    _toCtrl = new TextEditingController(text: '');
    _hourCtrl = new TextEditingController(text: '');
    _selectedEngin = this._engins[0];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scafold,
        appBar: new AppBar(title: new Text("Publier un trajet")),
        body: new Container(
            padding: new EdgeInsets.all(8.0),
            child: new SingleChildScrollView(
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new TextField(
                          controller: _fromCtrl,
                          decoration: new InputDecoration(
                              icon: new Icon(Icons.atm), hintText: "From"))),
                  new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new TextField(
                          controller: _toCtrl,
                          decoration: new InputDecoration(
                              icon: new Icon(Icons.assistant),
                              hintText: "to"))),
                  new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new TextField(
                          controller: _hourCtrl,
                          decoration: new InputDecoration(
                              icon: new Icon(Icons.av_timer),
                              hintText: "Hour departure"))),
                  new Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: new Text("Vous voyagez avec quels engins",
                          style: new TextStyle(fontWeight: FontWeight.w500))),
                  new Center(
                    child: new SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: _engins.map((TypeEngin value) {
                              return new GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedEngin = value;
                                  });
                                },
                                child: new Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Container(
                                          width: 90.0,
                                          height: 90.0,
                                          padding: new EdgeInsets.all(15.0),
                                          margin: new EdgeInsets.all(8.0),
                                          decoration: new BoxDecoration(
                                              color: _selectedEngin == value
                                                  ? Colors.grey.shade300
                                                  : Colors.transparent,
                                              border: new Border.all(
                                                  color: Colors.black38),
                                              shape: BoxShape.circle),
                                          child: new ClipOval(
                                              child: new Image.asset(
                                                  value.imageUrl,
                                                  fit: BoxFit.contain))),
                                      new Text(value.name,
                                          style: new TextStyle(
                                              fontWeight:
                                                  _selectedEngin != value
                                                      ? FontWeight.normal
                                                      : FontWeight.bold))
                                    ]),
                              );
                            }).toList())),
                  )
                ]))),
        bottomNavigationBar: new ButtonTheme.bar(
            child: new ButtonBar(children: <Widget>[
          new FlatButton(
              child: new Text("Publish"),
              onPressed: _isValid
                  ? () {
                      if (!_isValid) {
                        _scafold.currentState.showSnackBar(new SnackBar(
                            content: new Text(
                                "Veuillez renseigner tous les champs")));
                      } else {
                        //Services.instance.sendPresence();
                      }
                    }
                  : null)
        ])));
  }

  bool get _isValid {
    return _fromCtrl.text.isNotEmpty &&
        _toCtrl.text.isNotEmpty &&
        _hourCtrl.text.isNotEmpty;
  }
}

class TypeEngin {
  String name;
  String imageUrl;
  TypeEngin(this.name, this.imageUrl);
}
