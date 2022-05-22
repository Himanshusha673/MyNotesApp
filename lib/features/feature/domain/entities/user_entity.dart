import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserEntity extends Equatable {
  final String? name;
  final String? email;
  final String? uid;
  final String? status;
  final String? password;

  UserEntity(
      {this.email,
      this.name,
      this.password,
      this.status = "Hello there I'am Using this App",
      this.uid});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
