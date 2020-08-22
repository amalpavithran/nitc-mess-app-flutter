part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class SilentLoginSuccess extends LoginState {
  @override
  List<Object> get props => [];
}

class SilentLoginFailure extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccess extends LoginState {
  final User user;

  LoginSuccess(this.user);
  @override
  List<Object> get props => [];
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);
  @override
  List<Object> get props => [];
}
