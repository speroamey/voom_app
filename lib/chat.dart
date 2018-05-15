import 'package:flutter/material.dart';
import 'package:voom_app/chat-message.dart';
import 'package:voom_app/personClass.dart';
import 'package:voom_app/searchbar.dart';
import 'package:voom_app/services.dart';
import 'package:voom_app/theme.dart';

class ChatPage extends StatefulWidget {
  final Person person;

  ChatPage(this.person);
  @override
  _ChatPageState createState() => new _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey<ScaffoldState>();
  int _maxLines = 1;
  String _message = '';
  String _blockquoteId = '';
  String _replaceId;
  TextEditingController _messageController = new TextEditingController();

  String _search = '';
  Person _contact;
  bool _isSearch = false;

  List<int> _contactOptionsPinned = [];
  List<AppMessage> messages = [
    new AppMessage.fromMap({'name': "Name", 'content': 'contenu'}),
    new AppMessage.fromMap({'name': "Name", 'content': 'contenu2'}),
  ];
  bool _contactsOptions = false;
  ScrollController _msgScrollCtrl = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffold,
      appBar: _buildAppBar(),
      body: new Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(colors: [
          Colors.grey.shade200,
          Colors.grey.shade400,
          Colors.grey.shade600
        ])),
        child: new Column(children: _buildChatPage()),
      ),
    );
  }

  AppBar _buildAppBar() {
    AppBar appBar;
    if (_contactsOptions) {
      appBar = new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                _contactsOptions = false;
                _contactOptionsPinned = [];
              });
            }),
        title: new Text(_contactOptionsPinned.length.toString()),
        actions: _appBarOptionsActions(),
      );
    } else if (_isSearch) {
      appBar = new AppBar(
          backgroundColor: Colors.white,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: thirdColor),
              onPressed: () {
                setState(() {
                  _isSearch = false;
                  _search = '';
                });
              }),
          title: new SearchBar(_search, _onSearch, "Rechercher un message ..."),
          elevation: 12.0,
          actions: <Widget>[
            new IconButton(
              padding: new EdgeInsets.all(0.0),
              tooltip: "Effacer la recherche",
              iconSize: 20.0,
              icon: new Icon(Icons.close,
                  color: _search.isEmpty ? Colors.transparent : Colors.black),
              onPressed: () {
                setState(() {
                  _search = '';
                });
              },
            )
          ]);
    } else {
      appBar = new AppBar(
          automaticallyImplyLeading: false,
          title: new GestureDetector(
            onTap: () {
              Navigator
                  .of(context)
                  .push(new MaterialPageRoute(builder: (BuildContext context) {
                //return new Profil();
              }));
            },
            child: new Row(
              children: <Widget>[
                new Container(
                    margin: new EdgeInsets.all(0.0), child: new BackButton()),
                new Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: new CircleAvatar(
                    backgroundColor: Colors.white,
                    child: new Text(
                        widget.person.name != null &&
                                widget.person.name.length > 0
                            ? widget.person.name[0].toUpperCase()
                            : '',
                        style: new TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                new Flexible(
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _titleHead())),
              ],
            ),
          ),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    this._isSearch = true;
                  });
                }),
            new PopupMenuButton(
                padding: new EdgeInsets.all(0.0),
                onSelected: (InboxActions action) {
                  if (action == InboxActions.NOTER) {} else if (action ==
                      InboxActions.BLOCK) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return new AlertDialog(
                              title: new Text("Bloquer le contact"),
                              content: new Container(
                                child: new Text(
                                    "Voulez-vous bloquer le contact ${widget.person.name}"),
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                    child: new Text("Annuler"),
                                    onPressed: () {
                                      Navigator
                                          .of(context, rootNavigator: true)
                                          .pop();
                                    }),
                                new FlatButton(
                                    child: new Text("Bloquer"),
                                    onPressed: () {})
                              ]);
                        });
                  } else if (action == InboxActions.DELETE_CHAT) {}
                },
                itemBuilder: (_) => _popMenu())
          ]);
    }
    return appBar;
  }

  List<PopupMenuEntry<InboxActions>> _popMenu() {
    List<PopupMenuEntry<InboxActions>> menus = [];
    menus.add(
        new PopupMenuItem(value: InboxActions.NOTER, child: new Text('Noter')));
    menus.add(new PopupMenuItem(
        value: InboxActions.DELETE_CHAT,
        child: new Text('Effacer la discussion')));
    return menus;
  }

  List<Widget> _titleHead() {
    List<Widget> children = [
      new Flexible(
          child: new Text(widget.person?.name ?? widget.person?.phone ?? '',
              style: new TextStyle(fontSize: 20.0),
              overflow: TextOverflow.ellipsis))
    ];
    bool isWriting = _contact?.writing ?? widget.person?.writing ?? false;
    String writingText = "Est en train d'ecrire ...";
    if (isWriting) {
      children.add(new Flexible(
          child: new Text(writingText,
              overflow: TextOverflow.ellipsis,
              style: new TextStyle(
                  color: Colors.green[900],
                  fontSize: 10.0,
                  fontStyle: FontStyle.italic))));
    }
    return children;
  }

  List<Widget> _appBarOptionsActions() {
    List<Widget> actions = [];
    if (_contactOptionsPinned.length == 1) {
      actions
          .add(new IconButton(icon: new Icon(Icons.reply), onPressed: () {}));
    }
    actions.add(
        new IconButton(icon: new Icon(Icons.content_copy), onPressed: () {}));
    actions
        .add(new IconButton(icon: new Icon(Icons.forward), onPressed: () {}));
    actions.add(new IconButton(
        icon: new Icon(Icons.delete),
        onPressed: () {
          _contactOptionsPinned.forEach((int index) {});
        }));

    return actions;
  }

  _onSearch(String search) {
    setState(() {
      _search = search;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _msgScrollCtrl.dispose();
    super.dispose();
  }

  List<Widget> _buildChatPage() {
    List<Widget> children = [
      new SizedBox(height: 5.0),
      new Expanded(
          child: new ListView.builder(
        controller: _msgScrollCtrl,
        itemCount: messages.length,
        itemBuilder: (BuildContext cxt, int index) => new GestureDetector(
            onLongPress: () {
              setState(() {
                if (_contactOptionsPinned.contains(index))
                  _contactOptionsPinned.remove(index);
                else
                  _contactOptionsPinned.add(index);
                _contactsOptions = _contactOptionsPinned.length > 0;
              });
            },
            onTap: () {
              setState(() {
                if (_contactsOptions) {
                  if (_contactOptionsPinned.contains(index))
                    _contactOptionsPinned.remove(index);
                  else
                    _contactOptionsPinned.add(index);
                  _contactsOptions = _contactOptionsPinned.length > 0;
                }
              });
            },
            child: _messageView(index)),
      )),
      new SizedBox(height: 8.0),
      new Divider(height: 1.0)
    ];

    children.add(new Container(
      decoration: new BoxDecoration(color: Theme.of(context).cardColor),
      child: new Row(
        children: [
          new SizedBox(width: 8.0),
          new Expanded(
            child: new TextField(
              maxLines: _maxLines,
              controller: _messageController,
              onChanged: (String value) {
                if (value.isNotEmpty &&
                    (value.length == 2 || value.length % 8 == 0)) {
                  Services.instance().sendComposing(widget.person.phone);
                }
                setState(() {
                  _message = value;
                  int ceil = (_message.length / 25).ceil();
                  _maxLines = ceil <= 0 ? 1 : ceil;
                });
              },
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: 'Send a message',
              ),
            ),
          ),
          new IconButton(
            icon: new Icon(Icons.send),
            onPressed: _message.isNotEmpty ? _sendMessage : null,
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    ));
    return children;
  }

  Widget _messageView(int index) {
    AppMessage message = messages[index];
    return new Container(
        color: _contactOptionsPinned.contains(index)
            ? Colors.black26
            : Colors.transparent,
        padding: new EdgeInsets.only(bottom: 1.0),
        child: new ChatMessage(message));
  }

  void _sendMessage() {
    if (_message.isEmpty) return;
    Services.instance().sendMessage(widget.person.phone, _message,
        blockquoteId: _blockquoteId, replaceId: _replaceId);
    setState(() {
      _message = '';
      _maxLines = 1;
      _messageController.text = '';
    });
    _msgScrollCtrl.animateTo(_msgScrollCtrl.position.maxScrollExtent,
        curve: Curves.linear, duration: new Duration(milliseconds: 100));
  }
}
