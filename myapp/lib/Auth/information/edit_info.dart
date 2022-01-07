import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Auth/information/camera.dart';
import 'package:myapp/Auth/information/change_pass.dart';
import 'package:myapp/Auth/information/information_user.dart';
import 'package:myapp/Auth/information/textfield.dart';
import 'package:myapp/Baritem/profile/pic.dart';
import 'package:myapp/provider/my_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;

class EditInfor extends StatefulWidget {
  final String name;
  final String image;
  final String address;
  final String phone;
  const EditInfor(
      {Key? key,
      required this.image,
      required this.name,
      required this.address,
      required this.phone})
      : super(key: key);

  @override
  _EditInforState createState() => _EditInforState();
}

class _EditInforState extends State<EditInfor> {
  UploadTask? task;
  File? file;
  String? destination;
  String? filename;

  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _address = TextEditingController();
  String date = TimeOfDay.now().toString();
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

  Future<void> _showChoiceDialog(BuildContext context) {
    final fileName =
        file != null ? Path.basename(file!.path) : 'No File Selected';
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      selectFile();
                    },
                    title: Text("Select File"),
                    leading: Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  Text(
                    fileName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  ListTile(
                    onTap: () {},
                    title: Text("Upload file"),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final filename = file != null ? Path.basename(file!.path) : "No File";

    MyProvider provider = Provider.of<MyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Information"),
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ChangePass()));
              },
              icon: Icon(Icons.vpn_key))
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        children: [
          Picture(
            image: widget.image,
            onTap: () {
              selectFile();
              // print(url);
              // if (url != null) {
              //   provider.ChangeImage(url);
              // }
            },
          ),
          const SizedBox(
            height: 24,
          ),
          TextFieldWidget(
            obscureText: false,
            controller: _name,
            label: "Fullname",
            hinttext: widget.name,
          ),
          TextFieldWidget(
            obscureText: false,
            controller: _address,
            label: "Address",
            hinttext: widget.address,
          ),
          TextFieldWidget(
            obscureText: false,
            controller: _phone,
            label: "Phone",
            hinttext: widget.phone,
          ),
          SizedBox(
            height: 20,
          ),
          Button(
              name: "Save",
              onTap: () {
                print(_name.text.trim());
                provider.ChangeInfor(_name.text, _phone.text, _address.text);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Thay đổi thông tin thành công")));
              },
              color: Colors.red.shade200)
        ],
      ),
    );
  }
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
