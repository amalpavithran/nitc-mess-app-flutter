import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mess_management_flutter/core/strings.dart';
import 'package:mess_management_flutter/features/login/presentation/cubit/login_cubit.dart';

import '../../../../injection_container.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(TITLE),
        ),
        body: SingleChildScrollView(child: _buildBody()));
  }

  BlocProvider<LoginCubit> _buildBody() {
    return BlocProvider(
      create: (BuildContext context) => sl<LoginCubit>(),
      child: BlocConsumer<LoginCubit,LoginState>(
        builder: (context, state) {
          if (state is LoginInitial) {
            print("LoginInitial");
            final loginCubit = context.bloc<LoginCubit>();
            loginCubit.silentLogin();
            return _buildSplashScreen();
          } else {
            return Column(
              children: <Widget>[
                TextFormField(),
                TextFormField(),
                BlocBuilder<LoginCubit,LoginState>(
                  builder: (BuildContext context, state) {
                    if (state is LoginLoading) {
                      return _buildLoading();
                    } else {
                      return _buildButton();
                    }
                  },
                )
              ],
            );
          }
        },
        listener: (BuildContext context, state) {
          if(state is SilentLoginSuccess){
            Navigator.of(context).popAndPushNamed('/dashboard');
          }
        },
      ),
    );
  }

  Widget _buildButton() {
    return RaisedButton(
      child: Text(LOGIN),
      onPressed: () {},
    );
  }

  Widget _buildLoading() {
    return Container(
      height: 50,
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSplashScreen() {
    return Center(
      child: Column(
        children: <Widget>[
          Image.asset('icon1.png'),
          Text(TITLE),
        ],
      ),
    );
  }
}
