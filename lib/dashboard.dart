import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:recase/recase.dart';

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
class Totals{
  int totalDaily;
  int totalDays;
  int totalExtra;
  bool isReady;

  Totals({this.totalDaily=0,this.totalDays=0,this.totalExtra=0,this.isReady=false});
}
class User {
  String name;
  String email;
  String rollNumber;
  String mess;

  User({this.name="NA", this.email="NA", this.rollNumber="NA", this.mess="NA"});
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final _url = "https://nitc-mess.herokuapp.com";
    final _storage = FlutterSecureStorage();
    Totals _totals = Totals();
    String _token;

    //Secondary Styled Text
    Widget secText(String text){
      return Text(
        text,
        style: GoogleFonts.oxygen(
          color: Colors.black45
        ),
      );
    }

    Widget _getDate(int date){
      final dateTime = DateTime.fromMillisecondsSinceEpoch(date * 1000);
      return Text(
        dateTime.day.toString() + "/" + dateTime.month.toString() + '/' + dateTime.year.toString()
      );
    }

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
          headers: {HttpHeaders.contentTypeHeader:'application/json',HttpHeaders.authorizationHeader: "Bearer " + _token});
      if (result.statusCode == 200) {
        final jsonResponse = json.decode(result.body)['user'];
        print(jsonResponse);
        final user =  User(
            name: jsonResponse['name'],
            email: jsonResponse['email'],
            rollNumber: jsonResponse['rollNumber'],
            mess: jsonResponse['mess']);
        return user;
      }else if(result.statusCode == 401){
        Navigator.pushReplacementNamed(context, '/login');
        return User();
      } 
      return User();
    }

    Future<List<Extra>> _getExtras() async {
      List<Extra> extras = [];
      Totals totals = new Totals();
      await _getToken();
      http.Response response;
      try {
        if (_token != null) {
          response = await http.get(_url + "/api/users/dues/",
              headers: {HttpHeaders.contentTypeHeader:'application/json',HttpHeaders.authorizationHeader: "Bearer " + _token});
          print(response.statusCode);
          print(response.body);
          if (response.statusCode == 200) {
            var responsejson = jsonDecode(response.body);
            for (var item in responsejson) {
              if (item['message'] == 'DailyCharge') {
                totals.totalDays += 1;
                totals.totalDaily += item['amount'];
              } else {
                var extra = Extra(
                    rollNumber: item['rollNumber'],
                    message: item['message'],
                    amount: item['amount'],
                    date: item['date']);
                totals.totalExtra += item['amount'];
                extras.add(extra);
              }
            }
            totals.isReady=true;
            _totals=totals;
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
      return null;
    }
    final extraList = FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.data != null &&
            snapshot.connectionState == ConnectionState.done) {
              final extraList = snapshot.data.reversed.toList();
          return ListView.builder(
            itemCount: extraList.length,
            itemBuilder: (context, index) {
              Extra extra = extraList[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text(extra.message),
                    subtitle: _getDate(extra.date),
                    contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 15.0),
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
      future: _getExtras(),
    );

    final self = Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<User>(
          builder: (context, snapshot) {
            if (snapshot.data != null &&
                snapshot.connectionState == ConnectionState.done) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(flex:1,child: Padding(padding: EdgeInsets.all(10),child: Icon(Icons.person),)),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          snapshot.data.name.titleCase,
                          style: GoogleFonts.tradeWinds()
                        ),
                        secText(snapshot.data.rollNumber),
                        secText("Mess: " + snapshot.data.mess),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        secText("Total Days: " + _totals.totalDays.toString()),
                        secText('Daily Charge: ' + _totals.totalDaily.toString()),
                        secText('Extra Charge: ' + _totals.totalExtra.toString()),
                        secText('Grand Total: ' +
                            (_totals.totalDaily + _totals.totalExtra).toString())
                      ],
                    ),
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
          });
        }),
    );
  }
}
