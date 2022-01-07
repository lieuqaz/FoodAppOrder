import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final bool obscureText;
  final TextEditingController controller;
  final String label;
  final String hinttext;

  TextFieldWidget({
    required this.obscureText,
    required this.controller,
    required this.label,
    required this.hinttext,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              obscureText: obscureText,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: hinttext,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              controller: controller,
            ),
          ],
        ),
      );
}
