import 'package:flutter/material.dart';
import 'package:voom_app/personClass.dart';

class ChatMessage extends StatelessWidget {
  String _jid;
  final AppMessage message;
  ChatMessage(this.message) {
    //this._jid = XmppProvider.instance().jid;
  }
  @override
  Widget build(BuildContext context) {
    double d = MediaQuery.of(context).size.width;
    return new Container(child: _buildContent(d));
  }

  Widget _buildContent(double d) {
    Widget icon;
    bool me = _jid == message.from;
    Color color = Colors.black;
    if (message.status == SentStatus.NO_DELIVERED) {
      icon = new Container(
          margin: new EdgeInsets.only(left: 2.0),
          width: 8.0,
          height: 8.0,
          decoration: new BoxDecoration(
              border: new Border.all(color: color),
              borderRadius: new BorderRadius.circular(2.5)));
    } else if (message.status == SentStatus.RECEIVED)
      icon = new Icon(Icons.done, color: color, size: 15.0);
    else if (message.status == SentStatus.SENT)
      icon = new Icon(Icons.done_all, color: color, size: 15.0);
    else if (message.status == SentStatus.SEEN) {
      color = Colors.greenAccent;
      icon = new Icon(Icons.done_all, color: color, size: 15.0);
    } else {
      icon = new Icon(Icons.crop_square, color: color, size: 15.0);
    }
    if (!me) icon = new Container();
    //String time = StoreProvider.instance.getTime(message.date);
    String time = '10:00';

    return _buildTextMessage(icon, time, me, d);
  }

  Widget _buildTextMessage(Widget icon, String time, bool me, double d) {
    return this._buildBaseContainer(
        new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //new Text("Nom du participant"),
            new Container(
                margin: const EdgeInsets.only(top: 0.0),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Text(message.content),
                    new Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Text(time,
                              style: new TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 10.0,
                                  color: Color(0xFF151518))),
                          icon
                        ])
                  ],
                )),
          ],
        ),
        me,
        d);
  }

  Widget _buildBaseContainer(Widget child, bool me, double d) {
    AlignmentGeometry alignment;
    EdgeInsetsGeometry padding;
    if (me) {
      alignment = Alignment.centerRight;
      padding = new EdgeInsets.fromLTRB(8.5, 5.0, 8.5, 5.0);
    } else {
      alignment = Alignment.centerLeft;
      padding = new EdgeInsets.fromLTRB(8.5, 5.0, 8.5, 5.0);
    }
    BorderRadius _borderRadius;
    if (me) {
      _borderRadius = new BorderRadius.only(
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
          topRight: Radius.circular(0.0),
          bottomRight: Radius.circular(15.0));
    } else {
      _borderRadius = new BorderRadius.only(
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(0.0),
          topRight: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0));
    }
    Color _decorationColor =
        me ? Colors.lightBlue.shade100 : Colors.grey.shade400;
    return new Container(
      alignment: alignment,
      margin:
          new EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0, bottom: 0.0),
      child: new Container(
          decoration: new BoxDecoration(
              color: _decorationColor, borderRadius: _borderRadius),
          constraints: new BoxConstraints(
              minWidth: 40.0, maxWidth: d * 0.8, minHeight: 34.0),
          padding: padding,
          child: child),
    );
  }
}
