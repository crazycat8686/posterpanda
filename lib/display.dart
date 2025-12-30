import 'package:flutter/material.dart';
import 'main.dart';
import 'setup.dart';

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
      print("uname is passed not extracting $uname");
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
        print(
          "initchecker passed!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!===",
        );
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
        title: const Text("data"),
        backgroundColor: Colors.blue,

        actions: [
          IconButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => loll(uname: widget.uname),
                ),
              ),
            },
            icon: Icon(Icons.account_circle_rounded),
          ),
        ],
      ),
      body: Center(child: Text("Hello $uname")),
    );
  }
}
