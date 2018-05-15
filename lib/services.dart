import 'dart:async';

import 'package:voom_app/personClass.dart';
import 'package:voom_app/src/core.dart';
import 'package:voom_app/src/enums.dart';
import 'package:xml/xml/nodes/document.dart';
import 'package:xml/xml/nodes/element.dart';
import 'package:xml/xml/nodes/node.dart';

class Services {
  Map<String, Person> _persons = {};
  StreamController<List<Person>> _personsStream =
      new StreamController<List<Person>>();
  Map<String, List<AppMessage>> _messages = {};
  StropheConnection _connection;
  static Services _instance;
  String _pass = "jesuis123";
  String _jid;
  String _domain = 'localhost';
  String _url;

  num _lat = 2.3;
  num _lon = 2.3;
  String name = "andre";

  String _host = '192.168.8.101';

  String title = "driver";

  Services._() {
    _url = "ws://$_host:5280/xmpp";
    _connection = Strophe.Connection(_url);
    _connection.xmlInput = (stanza) {
      print("input $stanza");
    };
    _connection.xmlOutput = (stanza) {
      print("output $stanza");
    };
  }
  static Services instance() {
    if (_instance == null) _instance = Services._();
    return _instance;
  }

  String get jid {
    return _jid;
  }

  set jid(String id) {
    id = this._formatToJid(id);
    if (id != null && id.indexOf("@$_domain") != -1) {
      _jid = id;
    }
  }

  num get lat {
    return _lat;
  }

  set lat(num newLat) {
    if (newLat != null) _lat = newLat;
  }

  num get lon {
    return _lon;
  }

  set lon(num newLon) {
    if (newLon != null) _lon = newLon;
  }

  String get pass {
    return _pass;
  }

  set pass(String pwd) {
    if (pwd != null) _pass = pwd;
  }

  bool get connected {
    return this._connection.connected;
  }

  String _formatToJid(String phone, [String domain]) {
    phone = phone ?? this.jid;
    if (phone == null) return null;
    if (domain == null || domain.isEmpty) domain = this._domain;
    if (phone != null && phone.indexOf("@$domain") != -1) {
      return phone;
    }
    phone = Strophe.getNodeFromJid(phone) ?? phone;
    return "$phone@$domain";
  }

  login(String phone, String pass, callback) {
    String jid = this._formatToJid(phone);
    _connection.connect(jid, pass, (int status, condition, elem) {
      print('login $status $jid, $pass');
      callback(status, condition, elem);
      if (status == Strophe.Status['CONNECTED']) {
        this.handleAfterConnect();
      }
    });
  }

  register(String phone, String password) {
    this._connection.register.connect(this._domain,
        (int status, condition, ele) {
      if (status == Strophe.Status['REGISTER']) {
        print('register');
        this._pass = password ?? this._pass;
        this._connection.register.fields['username'] = phone;
        this._connection.register.fields['password'] = this._pass;
        this._connection.register.fields['name'] = phone;
        this._connection.register.fields['email'] = "";
        this._connection.register.submit();
      } else if (status == Strophe.Status['REGISTERED']) {
        print("registered!");
        this.jid = _formatToJid(phone);
        this._connection.authenticate(null);
      } else if (status == Strophe.Status['CONFLICT']) {
        print("Contact already existed!");
      } else if (status == Strophe.Status['NOTACCEPTABLE']) {
        print("Registration form not properly filled out.");
      } else if (status == Strophe.Status['REGIFAIL']) {
        print(
            "The Server does not support In-Band Registration $condition $ele");
      } else if (status == Strophe.Status['CONNECTED']) {
        print('is connected');
        this.handleAfterConnect();
      } else if (status == Strophe.Status['DISCONNECTED']) {}
    });
  }

  handleAfterConnect() {
    this.sendPresence();
    this.handlePresence();
    this.handleMessage();
    this.handleReceiptsMessage();
    this.handleComposingMessage();
  }

  sendComposing(String jid) {
    if (!this._connection.connected) return;
    jid = this._formatToJid(jid);
    if (jid == null) return;
    String type = 'chat';
    this._connection.chatstates.sendComposing(jid, type);
  }

