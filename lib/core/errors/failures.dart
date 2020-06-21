import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
}

class ServerFailure implements Failure{
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class CacheFailure implements Failure{
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class UnauthorizedFailure implements Failure{
  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}