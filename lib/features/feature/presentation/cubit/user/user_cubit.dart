import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/features/feature/domain/entities/user_entity.dart';
import 'package:mynotes/features/feature/domain/usecases/get_create_current_user_usecase.dart';
import 'package:mynotes/features/feature/domain/usecases/get_current_uid_usecase.dart';
import 'package:mynotes/features/feature/domain/usecases/sign_in_usecase.dart';
import 'package:mynotes/features/feature/domain/usecases/sign_up_usecase.dart';
part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final GetCreateCurrentUserUsecase getCreateCurrentUserUsecase;
  UserCubit(
      {required this.getCreateCurrentUserUsecase,
      required this.signInUseCase,
      required this.signUpUseCase})
      : super(UserInitial());
  Future<void> submitSignIn(UserEntity user) async {
    emit(UserLoading());
    try {
      await signInUseCase.call(user);
    } on SocketException catch (e) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> submitSignUp(UserEntity user) async {
    emit(UserLoading());
    try {
      await signUpUseCase.call(user);
      await getCreateCurrentUserUsecase.call(user);
      emit(UserSuccess());
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }
}
