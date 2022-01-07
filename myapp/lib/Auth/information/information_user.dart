// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Auth/information/change_pass.dart';
import 'package:myapp/Auth/information/edit_info.dart';
import 'package:path/path.dart' as Path;
import 'package:myapp/Baritem/profile/menu.dart';
import 'package:myapp/Baritem/profile/pic.dart';
import 'package:myapp/screen/home.dart';

class Information extends StatefulWidget {
  const Information({
    Key? key,
  }) : super(key: key);
  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  UploadTask? task;
  File? file;
  String? destination;
  String? filename;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
    uploadFile();
    sleep(Duration(seconds: 2));
    if (destination == null) return;
    String urlDownload;
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference image = storage.ref().child('user').child(filename!);
    urlDownload = await image.getDownloadURL();
    print("urrllllll" + urlDownload);
    CollectionReference user =
        FirebaseFirestore.instance.collection('userData');
    user.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'image': urlDownload,
    }, SetOptions(merge: true)).then((value) => print("Đã thêm"));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Information()));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = Path.basename(file!.path);
    filename = fileName;
    destination = 'user/$filename';
    task = FirebaseApi.uploadFile(destination!, file!);

    setState(() {});

    // FirebaseStorage storage = FirebaseStorage.instance;

    // String urlDownload = await storage.ref(destination).getDownloadURL();

    // print('Download-Link: $urlDownload');
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userData');
    String? email = FirebaseAuth.instance.currentUser!.email;
    String? iduser = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(
                Icons.vpn_key,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ChangePass()));
              })
        ],
        title: Text("Information"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Homep()));
          },
        ),
      ),
      body: FutureBuilder(
          future: users.doc(iduser).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map data = {};
              data = snapshot.data!.data() as Map;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Picture(
                        image: data['image'],
                        onTap: () {
                          selectFile();
                        },
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Text(
                            data['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          Text(data['email'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Button(
                        name: "Upgrade to Profile",
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => EditInfor(
                                        name: data['name'],
                                        address: data['address'],
                                        phone: data['phone'],
                                        image: data['image'],
                                      )));
                        },
                        color: Colors.red.shade200,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MenuIf(
                          title: "Address:",
                          name: data['address'],
                        ),
                        MenuIf(title: "Phone:", name: data['phone'])
                      ],
                    ),
                  ),
                ],
              );
            }
            return Text("");
          }),
    );
  }
}

class MenuIf extends StatelessWidget {
  final String title;
  final String name;
  const MenuIf({
    Key? key,
    required this.title,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 17),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          name,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        ),
      ],
    );
  }
}

class Button extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback onTap;
  const Button(
      {Key? key, required this.name, required this.onTap, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onTap,
      child: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 15),
      color: color,
      shape: StadiumBorder(),
    );
  }
}
