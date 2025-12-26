import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final uname = pref.getString('name');
  if (uname != null || uname != "") {
    runApp(loll());
  } else {
    runApp(Setup());
  }
}

class loll extends StatefulWidget {
  const loll({super.key});

  @override
  State<loll> createState() => _lollState();
}

class _lollState extends State<loll> {
  final ImagePicker picker = ImagePicker();
  File? image;
  String? pimg;
  bool isl = false;
  bool vis = false;
  Future<void> pick() async {
    final XFile? resim = await picker.pickImage(source: ImageSource.gallery);
    if (resim != null) {
      setState(() {
        pimg = resim.path;
        image = File(resim.path);
        // imghand();
      });
    } else {
      setState(() {
        vis = true;
      });
    }
  }

  Future<void> imghand() async {
    isl = true;
    FormData form = FormData.fromMap({
      'key': "aedf7fa63f799e1f95a7b7a4e3a742b9",
      'image': await MultipartFile.fromFile(pimg!),
    });
    try {
      Dio d = Dio();
      Response res = await d.post('https://api.imgbb.com/1/upload', data: form);
      print(res.data);
      if (res.data['status'] == 200) {
        print("upload succesfull");
        String ur = res.data['data']['display_url'];
        setState(() {
          isl = false;
          image = null;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isl = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PosterPanda",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(136, 249, 245, 245),
        body: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: image != null
              ? Center(
                  child: isl
                      ? Column(
                          children: [
                            CircularProgressIndicator(),
                            Text("Please wai"),
                            Image.file(image!),
                          ],
                        )
                      : Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(20),
                              child: Image.file(
                                image!,
                                height: 200,
                                width: 200,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => {
                                setState(() {
                                  image = null;
                                }),
                              },
                              label: Text("Cancel"),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => {
                                setState(() {
                                  imghand();
                                }),
                              },
                              label: Text("upload"),
                            ),
                          ],
                        ),
                )
              : ElevatedButton(
                  onPressed: () => {pick(), print("pick1")},
                  child: Text("Please upload"),
                ),
        ),
      ),
    );
  }
}
