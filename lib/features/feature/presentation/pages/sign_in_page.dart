import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/app_constant.dart';
import 'package:mynotes/features/feature/domain/entities/user_entity.dart';

import '../cubit/auth/auth_cubit.dart';
import '../cubit/user/user_cubit.dart';
import '../widgets/common.dart';
import 'homepage.dart';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldGLobalKey = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGLobalKey,
      body: BlocConsumer<UserCubit, UserState>(listener: (context, userState) {
        if (userState is UserSuccess) {
          BlocProvider.of<AuthCubit>(context).loggedIn();
        } else {
          if (userState is UserFailure) {
            snackBarError(
                msg: "invlid email", scaffoldState: _scaffoldGLobalKey);
          }
        }
      }, builder: (context, userState) {
        if (userState is UserSuccess) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return HomePage(
                  uid: authState.uid,
                );
              } else {
                return _bodyWidget();
              }
            },
          );
        }
        return CircularProgressIndicator();
      }),
    );
  }

  Widget _bodyWidget() {
    return Container(
      padding: EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
              height: 120,
              child: Image.asset(
                "assets/images/NoteBook.png",
                fit: BoxFit.cover,
              )),
          SizedBox(
            height: 40,
          ),
          Container(
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  hintText: "Enter your Email", border: InputBorder.none),
            ),
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(
            height: 40,
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
            onTap: submitSignIn(),
            child: Container(
              height: 45,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2,
              child: Text(
                'LogIn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              decoration: BoxDecoration(
                color: Colors.deepOrange.withOpacity(.8),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, PageConst.signUpPage, (route) => false);
            },
            child: Container(
              height: 45,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2,
              child: Text(
                'SignUp',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(.8),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  submitSignIn() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      BlocProvider.of<UserCubit>(context).submitSignIn(UserEntity(
          email: _emailController.text, password: _passwordController.text));
    }
  }
}
