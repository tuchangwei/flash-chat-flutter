import 'package:flash_chat/components/kedboard_hide.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String kRoute = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return KeyboardHide(
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email',
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration,
                  obscureText: true,
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  color: Colors.lightBlueAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      AuthResult result = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email.trim(), password: password);
                      if (result.user != null) {
                        Navigator.of(context).pushNamed(ChatScreen.kRoute);
                      } else {
                        Fluttertoast.showToast(msg: "Unknown error");
                      }
                    } catch (e) {
                      print(e);
                      Fluttertoast.showToast(msg: "Error: $e");
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  },
                  text: 'Login',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
