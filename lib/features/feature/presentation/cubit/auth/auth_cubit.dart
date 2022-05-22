import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/features/feature/domain/usecases/get_current_uid_usecase.dart';
import 'package:mynotes/features/feature/domain/usecases/is_sign_in_usecase.dart';
import 'package:mynotes/features/feature/domain/usecases/sign_out_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetCurrentUidUsecase getCurrentUidUsecase;
  final IsSignInUseCase isSignInUseCase;
  final SignOutUseCase? signOutUseCase;

  AuthCubit(
      {required this.getCurrentUidUsecase,
      required this.isSignInUseCase,
      required this.signOutUseCase})
      : super(AuthInitial());

  Future<void> appStarted() async {
    try {
      final isSignIn = await isSignInUseCase.call();
      if (isSignIn) {
        final uId = await getCurrentUidUsecase.call().toString();
        emit(Authenticated(uid: uId));
      } else {
        emit(UnAuthenticated());
      }
    } on SocketException catch (_) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedIn() async {
    try {
      final uid = getCurrentUidUsecase.call().toString();
      emit(Authenticated(uid: uid));
    } on SocketException catch (_) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut() async {
    try {
      await signOutUseCase!.call();

      emit(UnAuthenticated());
    } on SocketException catch (_) {
      emit(UnAuthenticated());
    }
  }
}
