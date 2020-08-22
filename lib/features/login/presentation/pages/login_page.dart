import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mess_management_flutter/strings.dart';
import 'package:mess_management_flutter/features/login/presentation/cubit/login_cubit.dart';
import 'package:mess_management_flutter/features/login/presentation/pages/splash_screen.dart';
import 'package:mess_management_flutter/styles.dart';

import '../../../../injection_container.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  BlocProvider<LoginCubit> _buildBody() {
    return BlocProvider(
      create: (BuildContext context) => sl<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        builder: (context, state) {
          if (state is LoginInitial) {
            final loginCubit = context.bloc<LoginCubit>();
            loginCubit.silentLogin();
            return SplashScreen();
          } else {
            return LoginForm();
          }
        },
        listener: (BuildContext context, state) {
          if (state is SilentLoginSuccess || state is LoginSuccess) {
            Navigator.of(context).popAndPushNamed('/dashboard');
          } else if (state is LoginFailure) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({
    Key key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _rollNumber;

  String _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 75, 0, 100),
                child: Container(
                    height: 100,
                    width: 100,
                    child: Image.asset('assets/icon1.png')),
              ),
              rollNumberTextField(),
              passwordTextField(),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (BuildContext context, state) {
                  if (state is LoginLoading) {
                    return _buildLoading();
                  } else {
                    return _buildButton(context);
                  }
                },
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget rollNumberTextField() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
        child: TextFormField(
          textCapitalization: TextCapitalization.characters,
          validator: (value) {
            if (value.length == 9) {
              return null;
            } else {
              return VALID_ROLL;
            }
          },
          onSaved: (String value) {
            this._rollNumber = value;
          },
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              labelText: ROLLNO,
              border: OutlineInputBorder()),
        ),
      );

  Widget passwordTextField() => Padding(
        padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
        child: TextFormField(
          validator: (value) {
            if (value.isNotEmpty) {
              return null;
            } else {
              return PASS_REQ;
            }
          },
          onSaved: (value) {
            this._password = value;
          },
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              labelText: PASSWORD,
              labelStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              )),
        ),
      );

  Widget _buildButton(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: RaisedButton(
          color: primaryColor,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          child: Text(LOGIN,style: boldWhite),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              BlocProvider.of<LoginCubit>(context)
                  .login(_rollNumber, _password);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
