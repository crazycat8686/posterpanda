import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Setup());
}

class Setup extends StatefulWidget {
  const Setup({super.key});

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  final TextEditingController c1 = TextEditingController();
  void set(String val) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('name', val);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "setup",
      home: Scaffold(
        body: Padding(
          padding: EdgeInsetsGeometry.all(30),
          child: Center(
            child: Column(
              children: [
                Text("Welcome pls do this"),
                CircleAvatar(backgroundImage: AssetImage('images/wallps.jpg')),
                TextField(
                  controller: c1,
                  onSubmitted: (value) => {
                    set(value),
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => loll()),
                    ),
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'JOhn DIck',
                    labelText: 'Enter yout name pls',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
