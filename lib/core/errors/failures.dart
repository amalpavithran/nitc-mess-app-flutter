import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class ServerFailure extends Failure {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class CacheFailure extends Failure {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class UnauthorizedFailure extends Failure {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class UnexpectedFailure extends Failure {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class NoInternetConnection extends Failure {
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}
