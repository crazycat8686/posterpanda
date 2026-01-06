import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'setup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_manager_plus/wallpaper_manager_plus.dart';
import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Display extends StatefulWidget {
  final String? uname;
  const Display({this.uname, super.key});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  final FirebaseFirestore fire = FirebaseFirestore.instance;
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    checkuser();
    print(uname);
  }

  String? uname;
  bool liked = false;

  bool wall = false;
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

  Future<void> like(String id) async {
    await fire.collection('gposts').doc(id).update({
      'likes': FieldValue.increment(1),
    });
  }

  // Future<void> likedec(String id) async {
  //   await fire.collection('gposts').doc(id).update({
  //     'likes': FieldValue.increment(value),
  //   });
  //   // }

  Future<void> wallp(String url, String name) async {
    wall = true;
    File img = await DefaultCacheManager().getSingleFile(url);

    try {
      final res = await WallpaperManagerPlus().setWallpaper(
        img,
        WallpaperManagerPlus.homeScreen,
      );
      print("res is $res");
      if (res == "Wallpaper set successfully") {
        setState(() {
          wall = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> wallpl(String url, String name) async {
    wall = true;
    File img = await DefaultCacheManager().getSingleFile(url);

    try {
      final res = await WallpaperManagerPlus().setWallpaper(
        img,
        WallpaperManagerPlus.lockScreen,
      );
      print("res is $res");
      if (res == "Wallpaper set successfully") {
        setState(() {
          wall = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,

      // bottomNavigationBar: BottomNavigationBar(items: ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Poster.panda",
          style: TextStyle(
            fontFamily: 'Bau',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('gposts')
                .orderBy('time')
                .snapshots(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (!snap.hasData || snap.data == null) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                    backgroundColor: Colors.green,
                  ),
                );
              }
              var data = snap.data!.docs;
              if (data.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      Text("No data!! why dont u upload ${uname}???"),
                    ],
                  ),
                );
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.6,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var element = data[index].data() as Map<String, dynamic>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => {
                            print(data[index].reference.id),
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         MyWidget(data[index].reference.id),
                            //   ),
                            // ),
                            showModalBottomSheet(
                              // backgroundColor: const Color.fromARGB(
                              //   255,
                              //   255,
                              //   255,
                              //   255,
                              // ),
                              isScrollControlled: true,
                              // scrollControlDisabledMaxHeightRatio: ,
                              showDragHandle: true,
                              context: context,
                              builder: (context) {
                                return DraggableScrollableSheet(
                                  expand: false,
                                  minChildSize: 0.4,
                                  maxChildSize: 0.85,
                                  initialChildSize: 0.6,
                                  builder: (context, ScrollController) {
                                    return SingleChildScrollView(
                                      controller: ScrollController,
                                      child: wall
                                          ? CircularProgressIndicator()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    5.0,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 19),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            element['name'],
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Lexend',
                                                              fontSize: 38,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                            ),
                                                          ),
                                                          // SizedBox(height: 10),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'by',
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                      'Lexend',
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 4,
                                                              ),
                                                              Text(
                                                                element['upby'],
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                      'Lexend',
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Center(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadiusGeometry.circular(
                                                          13,
                                                        ),
                                                    child: Image(
                                                      image: NetworkImage(
                                                        element['url'],
                                                      ),
                                                      fit: BoxFit.cover,
                                                      height:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.height *
                                                          0.6,
                                                      width:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.9,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Center(
                                                  child: Column(
                                                    children: [
                                                      ElevatedButton(
                                                        onPressed: () => {
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            SnackBar(
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadiusGeometry.circular(
                                                                      12,
                                                                    ),
                                                              ),
                                                              content: Text(
                                                                "Okay chill ${element['name']} is set as wallpaper",
                                                              ),
                                                            ),
                                                          ),
                                                          wallp(
                                                            element['url'],
                                                            element['name'],
                                                          ),
                                                        },
                                                        child: Text(
                                                          "Set as Home Wallpaper",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Lexend',
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () => {
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            SnackBar(
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadiusGeometry.circular(
                                                                      12,
                                                                    ),
                                                              ),
                                                              content: Text(
                                                                "Okay chill ${element['name']} is set as wallpaper for lock screen",
                                                              ),
                                                            ),
                                                          ),
                                                          wallpl(
                                                            element['url'],
                                                            element['name'],
                                                          ),
                                                        },
                                                        child: Text(
                                                          "Set as Lock Screen Wallpaper",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Lexend',
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                    );
                                  },
                                );
                              },
                            ),
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(element['url']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ' ${element['name']}',
                            style: TextStyle(
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              !liked
                                  ? IconButton(
                                      onPressed: () async {
                                        print(liked);

                                        await fire
                                            .collection('gposts')
                                            .doc('${data[index].reference.id}')
                                            .update({
                                              'likes': FieldValue.increment(1),
                                            });
                                        setState(() {
                                          liked = true;
                                        });
                                        print(liked);
                                      },
                                      icon: Icon(
                                        Icons.favorite,
                                        color: Colors.pink[200],
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () async {
                                        print(liked);

                                        await fire
                                            .collection('gposts')
                                            .doc('${data[index].reference.id}')
                                            .update({
                                              'likes': FieldValue.increment(-1),
                                            });
                                        setState(() {
                                          liked = false;
                                        });
                                        print(liked);
                                      },
                                      icon: Icon(Icons.favorite_border),
                                    ),
                              Text(element['likes'].toString()),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
