//ignore_for_file: unused_import, use_key_in_widget_constructors, unnecessary_new, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Auth/auth_services.dart';
import 'package:myapp/Auth/information/change_pass.dart';
import 'package:myapp/Auth/information/edit_info.dart';
import 'package:myapp/Auth/information/information_user.dart';
import 'package:myapp/Baritem/home.dart';
import 'package:myapp/provider/my_provider.dart';
import 'package:myapp/screen/home.dart';
import 'package:myapp/screen/rating_page.dart';
import 'package:myapp/screen/widget/Item_rating.dart';
import 'package:myapp/wrapper.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _init = Firebase.initializeApp();
    return FutureBuilder(
        future: _init,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(home: Splash());
          }
          if (snapshot.hasData) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => MyProvider(),
                ),
                ChangeNotifierProvider.value(value: AuthServices()),
                StreamProvider<User?>.value(
                    value: AuthServices().user, initialData: null)
              ],
              child: new MaterialApp(
                theme: ThemeData(primarySwatch: Colors.red),
                debugShowCheckedModeBanner: false,
                home: Wrapper(),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}

class ErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [Icon(Icons.error), Text("Something went wrong!")],
        ),
      ),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor:
          lightMode ? const Color(0xffffffff) : const Color(0xffffffff),
      body: Center(
          child: lightMode
              ? Image.asset('images/logo.jpg')
              : Image.asset('images/background.jpg')),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
