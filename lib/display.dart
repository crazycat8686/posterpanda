import 'package:flutter/material.dart';
import 'main.dart';
import 'setup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Display extends StatefulWidget {
  final String? uname;
  const Display({this.uname, super.key});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    checkuser();
    print(uname);
  }

  String? uname;

  Future<void> checkuser() async {
    if (uname != null && uname != "") {
      print("uname is passed.... Skipping func with $uname");
    } else {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      String? usname = pref.getString('name');
      print("extracted user name is $usname");

      if (usname != null && usname != "") {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (_) => Setup()),
        // );
        setState(() {
          uname = usname;
          print(" user name is set to  $uname <><><><><><><><><><><>");
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Setup()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => loll(uname: uname)),
              ),
            },
            icon: Icon(Icons.account_circle_rounded),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('gposts')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No posts yet"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(30),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(20),
                    child: Image.network(
                      data['url'],
                      width: MediaQuery.of(context).size.width * 0.34,
                      height: MediaQuery.of(context).size.height * 0.34,
                    ),
                  ),
                  Text(
                    data['name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("Posted by: ${data['owner']}"),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
