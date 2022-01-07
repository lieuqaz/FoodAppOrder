import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Auth/information/information_user.dart';
import 'package:myapp/Auth/information/textfield.dart';
import 'package:myapp/wrapper.dart';

class ChangePass extends StatefulWidget {
  ChangePass({Key? key}) : super(key: key);

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  late SnackBar snack;
  bool isChecked = false;
  TextEditingController newPassword = TextEditingController();

  TextEditingController newPassword1 = TextEditingController();
  TextEditingController currentPassword = TextEditingController();

  GlobalKey<FormState> gl = GlobalKey<FormState>();

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  void _changePassword(String currentPassword, String newPassword) async {
    final user = await FirebaseAuth.instance.currentUser!;
    final cred = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Thay đổi thông tin thành công")));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Thay đổi thông tin thất bại")));
      });
    }).catchError((err) {});
  }

  @override
  Widget build(BuildContext context) {
    bool ob = true;
    if (isChecked == true) {
      ob = false;
    } else
      ob = true;
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Password"),
        backgroundColor: Colors.red.shade400,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Information()));
            }),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "Update Password",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          TextFieldWidget(
              obscureText: ob,
              controller: currentPassword,
              label: "Password",
              hinttext: "Password"),
          SizedBox(
            height: 10,
          ),
          TextFieldWidget(
              obscureText: ob,
              controller: newPassword,
              label: "New Password",
              hinttext: "New Password"),
          SizedBox(
            height: 20,
          ),
          TextFieldWidget(
              obscureText: ob,
              controller: newPassword1,
              label: "Comfirm Password",
              hinttext: "Comfirm Password"),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                checkColor: Colors.black,
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text("Hiển thị mật khẩu"),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Button(
              name: "Update",
              onTap: () async {
                if (newPassword.text.trim() == newPassword1.text.trim()) {
                  _changePassword(currentPassword.text, newPassword.text);
                }
              },
              color: Colors.red.shade300)
        ],
      ),
    );
  }
}
