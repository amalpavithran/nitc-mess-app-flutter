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
  double amount;
  DateTime date;

  Extra({
    this.rollNumber,
    this.message,
    this.amount,
    this.date,
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
      final response = await http.get(_url + "/api/users/dues/",headers: {HttpHeaders.authorizationHeader: _token});
      if (response.statusCode == 200) {
        var responsejson = jsonDecode(response.body);
        for (var item in responsejson) {
          var extra = Extra(
            rollNumber: item['rollNumber'],
            message: item['message'],
            amount: item['amount'],
            date: item['date']
          );
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
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            Extra extra = snapshot.data[index];
            return ListTile(
              leading: Icon(Icons.attach_money),
              title: Text(extra.message),
              trailing: Text(extra.amount.toString()),
            );
          },
        );
      },
      future: getExtras(),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("NITC MESS",
            style: GoogleFonts.abel(
                textStyle: TextStyle(fontWeight: FontWeight.bold))),
      ),
      body: extraList,
    );
  }
}
