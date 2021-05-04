import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/Cv/AndroidStudioProjects/foody/lib/user/helper/screen_navigation.dart';
import 'package:foody_delivery_boy_app/constant/const.dart';
import 'package:foody_delivery_boy_app/helper/roundedButton.dart';
import 'package:foody_delivery_boy_app/login/login.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kcolor2,
        title: Text(
          'Forgotten Screen',
          style: kappbarstyle,
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                Text(
                  'We will send you a link ... Please click on that link to reset your password.',
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter an Email';
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return 'Please enter valid Email';
                      } else {
                        email = value;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      prefixIcon: Icon(Icons.email),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            BorderSide(color: Colors.blue[900], width: 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RoundedButton(
                    color: kcolor2,
                    title: 'Send Email',
                    onPressed: () {
                      if (formkey.currentState.validate()) {
                        FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email);
                        changeScreen(context, Login());
                      } else {
                        return null;
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
