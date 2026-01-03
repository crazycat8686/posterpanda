import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Upload extends StatefulWidget {
  final String uname;
  const Upload(this.uname, {super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final FirebaseFirestore fire = FirebaseFirestore.instance;
  final ImagePicker imgpicker = ImagePicker();
  File? img;
  String? pimg;
  TextEditingController tags = TextEditingController();
  TextEditingController name = TextEditingController();
  bool isowned = false;
  bool isl = false;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    pick();
  }

  Future<void> pick() async {
    final XFile? rim = await imgpicker.pickImage(source: ImageSource.gallery);
    print("image picked");
    if (rim != null) {
      setState(() {
        img = File(rim.path);
        pimg = rim.path;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "No image was selected !\n u will be taken back to account page.. u can upload from there ${widget.uname} ",
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> uptodio(String tags, String name) async {
    isl = true;
    FormData form = FormData.fromMap({
      'key': "aedf7fa63f799e1f95a7b7a4e3a742b9",
      'image': await MultipartFile.fromFile(pimg!),
    });
    try {
      Dio d = Dio();
      Response res = await d.post('https://api.imgbb.com/1/upload', data: form);
      print(
        "\n <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<",
      );
      print(res.data);
      print(
        "\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.",
      );
      if (res.data['status'] == 200) {
        print("upload succesfull");
        String url = res.data['data']['display_url'];
        await fbs(url, tags, name, isowned);

        setState(() {
          isl = false;
          img = null;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isl = false;
      });
    }
  }

  Future<void> fbs(String url, String tags, String nameofimg, bool iso) async {
    // await Firebase.initializeApp();

    final docref = await fire
        .collection('posterpanda')
        .doc(widget.uname)
        .collection('posts')
        .add({
          'url': url,
          'time': DateTime.now(),
          'likes': 0,
          'comments': [],
          'favedby': 0,
          'name': nameofimg,
          'picbyuser': iso,
        });
    fire.collection('gposts').add({
      'upby': widget.uname,
      'url': url,
      'time': DateTime.now(),
      'likes': 0,
      'comments': [],
      'favedby': 0,
      'name': nameofimg,
      'picbyuser': iso,
      'ref': docref.id,
    });
    print("upload successfull to firestore");
    Navigator.pop(context);
    print(docref.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: img != null
          ? Padding(
              padding: EdgeInsetsGeometry.all(15),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    Text(
                      "Fill in the below details to ensure proper uplaod",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 20),

                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(20),
                      child: Image(
                        image: FileImage(img!),
                        height: MediaQuery.of(context).size.height * 0.44,
                        width: MediaQuery.of(context).size.width * 0.44,
                      ),
                    ),
                    SizedBox(height: 20),

                    TextField(
                      controller: tags,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        label: Text("Tags"),
                        hint: Text("nature, dog, art .. etc"),
                      ),
                    ),
                    TextField(
                      controller: name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        label: Text("Name of the image"),
                        hint: Text("wt do u want this image to be called as??"),
                      ),
                    ),
                    Checkbox(
                      value: isowned,
                      onChanged: (_) => {
                        setState(() {
                          isowned = !isowned;
                          print("chechbox clicked");
                        }),
                      },
                      semanticLabel: "Did u take this picture?",
                    ),
                    SizedBox(height: 20),

                    tags.text != "" && name.text != ""
                        ? ElevatedButton(
                            onPressed: () => {uptodio(tags.text, name.text)},
                            child: Text("Upload"),
                          )
                        : Text(
                            "upload button will be activate upon fillling all requirements!",
                          ),
                  ],
                ),
              ),
            )
          : CircularProgressIndicator(),
    );
  }
}
