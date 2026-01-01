import 'package:posterpanda/upload.dart';

import 'display.dart';
import 'setup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(myapp());
}

class myapp extends StatefulWidget {
  const myapp({super.key});

  @override
  State<myapp> createState() => _myappState();
}

class _myappState extends State<myapp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "start",
      home: Display(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class loll extends StatefulWidget {
  final String? uname;
  const loll({super.key, this.uname});

  @override
  State<loll> createState() => _lollState();
}

class _lollState extends State<loll> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton.filled(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(Icons.door_back_door_sharp),
        ),
      ),
      // backgroundColor: const Color.fromARGB(136, 249, 245, 245),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Upload(widget.uname!)),
              ),
              child: Text("upload"),
            ),
            // ElevatedButton(
            //   onPressed: () => Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(builder: (_) => Setup()),
            //   ),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     children: [
            //       Icon(Icons.settings),
            //       Text("Change name/ reset app"),
            //     ],
            //   ),
            // ),
          ],
        ),
        //   child: image != null
        //       ? Center(
        //           child: isl
        //               ? SingleChildScrollView(
        //                   scrollDirection: Axis.vertical,
        //                   child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     children: [
        //                       CircularProgressIndicator(),
        //                       Text(
        //                         "Please wait the image is beinguploaded to the server!!!",
        //                       ),
        //                       Image.file(
        //                         image!,
        //                         width: MediaQuery.of(context).size.width * 0.45,
        //                         height: MediaQuery.of(context).size.height * 0.45,
        //                       ),
        //                     ],
        //                   ),
        //                 )
        //               : SingleChildScrollView(
        //                   // physics: BouncingScrollPhysics(),
        //                   scrollDirection: Axis.vertical,
        //                   child: Padding(
        //                     padding: const EdgeInsets.all(10.0),
        //                     child: Column(
        //                       // crossAxisAlignment: CrossAxisAlignment.start
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         ClipRRect(
        //                           borderRadius: BorderRadius.circular(20),
        //                           child: Image.file(
        //                             image!,
        //                             height:
        //                                 MediaQuery.of(context).size.height * 0.34,
        //                             width:
        //                                 MediaQuery.of(context).size.width * 0.34,
        //                           ),
        //                         ),

        //                         TextField(
        //                           controller: tags,
        //                           onSubmitted: (value) => {tags.clear()},

        //                           decoration: InputDecoration(
        //                             hint: Text("Dog, car etc"),

        //                             border: OutlineInputBorder(),
        //                             label: Text("Enter tags"),
        //                             fillColor: Colors.white,
        //                             focusColor: Colors.white,
        //                           ),
        //                         ),

        //                         ElevatedButton.icon(
        //                           onPressed: () => {
        //                             setState(() {
        //                               image = null;
        //                             }),
        //                           },
        //                           label: Text("Cancel"),
        //                         ),
        //                         tags.text != ""
        //                             ? ElevatedButton.icon(
        //                                 icon: Icon(Icons.upload_file_rounded),
        //                                 onPressed: () => {
        //                                   setState(() {
        //                                     imghand(tags.text);
        //                                   }),
        //                                 },
        //                                 label: Text("upload!"),
        //                               )
        //                             : Text(
        //                                 "Pls enter the fucking tags we need em!!!! or  no upload for u ${widget.uname}",
        //                               ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //         )
        //       : Column(
        //           children: [
        //             ElevatedButton(
        //               onPressed: () => {pick(), print("pick1")},
        //               child: Text("Please upload "),
        //             ),
        //           ],
        //         ),
      ),
    );
  }
}
