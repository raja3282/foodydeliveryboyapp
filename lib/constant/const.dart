import 'package:flutter/material.dart';

const Color red = Colors.red;
const Color white = Colors.white;
const Color black = Colors.black;
const Color grey = Colors.grey;

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff567777), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff567777), width: 2.5),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kMenu_BoxDecoration = BoxDecoration(color: white, boxShadow: [
  BoxShadow(
    color: Colors.black, //Color(0xffFFF2E1),
    offset: Offset(1, 1),
    blurRadius: 30.0,
  )
]);

InputDecoration buildInputDecoration(IconData icons, String hinttext) {
  return InputDecoration(
    hintText: hinttext,
    prefixIcon: Icon(icons),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.blue[900], width: 1.5),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.blue,
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.blue,
        width: 1.5,
      ),
    ),
  );
}

const kcolor = Color(0xffDF6756);
const kcolor1 = Color(0xffFFBE7C);
const kcolor4 = Color(0xffFEAD89);
const kcolor3 = Color(0xff2E8364);
const kcolor2 = Color(0xffFB8E7E);
const kcolor5 = Color(0xff41004D);

const kappbartext = Text(
  'FOODY',
  style: TextStyle(
    fontFamily: 'Pasifico',
    fontWeight: FontWeight.bold,
    fontSize: 25,
  ),
);
const kappbarstyle = TextStyle(
  fontFamily: 'Pasifico',
  fontWeight: FontWeight.w600,
  fontSize: 26,
);
