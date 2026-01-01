import 'dart:async';

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
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('gposts')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (!snap.hasData || snap.data!.docs.isEmpty) {
              return Center(child: Text("No posts yet $uname"));
            }
            //write null cases later
            final res = snap.data!.docs;
            return Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 20,
                  // childAspectRatio: 0.5,
                ),
                itemCount: res.length,
                itemBuilder: (context, index) {
                  final data = res[index].data() as Map<String, dynamic>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(20),
                        child: Image(
                          image: NetworkImage(data['url']),
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.4,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),

      // body: StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseFirestore.instance
      //       .collection('gposts')
      //       .orderBy('time', descending: true)
      //       .snapshots(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     }

      //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      //       return Center(child: Text("No posts yet"));
      //     }

      //     final docs = snapshot.data!.docs;

      //     return ListView.builder(
      //       padding: EdgeInsets.all(30),
      //       itemCount: docs.length,
      //       itemBuilder: (context, index) {
      //         final data = docs[index].data() as Map<String, dynamic>;

      //         return Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Container(
      //               padding: EdgeInsets.all(7),
      //               decoration: BoxDecoration(
      //                 color: Colors.transparent,
      //                 borderRadius: BorderRadius.circular(9),
      //                 boxShadow: [
      //                   BoxShadow(
      //                     offset: Offset(1, 2),
      //                     color: Colors.pink[200]!,
      //                   ),
      //                 ],
      //               ),
      //               child: ClipRRect(
      //                 borderRadius: BorderRadiusGeometry.circular(20),
      //                 child: Image.network(
      //                   data['url'],
      //                   width: MediaQuery.of(context).size.width * 0.34,
      //                   height: MediaQuery.of(context).size.height * 0.34,
      //                 ),
      //               ),
      //             ),
      //             Text(
      //               data['name'],
      //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //             ),
      //             Row(
      //               children: [
      //                 Icon(Icons.favorite_border, color: Colors.red),
      //                 Text(data['likes'].toString()),
      //               ],
      //             ),
      //           ],
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
