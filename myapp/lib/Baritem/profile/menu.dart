import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu(
      {Key? key, required this.name, required this.icon, required this.onTap})
      : super(key: key);
  final name, icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        color: Color(0xfff5f6f9),
        onPressed: onTap,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Icon(
              icon,
              size: 35,
              color: Colors.red,
            ),
            SizedBox(width: 20),
            Expanded(
                child: Text(
              name,
              style: TextStyle(fontSize: 20),
            )),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }
}
