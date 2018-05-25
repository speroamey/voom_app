import 'package:flutter/material.dart';
import 'package:voom_app/personClass.dart';
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
  TextEditingController _fromCtrl, _toCtrl, _hourCtrl, _priceCtrl;
  CoPublish coPublish = new CoPublish();
  GlobalKey<ScaffoldState> _scafold = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fromCtrl = new TextEditingController(text: '');
    _toCtrl = new TextEditingController(text: '');
    _hourCtrl = new TextEditingController(text: '');
    _priceCtrl = new TextEditingController(text: '');
    coPublish.engin = this._engins[0].toString();
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
                              icon: new Icon(Icons.atm),
                              hintText: "D’où partez-vous ?"))),
                  new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new TextField(
                          controller: _toCtrl,
                          decoration: new InputDecoration(
                              icon: new Icon(Icons.assistant),
                              hintText: "Où allez-vous ?"))),
                  new Row(children: <Widget>[
                    //new Icon(Icons.av_timer)
                    new Expanded(child: new Text("Date de départ")),
                    new FlatButton(
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  firstDate: new DateTime.now(),
                                  initialDate: new DateTime.now(),
                                  lastDate: new DateTime.now()
                                      .add(new Duration(days: 30)))
                              .then((DateTime date) {
                            if (date != null) {
                              coPublish.date = date.millisecondsSinceEpoch;
                              setState(() {});
                            }
                          });
                        },
                        child: new Text(
                            Services.instance.getTime(coPublish.date))),
                    new FlatButton(
                        onPressed: () {
                          showTimePicker(
                                  context: context,
                                  initialTime: new TimeOfDay.now())
                              .then((TimeOfDay time) {
                            if (time != null) {
                              coPublish.time = "${time.hour}h:${time.minute}";
                              setState(() {});
                            }
                          });
                        },
                        child: new Text(coPublish.time))
                  ]),
                  new Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 12.0),
                      child: new TextField(
                          controller: _priceCtrl,
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                              icon: new Icon(Icons.monetization_on),
                              hintText: "Prix par passager"))),
                  new ListTile(
                      title: new Text("Nombre de places proposé",
                          style: new TextStyle(fontWeight: FontWeight.w500)),
                      trailing: new DropdownButtonHideUnderline(
                          child: new Container(
                              decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(2.0),
                                  border: new Border.all(
                                      color: const Color(0xFFD9D9D9))),
                              child: new DropdownButton<int>(
                                  items: <int>[1, 2, 3, 4, 5].map((int value) {
                                    return new DropdownMenuItem<int>(
                                        value: value,
                                        child: new Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: new Text(
                                                "$value place${value>1?'s':''}")));
                                  }).toList(),
                                  value: coPublish.places,
                                  onChanged: (int value) {
                                    setState(() {
                                      coPublish.places = value;
                                    });
                                  })))),
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
                                    coPublish.engin = value.toString();
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
                                              color: coPublish.engin ==
                                                      value.toString()
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
                                              fontWeight: coPublish.engin !=
                                                      value.toString()
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
                        this.coPublish.depart = _fromCtrl.text;
                        this.coPublish.destination = _toCtrl.text;
                        this.coPublish.price = int.parse(_priceCtrl.text);
                        Services.instance.addCoVoiturage(this.coPublish);
                        Services.instance.sendPresence();
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
