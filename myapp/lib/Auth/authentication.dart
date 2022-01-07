import 'package:flutter/cupertino.dart';
import 'package:myapp/Auth/login_page.dart';
import 'package:myapp/Auth/signup_page.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool isToggle = false;
  void toggleScreen() {
    setState(() {
      isToggle = !isToggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isToggle) {
      return SignUp(toggleScreen: toggleScreen);
    } else {
      return LoginPage(toggleScreen: toggleScreen);
    }
  }
}
