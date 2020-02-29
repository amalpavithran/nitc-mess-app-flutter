import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mess_management_flutter/sharedcode.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final storage = new FlutterSecureStorage();
  String _email,_password;
  final url = "https://nitc-mess.herokuapp.com";
  bool _isLoading = false;
  String _loadingText = "Logging In...";
  final GlobalKey<FormState> _loginkey = GlobalKey<FormState>();

  Widget progress() => Padding(
      padding: EdgeInsets.all(20), child: this._isLoading?CircularProgressIndicator():Container()
  );

  Widget info() => Padding(
    padding: EdgeInsets.all(20),
    child: Text(_loadingText, style: TextStyle(color: Colors.black54))
  );

  Widget loadingScreen() => Center(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [progress(), info()]),
  );
  
  @override
  Widget build(BuildContext context) {
    final email = Padding(
    padding: const EdgeInsets.symmetric(
        vertical: 7.0, horizontal: 10.0),
    child: TextFormField(
      validator: (value){
        if(isEmail(value)){
          return null;
        }else{
          return "Enter a valid Email";
        }
      },
      onSaved: (String value) {this._email=value;},
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black)
          ),
          labelText: "Email", border: OutlineInputBorder()),
    ),
  );
  final password = Padding(
    padding:
        EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
    child: TextFormField(
      onSaved: (value){this._password = value;},
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black)
          ),
          labelText: "Password", border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black)
          )),
    ),
  );
    Widget login() => SingleChildScrollView(
          child: Form(
            key: _loginkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 50, top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/icon1.png',
                        width: 150,
                        height: 150,
                      )
                    ],
                  ),
                ),
                email,
                password,
                Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
                    child: SizedBox(
                      height: 55,
                      child: RaisedButton(
                        color: Colors.blue,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        child: Center(
                            child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        )),
                        onPressed: () async {
                          setState(() {
                            _isLoading=true;
                          });
                          if(_loginkey.currentState.validate()){
                            _loginkey.currentState.save();
                            print(_email);
                            print(_password);
                            http.Response response = await http.post(
                              url+'/api/auth/signin',
                              headers: {HttpHeaders.contentTypeHeader:'application/json'},
                              body: convert.json.encode({
                                'email':_email,
                                'password':_password
                              })
                            );
                            print(_email);
                            print(_password);
                            print(response.statusCode);
                            print(response.body);
                            if(response.statusCode == 200){
                              var jsonResponse  = convert.jsonDecode(response.body);
                              storage.write(key: 'token', value: jsonResponse['token']);
                              print(jsonResponse);
                            }               
                            Navigator.pushReplacementNamed(context, '/dashboard');            
                          }
                          print(this._isLoading);
                          
                        },
                      ),
                    )
                  ),
                  Container(
                    child: (this._isLoading)?CircularProgressIndicator():Container(),
                  )
              ],
            ),
          ),
        );
        
    return PreventAppExit(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text("NITC MESS", style: GoogleFonts.abel(
              textStyle: TextStyle(fontWeight: FontWeight.bold)
            )),
          ),
          body: (this._isLoading) ? loadingScreen() : login()),
    );
  }
}