  sendPresence() {
    print("sendPresence 1");
    if (!this._connection.connected) return;
    print("sendPresence 2");
    if (this.lat == null ||
        this.lon == null ||
        this.name == null ||
        this.title == null) return;
    _connection.sendPresence(Strophe
        .$pres({'id': this._connection.getUniqueId("sendOnLine")})
        .c('data')
        .c('lat')
        .t(this.lat.toString())
        .up()
        .c('lon')
        .t(this.lon.toString())
        .up()
        .c('name')
        .t(this.name)
        .up()
        .c('title')
        .t(this.title)
        .up()
        .tree());
  }

  void handlePresence() {
    this._connection.addHandler((XmlElement presence) {
      print("presence $presence");
      String id = presence.getAttribute('id');
      String type = presence.getAttribute('type') ?? '';
      String from = presence.getAttribute('from');
      from = Strophe.getBareJidFromJid(from);
      if (type == 'unavailable') {
        this.deletePerson(from);
      } else if (id.endsWith('sendOnLine') && type.isEmpty) {
        String phone = Strophe.getNodeFromJid(from);
        List<XmlElement> lat = presence.findAllElements('lat').toList();
        List<XmlElement> lon = presence.findAllElements('lon').toList();
        List<XmlElement> name = presence.findAllElements('name').toList();
        List<XmlElement> title = presence.findAllElements('title').toList();
        if (title.length == 0 || lat.length == 0 || lon.length == 0)
          return true;
        Person p = new Person(name.length > 0 ? name[0].text : '', phone,
            double.parse(lat[0].text), double.parse(lon[0].text));
        this._addOrUpdatePerson(p);
      }
      return true;
    }, null, 'presence');
  }

  void handleComposingMessage() {
    this._connection.addHandler((XmlElement msg) {
      print('handleComposingMessage $msg');
      String from = msg.getAttribute('from');
      from = Strophe.getBareJidFromJid(from);
      List<XmlElement> composing = msg.findAllElements('composing').toList();
      if (composing.length > 0) {
        bool value = true;
      }
      return true;
    }, Strophe.NS['CHATSTATES'], 'message', ['chat', 'groupchat']);
  }

  void handleReceiptsMessage() {
    this._connection.addHandler((XmlElement msg) {
      print('handleReceiptsMessage $msg');
    }, Strophe.NS['RECEIPTS'], 'message', null, ':receipts', null,
        {'endsWithId': true});
  }

  void handleMessage() {
    this._connection.addHandler((XmlElement msg) {
      String from = msg.getAttribute('from');
      String to = msg.getAttribute('to');
      from = Strophe.getBareJidFromJid(from);
      from = this._formatToJid(from);
      to = Strophe.getBareJidFromJid(to);
      to = this._formatToJid(to);
      if (!_namespaceMatch(msg, Strophe.NS['CHATSTATES'])) {
        print('handleMessage $msg');
        List<XmlElement> body = msg.findAllElements('body').toList();
        if (body.length == 0) return true;
        String id = '0';
        List<XmlElement> p = body[0].findElements('p').toList();
        if (p.length > 0) id = p[0].getAttribute('id') ?? '0';
        if (id == '0') {
          List<XmlElement> delay = body[0].findAllElements('delay').toList();
          if (delay.length > 0) {
            String stamp = delay[0].getAttribute('stamp');
            if (stamp != null) {
              id = DateTime.parse(stamp).millisecondsSinceEpoch.toString();
            }
          }
        }
        List<XmlElement> blockquote =
            body[0].findAllElements('blockquote').toList();
        Map<String, dynamic> message = {
          'content': body[0].text.toString(),
          'id': int.parse(id),
          'date': int.parse(id),
          'name': Strophe.getNodeFromJid(from),
          'from': from,
          'to': to,
          'status': SentStatus.NONE,
          'blockquote': blockquote.length > 0 ? blockquote[0] : ''
        };
        this.addMessages(new AppMessage.fromMap(message));
        if (_namespaceMatch(msg, Strophe.NS['RECEIPTS']))
          sendReceiptsMessage(from, msg.getAttribute('id'));
      }
      return true;
    }, null, 'message', 'chat');
  }

  sendReceiptsMessage(String jid, String id) {
    if (!this._connection.connected) return;
    if (jid == null || jid.isEmpty || id == null || id.isEmpty) return;
    jid = this._formatToJid(jid);
    StanzaBuilder msg = Strophe.Builder('message', attrs: {
      'id': _connection.getUniqueId('receipts'),
      'to': jid,
      'from': this.jid
    });
    msg.c('request', {'xmlns': Strophe.NS['RECEIPTS'], 'id': id});
    this._connection.send(msg.tree());
  }

