part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class Authenticated extends AuthState {
  final String uid;
  Authenticated({required this.uid});
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class UnAuthenticated extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
