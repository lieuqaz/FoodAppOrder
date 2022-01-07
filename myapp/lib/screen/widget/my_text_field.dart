// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  MyTextField({
    required this.hintText,
    required this.obscureText,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    final Icon icon;
    if (hintText == 'Email') {
      icon = Icon(
        Icons.mail,
        color: Colors.white,
      );
    } else {
      icon = Icon(Icons.vpn_key, color: Colors.white);
    }

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: (val) => val!.isNotEmpty ? null : "Vui lòng nhập " + hintText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          prefixIcon: icon,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
    );
  }
}
