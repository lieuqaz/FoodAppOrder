// ignore_for_file: prefer_const_constructors, deprecated_member_use, unnecessary_new, await_only_futures, unused_import, unused_local_variable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthServices with ChangeNotifier {
  bool loading = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GlobalKey<ScaffoldState> globalKey = new GlobalKey<ScaffoldState>();
  Future signup(String email, String password) async {
    loading = true;
    try {
      UserCredential authResult = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(authResult.user!.uid)
          .set({
        "email": email,
        "userid": authResult.user!.uid,
        "image":
            "https://firebasestorage.googleapis.com/v0/b/dacn1-b0850.appspot.com/o/user%2Fprofile.jpg?alt=media&token=5389cfd2-6f57-43b1-ba66-d9eca846a474",
        "name": "null",
        "phone": "null",
        "address": "null",
      });
      User? user = authResult.user;
      loading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        globalKey.currentState!.showSnackBar(
          SnackBar(
            content: Text(
              "Mật khẩu quá yếu!",
            ),
          ),
        );
        loading = false;
      } else if (e.code == 'email-already-in-use') {
        globalKey.currentState!.showSnackBar(
          SnackBar(
            content: Text(
              "Tài khoản đã tồn tại!",
            ),
          ),
        );
        loading = false;
      }
    } catch (e) {
      globalKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      loading = false;
    }
    notifyListeners();
    // await FirebaseFirestore.instance
    //     .collection('userData')
    //     .doc(userCredential.user!.uid)
    //     .set({
    //   "firstName": firstName.text.trim(),
    //   "lastName": lastName.text.trim(),
    //   "email": email.text.trim(),
    //   "userid": userCredential.user!.uid,
    //   "password": password.text.trim(),
    // });
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => LoginPage()));
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     globalKey.currentState!.showSnackBar(
    //       SnackBar(
    //         content: Text(
    //           "Mật khẩu quá yếu!",
    //         ),
    //       ),
    //     );
    //     return;
    //   } else if (e.code == 'email-already-in-use') {
    //     globalKey.currentState!.showSnackBar(
    //       SnackBar(
    //         content: Text(
    //           "Tài khoản đã tồn tại!",
    //         ),
    //       ),
    //     );
    //   }
    // } catch (e) {
    //   globalKey.currentState!.showSnackBar(
    //     SnackBar(
    //       content: Text(e.toString()),
    //     ),
    //   );
    //   setState(() {
    //     loading = false;
    //   });
    // }
    // setState(() {
    //   loading = false;
    // });
  }

  Future login(String email, String password) async {
    UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User? user = authResult.user;
    loading = false;
    return user;
  }

  Future logout() async {
    await firebaseAuth.signOut;
  }

  Stream<User?> get user =>
      firebaseAuth.authStateChanges().map((event) => event);
}
