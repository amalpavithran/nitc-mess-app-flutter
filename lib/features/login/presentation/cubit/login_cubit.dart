import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mess_management_flutter/core/errors/failures.dart';
import 'package:mess_management_flutter/core/usecases/usecase.dart';
import 'package:mess_management_flutter/features/login/domain/entities/user.dart';
import 'package:mess_management_flutter/features/login/domain/usecases/login.dart';
import 'package:mess_management_flutter/features/login/domain/usecases/silent_login.dart';

part 'login_state.dart';

const String SERVER_FAILURE_MESSAGE = "Server Error";
const String UNEXPECTED_FAILURE_MESSAGE = "An Unexpected Error Has Occoured";

class LoginCubit extends Cubit<LoginState> {
  final Login loginUsecase;
  final SilentLogin silentLoginUsecase;

  LoginCubit({@required this.loginUsecase, @required this.silentLoginUsecase})
      : super(LoginInitial());

  void login(String username, String password) async {
    emit(LoginLoading());
    final result = await loginUsecase(
      Params(
        username: username,
        password: password,
      ),
    );
    final state = result.fold(
      (l) => LoginFailure(mapFailureToMessage(l)),
      (r) => LoginSuccess(r),
    );
    emit(state);
  }

  void silentLogin() async {
    final result = await silentLoginUsecase(NoParams());
    
    final state = result.fold(
      (l) => SilentLoginFailure(),
      (r) => SilentLoginSuccess(),
    );
    emit(state);
  }

  String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      default:
        return UNEXPECTED_FAILURE_MESSAGE;
    }
  }
}
