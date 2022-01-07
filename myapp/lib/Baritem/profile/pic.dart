import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Picture extends StatelessWidget {
  final VoidCallback onTap;
  final String image;
  const Picture({Key? key, required this.image, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Center(
          child: SizedBox(
            height: 115,
            width: 115,
            child: Stack(
              fit: StackFit.expand,
              overflow: Overflow.visible,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(image),
                ),
                Positioned(
                  right: -10,
                  bottom: 0,
                  child: SizedBox(
                    width: 46,
                    height: 46,
                    child: MaterialButton(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: Colors.white)),
                      color: Color(0xfff5f6f9),
                      onPressed: onTap,
                      child: Icon(Icons.camera_alt_outlined),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
