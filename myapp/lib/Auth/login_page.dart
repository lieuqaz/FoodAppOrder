// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, deprecated_member_use, unused_import, unnecessary_new, sized_box_for_whitespace

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Auth/auth_services.dart';
import 'package:myapp/Screen/widget/my_text_field.dart';
import 'package:myapp/Auth/signup_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Function toggleScreen;
  const LoginPage({Key? key, required this.toggleScreen}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  RegExp regExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  bool loading = false;
  late UserCredential userCredential;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> gl = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  Future loginAuth() async {
    try {
      // ignore: unused_local_variable
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        globalKey.currentState!.showSnackBar(
          SnackBar(
            content: Text('Tài khoản không tồn tại!'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        globalKey.currentState!.showSnackBar(
          SnackBar(
            content: Text('Mật khẩu sai!'),
          ),
        );
      } else {
        setState(() {
          loading = false;
        });
      }

      setState(() {
        loading = false;
      });
    }
  }

  void validation() {
    if (email.text.trim().isEmpty ||
        email.text.trim() == null && password.text.trim().isEmpty ||
        password.text.trim() == null) {
      globalKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Xin nhập đầy đủ thông tin!"),
        ),
      );
    } else if (email.text.trim().isEmpty ||
        email.text.trim() == null && password.text.trim().isEmpty ||
        password.text.trim() == null) {
      globalKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Vui lòng nhập đầy đủ thông tin!"),
        ),
      );
    } else if (email.text.trim().isEmpty || email.text.trim() == null) {
      globalKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(
            "Vui lòng nhập Email!",
          ),
        ),
      );
      return;
    } else if (!regExp.hasMatch(email.text)) {
      globalKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(
            "Email không đúng!",
          ),
        ),
      );
      return;
    }
    if (password.text.trim().isEmpty || password.text.trim() == null) {
      globalKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text(
            "Vui lòng nhập mật khẩu!",
          ),
        ),
      );
      return;
    } else {
      setState(() {
        loading = true;
      });
      loginAuth();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.black,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Đăng Nhập",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTextField(
                  controller: email,
                  hintText: "Email",
                  obscureText: false,
                ),
                SizedBox(
                  height: 30,
                ),
                MyTextField(
                  hintText: "Mật khẩu",
                  obscureText: true,
                  controller: password,
                ),
              ],
            ),
            Container(
              height: 50,
              child: MaterialButton(
                color: Colors.red,
                minWidth: loading ? null : double.infinity,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () async {
                  validation();
                  // await loginProvider.login(
                  //     email.text.trim(), password.text.trim());
                },
                child: loading
                    ? CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        "Đăng Nhập",
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
                  "Người dùng mới? ",
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                    onPressed: () => widget.toggleScreen(),
                    child: Text(
                      "Đăng ký ngay",
                      style: TextStyle(color: Colors.red),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
