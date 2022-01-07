import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Auth/information/information_user.dart';
import 'package:myapp/Baritem/profile/menu.dart';
import 'package:myapp/modle/user_modle.dart';
import 'package:myapp/provider/my_provider.dart';
import 'package:myapp/wrapper.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widget Myprofile(
      {required String name, required VoidCallback onTap, required icon}) {
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

  List<UserModle> user = [];
  @override
  Widget build(BuildContext context) {
    MyProvider provider = Provider.of<MyProvider>(context);
    provider.UserInfor();
    user = provider.Userinfo;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(
            child: Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        )),
      ),
      body: Column(
        children: [
          Menu(
            icon: Icons.person,
            name: "My Profile",
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Information()));
            },
          ),
          Menu(
            icon: Icons.notifications_outlined,
            name: "Notification",
            onTap: () {},
          ),
          Menu(
            icon: Icons.settings_outlined,
            name: "Settings",
            onTap: () {},
          ),
          Menu(
              icon: Icons.logout_outlined,
              name: "Log Out",
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Wrapper()));
              })
        ],
      ),
    );
  }
}
