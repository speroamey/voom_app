import 'package:voom_app/src/core.dart';
import 'package:voom_app/src/enums.dart';


class Services {
  static StropheConnection _Connection;
  static Services _instance;

  Services._(){
     _Connection=Strophe.Connection('ws://192.168.20.30:5280/ws');
     
  }
  static Services instance(){
    if(_instance == null)  _instance = Services._();
      return _instance;
  }

  login(String phone,String pass,callback){
    _Connection.connect('$phone@localhost', pass, (int status,condition,elem){
      print('login $status');
      if(status==Strophe.Status['CONNECTED']){
       callback(true);
      }
      if(status==Strophe.Status['DISCONNECTED'] ||
         status==Strophe.Status['CONFAIL'] ||
         status==Strophe.Status['CONNTIMEOUT']
        ){
        callback(false);
      }
    });

  }
}