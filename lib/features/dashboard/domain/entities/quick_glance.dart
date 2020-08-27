import 'package:equatable/equatable.dart';
import 'package:mess_management_flutter/features/dashboard/domain/entities/totals.dart';
import 'package:mess_management_flutter/features/login/domain/entities/user.dart';

class QuickGlance extends Equatable{
  final User user;
  final Totals totals;

  QuickGlance(this.user, this.totals);

  @override
  List<Object> get props => [user.hashCode,totals.hashCode];
}