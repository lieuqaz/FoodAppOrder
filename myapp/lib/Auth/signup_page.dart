// ignore_for_file: prefer_const_constructors, deprecated_member_use, unnecessary_null_comparison, avoid_print, sized_box_for_whitespace, unused_import, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unnecessary_new

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Auth/auth_services.dart';
import 'package:myapp/screen/widget/my_text_field.dart';

import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  final Function toggleScreen;
  SignUp({required this.toggleScreen});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  RegExp regExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  GlobalKey<FormState> gl = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> globalKey = new GlobalKey<ScaffoldState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Future sendData() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(userCredential.user!.uid)
          .set({
        "email": email.text.trim(),
        "userid": userCredential.user!.uid,
        "password": password.text.trim(),
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        globalKey.currentState!.showSnackBar(
          SnackBar(
            content: Text("The password provided is too weak."),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        globalKey.currentState!.showSnackBar(
          SnackBar(
            content: Text("The account already exists for that email"),
          ),
        );
      }
    } catch (e) {
      globalKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Error"),
        ),
      );
      setState(() {
        loading = false;
      });
    }
    setState(() {
      loading = false;
    });
  }

  void validation() {
    if (email.text.trim().isEmpty || email.text.trim() == null) {
      globalKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(
            "Email is Empty",
          ),
        ),
      );
      return;
    } else if (!regExp.hasMatch(email.text)) {
      globalKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(
            "Please enter vaild Email",
          ),
        ),
      );
      return;
    }
    if (password.text.trim().isEmpty || password.text.trim() == null) {
      globalKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(
            "Password is Empty",
          ),
        ),
      );
      return;
    } else {
      setState(() {
        loading = true;
      });
      sendData();
    }
  }

  // Widget button({
  //   required String buttonName,
  //   required Color color,
  //   required Color textColor,
  //   required VoidCallback ontap,
  // }) {
  //   return Container(
  //     width: double.infinity,
  //     child: RaisedButton(
  //       color: color,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(30),
  //       ),
  //       child: Text(
  //         buttonName,
  //         style: TextStyle(fontSize: 20, color: textColor),
  //       ),
  //       onPressed: ontap,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: globalKey,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Đăng Ký",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextField(
                    obscureText: false,
                    hintText: "Email",
                    controller: email,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MyTextField(
                    obscureText: true,
                    hintText: "Mật khẩu",
                    controller: password,
                  )
                ],
              ),
              Container(
                width: loading ? null : double.infinity,
                height: 50,
                child: RaisedButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () async {
                    await loginProvider.signup(
                        email.text.trim(), password.text.trim());
                  },
                  child: loading
                      ? CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          "Đăng Ký",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    "Đã có tài khoản ? ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                      onPressed: () => widget.toggleScreen(),
                      child: Text(
                        "Đăng nhập",
                        style: TextStyle(color: Colors.red),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
