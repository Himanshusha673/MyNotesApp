import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/features/feature/presentation/cubit/auth/auth_cubit.dart';
import 'package:mynotes/features/feature/presentation/cubit/note/note_cubit.dart';
import 'package:mynotes/features/feature/presentation/cubit/user/user_cubit.dart';
import 'package:mynotes/features/feature/presentation/pages/sign_in_page.dart';
import 'package:mynotes/injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/on_generate_route.dart';

import 'features/feature/presentation/pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await di.setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => di.sl<AuthCubit>()..appStarted(),
          child: Container(),
        ),
        BlocProvider<UserCubit>(
          create: (_) => di.sl<UserCubit>(),
          child: Container(),
        ),
        BlocProvider<NoteCubit>(
          create: (_) => di.sl<NoteCubit>(),
          child: Container(),
        ),
      ],
      child: MaterialApp(
        title: 'My Notes',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: OnGenerateRoute.route,
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return HomePage(
                    uid: authState.uid,
                  );
                }
                if (authState is UnAuthenticated) {
                  return SignInPage();
                }
                return Center(
                    child: Container(child: CircularProgressIndicator()));
              },
            );
          }
        },
      ),
    );
  }
}
