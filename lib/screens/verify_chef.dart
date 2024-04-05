import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:canteen_final/widgets/custom_scaffold.dart';
import 'package:canteen_final/theme/theme.dart';
import 'package:canteen_final/screens/chef_desk.dart';
class HomeChef extends StatefulWidget {
  const HomeChef({super.key});

  @override
  State<HomeChef> createState() => _HomeChefState();
}

class _HomeChefState extends State<HomeChef> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Chef's Desk"),
     ),
     body: Container(
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage('assets/welcome_page.png'),
    fit: BoxFit.cover,
    ),
    ),
       child: Center(
         child: Padding(
           padding: EdgeInsets.all(20.0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Container(
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(8.0),
                 ),
                 child: Padding(
                   padding: EdgeInsets.symmetric(horizontal: 16.0),
                   child: TextField(
                     decoration: InputDecoration(
                       hintText: 'Enter access code',
                       border: InputBorder.none,
                     ),
                   ),
                 ),
               ),
               SizedBox(height: 20.0), // Adding space between text field and button
               ElevatedButton(
                 onPressed: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (e) => const ChefDesk(),
                     ),
                   );
                   // Add button click functionality here
                 },
                 child: Text('Submit'),
               ),
             ],
           ),
         ),
       ),
     ),
   );
  }
}