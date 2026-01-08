// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';

class Setup extends StatefulWidget {
  const Setup({super.key});

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  final TextEditingController c1 = TextEditingController();
  bool big = false;
  String? stat;
  void set(String val) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('name', val);
  }

  Future<void> sign() async {
    final client = Client()
        .setEndpoint('https://nyc.cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('695f675200002b911515'); // Your project ID

    final account = Account(client);
    await account.deleteSession(sessionId: "current");

    // Go to OAuth provider login page
    final res = await account.createOAuth2Session(
      provider: OAuthProvider.google,
    );
    final user = await account.get();
    print(user.toMap());
    setState(() {
      stat = user.name;
    });
  }

  Future<void> del() async {
    final client = Client()
        .setEndpoint('https://nyc.cloud.appwrite.io/v1') // Your API Endpoint
        .setProject('695f675200002b911515'); // Your project ID

    final account = Account(client);
    await account.deleteSession(sessionId: "current");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(221, 1, 11, 37),
      body: Padding(
        padding: EdgeInsetsGeometry.all(50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                // textAlign: TextAlign.center,
                "Welcome, Sign-up please!!",
                style: TextStyle(
                  fontFamily: 'Bau',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  // color: const Color.fromARGB(123, 255, 255, 255),
                ),
              ),
              CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('images/wallps.jpg'),
              ),
              TextField(
                controller: c1,

                onTap: () => {
                  setState(() {
                    big = !big;
                  }),
                },
                onSubmitted: (value) => {
                  if (c1.text != "")
                    {
                      set(value),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Display(uname: c1.text),
                        ),
                      ),
                    }
                  else
                    {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Please enter ur fucking name!!!"),
                        ),
                      ),
                    },
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 141, 76, 22),
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  hintText: 'John Sick',
                  labelText: 'Enter yout name pls',
                  prefixIcon: Icon(Icons.person_2),
                ),
              ),
              stat == null ? Text("aut") : Text(stat!),
              ElevatedButton.icon(onPressed: sign, label: Text("GAuth")),

              ElevatedButton.icon(onPressed: del, label: Text("del")),
            ],
          ),
        ),
      ),
    );
  }
}
