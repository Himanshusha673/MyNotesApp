import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/app_constant.dart';
import 'package:mynotes/features/feature/domain/entities/user_entity.dart';
import 'package:mynotes/features/feature/presentation/cubit/auth/auth_cubit.dart';
import 'package:mynotes/features/feature/presentation/pages/homepage.dart';
import 'package:mynotes/features/feature/presentation/pages/sign_in_page.dart';
import 'package:mynotes/features/feature/presentation/widgets/common.dart';

import '../cubit/user/user_cubit.dart';

class SignUpaPage extends StatefulWidget {
  const SignUpaPage({Key? key}) : super(key: key);

  @override
  State<SignUpaPage> createState() => _SignUpaPageState();
}

class _SignUpaPageState extends State<SignUpaPage> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: BlocConsumer<UserCubit, UserState>(listener: (context, userState) {
        if (userState is UserSuccess) {
          BlocProvider.of<AuthCubit>(context).loggedIn();
        }
        if (userState is UserFailure) {
          snackBarError(msg: "invlid email", scaffoldState: _globalKey);
        }
      }, builder: (context, userState) {
        if (userState is UserSuccess) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return HomePage(uid: authState.uid);
              } else {
                return bodyWidget();
              }
            },
          );
        }
        return bodyWidget();
      }),
    );
  }

  bodyWidget() {
    return Container(
      padding: EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 35,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, PageConst.signInPage, (route) => false);
            },
            child: Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withOpacity(.6)),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            child: TextField(
              controller: _userNameController,
              decoration: InputDecoration(
                  hintText: "Enter your username", border: InputBorder.none),
            ),
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  hintText: "Enter your email", border: InputBorder.none),
            ),
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Enter your Password", border: InputBorder.none),
            ),
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              submitSignUpthis();
            },
            child: Container(
              height: 45,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2,
              child: Text(
                'Create New Account',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              decoration: BoxDecoration(
                color: Colors.deepOrange.withOpacity(.8),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void submitSignUpthis() {
    if (_userNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      BlocProvider.of<UserCubit>(context).submitSignUp(UserEntity(
          email: _emailController.text, password: _passwordController.text));
    }
  }
}
