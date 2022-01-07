// ignore_for_file: unused_import, unused_local_variable, prefer_const_constructors, curly_braces_in_flow_control_structures, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/Auth/authentication.dart';
import 'package:myapp/screen/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (FirebaseAuth.instance.currentUser != null) {
      return Homep();
    } else
      return Authentication();
  }
}
