import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:mynotes/features/feature/data/datasources/firebase_remote_data_source.dart';
import 'package:mynotes/features/feature/data/repositories/firebase_repository_impl.dart';
import 'package:mynotes/features/feature/domain/repositories/firebase_repository.dart';
import 'package:mynotes/features/feature/domain/usecases/add_new_task_Usecase.dart';
import 'package:mynotes/features/feature/domain/usecases/delete_note_usecase.dart';
import 'package:mynotes/features/feature/domain/usecases/get_create_current_user_usecase.dart';
import 'package:mynotes/features/feature/domain/usecases/get_current_uid_usecase.dart';
import 'package:mynotes/features/feature/domain/usecases/get_notes_usecase.dart';
import 'package:mynotes/features/feature/domain/usecases/is_sign_in_usecase.dart';
import 'package:mynotes/features/feature/domain/usecases/sign_in_usecase.dart';
import 'package:mynotes/features/feature/domain/usecases/sign_out_usecase.dart';
import 'package:mynotes/features/feature/domain/usecases/sign_up_usecase.dart';
import 'package:mynotes/features/feature/domain/usecases/update_note_usecase.dart';
import 'package:mynotes/features/feature/presentation/cubit/auth/auth_cubit.dart';
import 'package:mynotes/features/feature/presentation/cubit/note/note_cubit.dart';
import 'package:mynotes/features/feature/presentation/cubit/user/user_cubit.dart';

import 'features/feature/data/datasources/firebase_remote_data_source_impl.dart';

GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  // cubit/ bloc
  sl.registerFactory<AuthCubit>(() => AuthCubit(
      getCurrentUidUsecase: sl.call(),
      isSignInUseCase: sl.call(),
      signOutUseCase: sl.call()));
  sl.registerFactory<UserCubit>(() => UserCubit(
      getCreateCurrentUserUsecase: sl.call(),
      signInUseCase: sl.call(),
      signUpUseCase: sl.call()));
  sl.registerFactory<NoteCubit>(() => NoteCubit(
      addNewNoteUseCase: sl.call(),
      deleteNoteUseCase: sl.call(),
      getNotesUsecase: sl.call(),
      updateNoteUseCase: sl.call()));

  //usecase
  sl.registerLazySingleton<AddNewNoteUseCase>(
      () => AddNewNoteUseCase(repository: sl.call()));
  sl.registerLazySingleton<DeleteNoteUseCase>(
      () => DeleteNoteUseCase(repository: sl.call()));
  sl.registerLazySingleton<GetCreateCurrentUserUsecase>(
      () => GetCreateCurrentUserUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetCurrentUidUsecase>(
      () => GetCurrentUidUsecase(repository: sl.call()));
  sl.registerLazySingleton<GetNotesUsecase>(
      () => GetNotesUsecase(repository: sl.call()));
  sl.registerLazySingleton<IsSignInUseCase>(
      () => IsSignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignInUseCase>(
      () => SignInUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(repository: sl.call()));
  sl.registerLazySingleton<SignUpUseCase>(
      () => SignUpUseCase(repository: sl.call()));
  sl.registerLazySingleton<UpdateNoteUseCase>(
      () => UpdateNoteUseCase(repository: sl.call()));

//repository

  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  // data source
  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(auth: sl.call(), firestore: sl.call()));

  // External
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  sl.registerLazySingleton(() => auth);
  sl.registerLazySingleton(() => firestore);
}
