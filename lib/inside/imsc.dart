// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class MyWidget extends StatefulWidget {
//   final String id;
//   const MyWidget(this.id, {super.key});
//   @override
//   State<MyWidget> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<MyWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance
//             .collection('gposts')
//             .doc(widget.id)
//             .get(),
//         builder: (context, field) {
//           if (!field.hasData || field.data == null) {
//             return Center(
//               child: CircularProgressIndicator(
//                 backgroundColor: Colors.pink,
//                 color: Colors.blue,
//               ),
//             );
//           }
//           if (field.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator(
//               backgroundColor: Colors.pink,
//               color: Colors.blue,
//             );
//           }
//           final data = field.data!.data() as Map<String, dynamic>;
//           return Padding(
//             padding: EdgeInsetsGeometry.all(20),
//             child: showModalBottomSheet(context: context, builder: (context){

//             }),
//           );
//         },
//       ),
//     );
//   }
// }
