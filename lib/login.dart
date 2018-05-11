import 'package:flutter/material.dart';
import 'package:voom_app/mainList.dart';
import 'package:voom_app/services.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
/*   final TextEditingController _controller1 = new TextEditingController();
 */
   TextStyle inputStyle = const TextStyle(
    fontSize: 15.0,
    color: Colors.white,
  );

  bool _load=false;
  
  @override
  Widget build(BuildContext context) {
    
    final logo=new Hero(
      tag: "log",
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset("images/voiture.jpg"),
      ),
    );

    final phoneNumber=new TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      /* initialValue: "0022961725134", */
      decoration: InputDecoration(
       hintText: "Numéro de téléphone",
       contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
       border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32.0)
       ),
     ),
    );

  final loginButton= new Padding(
    padding: EdgeInsets.symmetric(vertical: 10.0),
    child: new Material(
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Colors.redAccent.shade100,
     
      elevation: 5.0,
      child: new MaterialButton(
        minWidth: 200.0,
        height: 42.0,
        onPressed: (){

            Services instance = Services.instance();

            instance.login("spero", "espoiramey",(bool resp){
             print("========================= le texte $resp================");
            if(resp == true){
              setState((){
                _load=true;
                print("la valeu de   =========== $_load =============");
              });
                /*  Navigator.of(context).pop(); */
               Navigator.of(context).pop();
               Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
                builder: (BuildContext context)
                {
                  return new MainListe();
                }
              ),(route){ return true;});
            }else if( resp ==false){
              print("===========badddddddddddddddddddddddddddddddd========");
               Navigator.of(context).pop();
            }
            
            /* else{
              new CircularProgressIndicator();
            } */
            });


            showDialog(context: context, 
              builder: (BuildContext context){
                return new SimpleDialog(
                  /* title: new Text("My Super title"), */
                  children: <Widget>[
                    new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                            ),
                              /* new Container(
                              child: !_load?const CircularProgressIndicator():new Container(),
                              ), */
                             /*  !_load?const CircularProgressIndicator():new Container(), */
                              new Text("  Connexion en cours "), 
                          ],
                       ),
                      /* new Container(
                        child: !_load?const CircularProgressIndicator():new Container(),
                      ) */
                  ],
                );
              },
            );
         },
         color: Colors.redAccent,
         child: new Text("Validez",style: new TextStyle(color: Colors.white)),
      ),
    ),
  );

  

    
    return new Scaffold(
       backgroundColor: Colors.white,
       body: Center(
         /* decoration: new BoxDecoration(color: Colors.red), */
         child: new Center(
            child: new ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0,right: 24.0),
              children: <Widget>[
                logo,
                SizedBox(height: 48.0),
                phoneNumber,
                SizedBox(height: 8.0),
                loginButton,
              ],
            )
         ),
       )
    );
  }
}
