import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Authentication with ChangeNotifier {
  String uid;
  String get getUid => uid;
  final db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  DocumentSnapshot snapshot;
  Future loginIntoAccount(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = userCredential.user;
    uid = user.uid;
    print('This is user uid => $getUid');
    notifyListeners();
  }

  Future creteNewAccount(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = userCredential.user;
    uid = user.uid;
    print('This is user uid => $getUid');
    notifyListeners();
  }

  createUserRecord(email, name, password) {
    try {
      db.collection('boy').doc(email).set({
        'name': name,
        'email': email,
        'password': password,
        'address':
            'Chakwal - Jehlum Road, Dhoke Amb Muhri Rajgan, Jhelum, Punjab, Pakistan',
        'imageUrl':
            'https://firebasestorage.googleapis.com/v0/b/foodyfyp.appspot.com/o/images%2Fboy.jpg?alt=media&token=fd9c3a74-13ea-439c-9d01-ad96b132ec63',
        'mobile': '03432370073',
        'location': '[33.0998° N, 73.2920° E]'
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<DocumentSnapshot> getUsereDtails() async {
    DocumentSnapshot result =
        await db.collection('boy').doc(_auth.currentUser.email).get();
    this.snapshot = result;
    notifyListeners();

    return result;
  }
}
