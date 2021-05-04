import 'package:flutter/material.dart';
import 'package:foody_delivery_boy_app/constant/const.dart';
import 'package:foody_delivery_boy_app/helper/roundedButton.dart';
import 'package:foody_delivery_boy_app/providers/auth.dart';
import 'package:foody_delivery_boy_app/screens/orders.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool showSpinner = false;
  String name, email;
  String password;
  // ignore: non_constant_identifier_names
  String confirm_password;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formkey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 180.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 6, right: 6),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  decoration: buildInputDecoration(Icons.person, "User Name"),
                  validator: (String value) {
                    name = value;
                    if (value.isEmpty) {
                      return 'Please Enter name';
                    }

                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 6, right: 6),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  decoration:
                      buildInputDecoration(Icons.email, "Email Address"),
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 6, right: 6),
                child: TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  textAlign: TextAlign.center,
                  decoration: buildInputDecoration(Icons.lock, "Password"),
                  validator: (String value) {
                    password = value;
                    if (password.length < 6) {
                      return 'Password must be atleast 6 characters';
                    }
                    if (value.isEmpty) {
                      return 'Please a Enter Password';
                    }

                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6, right: 6),
                child: TextFormField(
                  // obscureText: true,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration:
                      buildInputDecoration(Icons.lock, "Confirm Password"),
                  validator: (String value) {
                    confirm_password = value;
                    if (value.isEmpty) {
                      return 'Please re-enter password';
                    }

                    if (password != confirm_password) {
                      return "Password does not match";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'SignUp',
                color: kcolor2,
                onPressed: () {
                  setState(() {});
                  if (formkey.currentState.validate()) {
                    try {
                      Provider.of<Authentication>(context, listen: false)
                          .creteNewAccount(email, password.toString())
                          .whenComplete(() {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: Orders(),
                                type: PageTransitionType.leftToRightWithFade));
                      });
                      Provider.of<Authentication>(context, listen: false)
                          .createUserRecord(email, name, password);
                    } catch (e) {
                      print(e);
                      Toast.show(e.message, context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                    }
                  } else {
                    return null;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
