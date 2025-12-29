import 'package:flutter/material.dart';
import 'main.dart';

class Display extends StatefulWidget {
  final String uname;
  const Display(this.uname, {super.key});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("data"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => loll(widget.uname)),
            );
          },
        ),
      ),
      body: Center(child: Text("Hello ${widget.uname}")),
    );
  }
}
