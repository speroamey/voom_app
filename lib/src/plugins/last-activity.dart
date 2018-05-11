import 'package:voom_app/src/core.dart';
import 'package:voom_app/src/enums.dart';
import 'package:voom_app/src/plugins/plugins.dart';

class LastActivity extends PluginClass {
  init(StropheConnection conn) {
    this.connection = conn;
    Strophe.addNamespace('LAST_ACTIVITY', "jabber:iq:last");
  }

  getLastActivity(String jid, Function success, [Function error]) {
    String id = this.connection.getUniqueId('last1');
    this.connection.sendIQ(
        Strophe.$iq({'id': id, 'type': 'get', 'to': jid}).c(
            'query', {'xmlns': Strophe.NS['LAST_ACTIVITY']}).tree(),
        success,
        error);
  }
}
