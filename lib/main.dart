import 'dart:io';
import 'display.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences pref = await SharedPreferences.getInstance();
  String? uname = pref.getString('name');
  print(uname);
  if (uname != null && uname != "") {
    runApp(Display(uname));
  } else {
    runApp(myapp(uname!));
  }
}

class myapp extends StatelessWidget {
  final String uname;
  const myapp(this.uname, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: loll(uname), debugShowCheckedModeBanner: false);
  }
}

class loll extends StatefulWidget {
  final String uname;
  const loll(this.uname, {super.key});

  @override
  State<loll> createState() => _lollState();
}

class _lollState extends State<loll> {
  final FirebaseFirestore fire = FirebaseFirestore.instance;
  final ImagePicker picker = ImagePicker();
  File? image;
  String? pimg;
  bool isl = false;
  bool vis = false;

  TextEditingController tags = TextEditingController();
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

  Future<void> imghand(String tags) async {
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
        String url = res.data['data']['display_url'];
        await stof(url, tags);

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

  Future<void> stof(String url, String tags) async {
    await fire.collection('pandaimg').doc(widget.uname).set({
      'tags': tags.split(' ').toList(),
      'url': url,
      'time': DateTime.now(),
      'likes': 0,
      'comments': [],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(136, 249, 245, 245),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: image != null
            ? Center(
                child: isl
                    ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            Text(
                              "Please wait the image is beinguploaded to the server!!!",
                            ),
                            Image.file(image!),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                image!,
                                height:
                                    MediaQuery.of(context).size.height * 0.34,
                                width: MediaQuery.of(context).size.width * 0.34,
                              ),
                            ),
                            SizedBox(height: 20),

                            TextField(
                              controller: tags,
                              onSubmitted: (value) => {tags.clear()},

                              decoration: InputDecoration(
                                hint: Text("Dog, car etc"),

                                border: OutlineInputBorder(),
                                label: Text("Enter tags"),
                                fillColor: Colors.white,
                                focusColor: Colors.white,
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
                            tags.text != ""
                                ? ElevatedButton.icon(
                                    icon: Icon(Icons.upload_file_rounded),
                                    onPressed: () => {
                                      setState(() {
                                        imghand(tags.text);
                                      }),
                                    },
                                    label: Text("upload!"),
                                  )
                                : Text(
                                    "Pls enter the fucking tags then, or else no upload for u dumbass ${widget.uname}",
                                  ),
                          ],
                        ),
                      ),
              )
            : Column(
                children: [
                  ElevatedButton(
                    onPressed: () => {pick(), print("pick1")},
                    child: Text("Please upload"),
                  ),
                ],
              ),
      ),
    );
  }
}
