import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class Extra {
  String rollNumber;
  String message;
  int amount;
  int date;

  Extra({
    this.rollNumber,
    this.message,
    this.amount,
    this.date,
  });
}

class User {
  String name;
  String email;
  String rollNumber;
  String mess;

  User({this.name, this.email, this.rollNumber, this.mess});
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final _url = "https://nitc-mess.herokuapp.com";
    final _storage = FlutterSecureStorage();
    int _totalExtra = 0;
    int _totalDaily = 0;
    int _totalDays = 0;
    String _token;

    _getToken() async {
      final key  = await _storage.read(key: 'token');
      if(key == null){
        Navigator.pushReplacementNamed(context, '/login');
      }else{
        _token = key;
      }
    }

    Future<User> _getUser() async {
      await _getToken();
      final result = await http.get(_url + '/api/users/me/',
          headers: {HttpHeaders.authorizationHeader: "Bearer" + _token});
      if (result.statusCode == 200) {
        print(result.statusCode);
        final jsonResponse = json.decode(result.body);
        return User(
            name: jsonResponse['name'],
            email: jsonResponse['email'],
            rollNumber: jsonResponse['rollNumber'],
            mess: jsonResponse['mess']);
      } else {
        print(result);
        return User(email: "NA",name: "NA",rollNumber: "NA",mess: "NA");
      }
    }

    Future<List<Extra>> getExtras() async {
      List<Extra> extras = [];
      await _getToken();
      http.Response response;
      try {
        if (_token != null) {
          response = await http.get(_url + "/api/users/dues/",
              headers: {HttpHeaders.authorizationHeader: "Bearer " + _token});
          print(response);
          if (response.statusCode == 200) {
            var responsejson = jsonDecode(response.body);
            for (var item in responsejson) {
              if (item['message'] == 'DailyCharge') {
                _totalDays += 1;
                _totalDaily += item['amount'];
              } else {
                var extra = Extra(
                    rollNumber: item['rollNumber'],
                    message: item['message'],
                    amount: item['amount'],
                    date: item['date']);
                _totalExtra += item['amount'];
                extras.add(extra);
              }
            }
            return extras;
          } else {
            extras.add(Extra());
            return extras;
          }
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } catch (error) {
        print(error);
      }
    }

    final extraList = FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.data != null &&
            snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              Extra extra = snapshot.data[index];
              return Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text(extra.message),
                    contentPadding: EdgeInsets.all(5),
                    trailing: Text(extra.amount.toString()),
                  ),
                  Divider()
                ],
              );
            },
          );
        } else {
          return Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
      },
      future: getExtras(),
    );

    final self = Card(
      child: FutureBuilder<User>(
        builder: (context, snapshot) {
          if (snapshot.data != null &&
              snapshot.connectionState == ConnectionState.done) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    child: Icon(Icons.person),padding: EdgeInsets.all(5),),
                Column(
                  children: <Widget>[
                    Text(
                      snapshot.data.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(snapshot.data.rollNumber),
                    Text(snapshot.data.mess),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text("Total Days: " + _totalDays.toString())),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text('Daily Charge: ' + _totalDaily.toString())),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text('Extra Charge: ' + _totalExtra.toString())),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text('Grand Total: ' +
                            (_totalDaily + _totalExtra).toString()))
                  ],
                )
              ],
            );
          } else {
            return Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
        },
        future: _getUser(),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.black),
              onPressed: () async {
                await _storage.delete(key: 'token');
                Navigator.pushReplacementNamed(context, '/login');
              })
        ],
        title: Text("NITC MESS",
            style: GoogleFonts.abel(
                textStyle: TextStyle(fontWeight: FontWeight.bold))),
      ),
      body: Column(
        children: <Widget>[self, Expanded(child: extraList)],
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.refresh), 
        onPressed: (){
          setState(() {
            _getToken();
            getExtras();
            _getUser();
          });
        }),
    );
  }
}
