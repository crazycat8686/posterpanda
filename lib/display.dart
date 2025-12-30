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
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? uname = pref.getString('name');
    setState(() {
      this.uname = uname;
    });
    print(uname);
    if (uname != null && uname != "") {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => Setup()),
      // );
      print(uname);
      print(
        "initchecker passed!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!===",
      );
      setState(() {
        this.uname = uname;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Setup()),
      );
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
      body: Center(child: Text("Hello ${widget.uname}")),
    );
  }
}
