import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foody_delivery_boy_app/constant/const.dart';
import 'package:foody_delivery_boy_app/helper/roundedButton.dart';
import 'package:foody_delivery_boy_app/helper/screen_navigation.dart';
import 'package:foody_delivery_boy_app/login/ForgotScreen.dart';
import 'package:foody_delivery_boy_app/providers/auth.dart';
import 'package:foody_delivery_boy_app/screens/orders.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          child: Form(
            key: formkey,
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 12, left: 6, right: 6),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    validator: (String value) {
                      email = value;
                      if (value.isEmpty) {
                        return 'Please Enter an Email';
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return 'Please enter a valid Email';
                      }
                      return null;
                    },
                    decoration: buildInputDecoration(Icons.email, "Email"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: TextFormField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    validator: (String value) {
                      password = value;
                      if (value.isEmpty) {
                        return 'Please a Enter Password';
                      }

                      return null;
                    },
                    decoration:
                        buildInputDecoration(Icons.lock, "Enter Password"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Container(
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        changeScreenReplacement(context, ForgotScreen());
                        setState(() {});
                      },
                      child: Text(
                        "Forgot Password ?",
                        style: TextStyle(color: Colors.blue[500]),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  title: 'Login',
                  color: kcolor2,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    if (formkey.currentState.validate()) {
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (user != null) {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: MyOrders(),
                                  type:
                                      PageTransitionType.leftToRightWithFade));
                          showSpinner = false;
                        }
                      } catch (e) {
                        setState(() {
                          showSpinner = false;
                        });
                        print(e);
                        Toast.show(e.message, context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                      }
                    } else {
                      showSpinner = false;
                      return null;
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
