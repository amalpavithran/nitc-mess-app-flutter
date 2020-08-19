import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mess_management_flutter/core/strings.dart';
import 'package:mess_management_flutter/features/login/presentation/cubit/login_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TITLE),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(),
            TextFormField(),
            BlocBuilder(builder: (BuildContext context, state) {  
              if(state is LoginLoading){
                return buildLoading();
              }else{
                return buildButton();
              }
            },)
          ],
        ),
      ),
    );
  }

  Widget buildButton() {
    return RaisedButton(
      child: Text(LOGIN),
      onPressed: () {
        
      },
    );
  }

  Widget buildLoading() {
    return Container(
      height: 50,
      child: CircularProgressIndicator(),
    );
  }
}
