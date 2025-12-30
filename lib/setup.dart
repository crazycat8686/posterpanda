import 'package:flutter/material.dart';
import 'display.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setup extends StatefulWidget {
  const Setup({super.key});

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  final TextEditingController c1 = TextEditingController();
  bool big = false;
  void set(String val) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('name', val);
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
                "Welcome pls do this",
                style: TextStyle(
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
                  if (c1.text != null && c1.text != "")
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
                  hintText: 'JOhn DIck',
                  labelText: 'Enter yout name pls',
                  prefixIcon: Icon(Icons.person_2),
                ),
              ),
              // Center(
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       AnimatedContainer(
              //         curve: Curves.bounceInOut,
              //         duration: Duration(microseconds: 3000),
              //         width: big ? 10 : 20,
              //         height: big ? 20 : 10,
              //         color: Colors.red,
              //       ),
              //       Spacer(),
              //       AnimatedContainer(
              //         duration: Duration(microseconds: 3000),
              //         width: big ? 1 : 10,
              //         height: big ? 1 : 4,
              //         color: Colors.red,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