  sendMessage(String jid, String message,
      {String userName = '', String blockquoteId = '', String replaceId}) {
    jid = this._formatToJid(jid);
    if (jid == null) return;
    String type = 'chat';
    String now = new DateTime.now().millisecondsSinceEpoch.toString();
    Map<String, dynamic> sms = {
      'content': message,
      'id': int.parse(now),
      'date': int.parse(now),
      'name': Strophe.getNodeFromJid(this.jid),
      'from': this.jid,
      'to': jid,
      'blockquote': blockquoteId
    };
    this.addMessages(new AppMessage.fromMap(sms));
    if (!this._connection.connected) return;
    StanzaBuilder msg = Strophe.Builder('message',
        attrs: {'id': now, 'to': jid, 'from': this.jid, 'type': type});
    msg
        .c('subject')
        .t(userName ?? jid)
        .up()
        .c('request', {'xmlns': Strophe.NS['RECEIPTS']}).up();
    if (replaceId != null && replaceId.isNotEmpty) {
      msg.c('replace',
          {'id': replaceId, 'xmlns': Strophe.NS['MESSAGE_CORRECT']}).up();
    }
    msg.c('html', {'xmlns': 'http://jabber.org/protocol/xhtml-im'}).c(
        'body', {'xmlns': 'http://www.w3.org/1999/xhtml'});
    if (blockquoteId != null && blockquoteId.isNotEmpty)
      msg.c('blockquote').t(blockquoteId).up();
    msg.c('p', {'date': now, 'id': now}).t(message.toString()).up();
    this._connection.send(msg.tree());
  }

  disconnect([String reason = '']) {
    if (!this._connection.connected) return;
    this._connection.disconnect(reason);
    this._connection = Strophe.Connection(this._url);
  }

  bool _namespaceMatch(XmlNode elem, String ns) {
    bool nsMatch = false;
    if (ns == null || ns.isEmpty) {
      return true;
    } else {
      Strophe.forEachChild(elem, null, (elem) {
        if (this._getNamespace(elem) == ns) {
          nsMatch = true;
        }
      });
      nsMatch = nsMatch || _getNamespace(elem) == ns;
    }
    return nsMatch;
  }

  String _getNamespace(XmlNode node) {
    XmlElement elem =
        node is XmlDocument ? node.rootElement : node as XmlElement;
    String elNamespace = elem.getAttribute("xmlns") ?? '';
    return elNamespace;
  }

  Stream<List<Person>> getPersons([String search]) {
    List<Person> sortPersons = _sortPersons();
    if (search != null && search.isNotEmpty) {
      sortPersons = sortPersons.where((Person p) {
        return p.name.toLowerCase().indexOf(search.toLowerCase()) != -1 ||
            p.phone.toLowerCase().indexOf(search.toLowerCase()) != -1;
      }).toList();
    }
    _personsStream.add(sortPersons);
    return _personsStream.stream;
  }

  List<Person> _sortPersons([List<Person> listToSort]) {
    List<Person> list;
    if (listToSort == null) {
      list = new List();
      list.addAll(this._persons.values.toList());
    } else {
      list = listToSort;
    }
    if (list.isEmpty) return [];
    int compareTo;
    list.sort((Person a, Person b) {
      compareTo = a.distance.compareTo(b.distance);
      if (compareTo == 0)
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      else
        return -(compareTo);
    });
    //this.personStreamed();
    return list;
  }

  addMessages(AppMessage msg) {
    if (msg == null || msg.from == null) return;
    this._messages[msg.from] = this._messages[msg.from] ?? [];
    this._messages[msg.from].add(msg);
  }

  void deletePerson(String from) {
    if (from == null || from.isEmpty) return;
    this._persons.remove(from);
    this.deleteAllMessage(from);
    this._personsStream.add(this._sortPersons());
  }

  void deleteAllMessage(String from) {
    this._messages.remove(from);
  }

  void _addOrUpdatePerson(Person person) {
    if (person == null || person.phone == null) return;
    person.distance = distVincenty(person.lat, person.long, this.lat, this.lon);
    this._persons[person.phone] = person;
    this._personsStream.add(this._sortPersons());
  }

  updatePersonField() {
    this._personsStream.add(this._sortPersons());
  }
}
