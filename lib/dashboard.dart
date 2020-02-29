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

  User({
    this.name,
    this.email,
    this.rollNumber,
    this.mess
  });
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final _url = "https://nitc-mess.herokuapp.com";
    final _storage = FlutterSecureStorage();

    
    Future<List<Extra>> getExtras() async {
      List<Extra> extras = [];
      final _token  = await _storage.read(key: 'token');
      if(_token==null){
        Navigator.pushReplacementNamed(context, '/login');
      }
      http.Response response = await http.get(_url + "/api/users/dues/",headers: {HttpHeaders.authorizationHeader: "Bearer " + _token});
      if (response.statusCode == 200) {
        var responsejson = jsonDecode(response.body);
        for (var item in responsejson) {
          var extra = Extra(
            rollNumber: item['rollNumber'],
            message: item['message'],
            amount: item['amount'],
            date: item['date']
          );
          print(item);
          extras.add(extra);
        }
        return extras;
      }else{
        return [];
      }
    }

    final extraList = FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.hasData == null) {
          return Container();
        }else{
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            Extra extra = snapshot.data[index];
            return ListTile(
              leading: Icon(Icons.attach_money),
              title: Text(extra.message),
              contentPadding: EdgeInsets.all(5),
              
              trailing: Text(extra.amount.toString()),
            );
          },
        );}
      },
      future: getExtras(),
    );

    final self = Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(child: Icon(Icons.person),alignment: Alignment.centerLeft),
          Column(
            children: <Widget>[
              Text()
            ],
          )
        ],
      ),
    )
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app,
            color: Colors.black),
            onPressed: () async{
              await _storage.delete(key: 'token');
              Navigator.pushReplacementNamed(context, '/login');
            })
        ],
        title: Text("NITC MESS",
            style: GoogleFonts.abel(
                textStyle: TextStyle(fontWeight: FontWeight.bold))),
      ),
      body: extraList,
    );
  }
}
