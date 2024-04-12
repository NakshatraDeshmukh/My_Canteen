import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:canteen_final/widgets/custom_scaffold.dart';
import 'package:canteen_final/theme/theme.dart';
import 'package:canteen_final/screens/order_food.dart';
import 'package:canteen_final/screens/reserve_table.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});
  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF894B03),
              ),
              child: Text(
                "What's on your mind ? ",
                style: TextStyle(
                  color: Color(0xFFD5C4BA),
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Order Food'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (e) => const OrderFood(),
                ),
                );
              },   // Handle item 1 tap},
            ),
            ListTile(
              title: Text('Reserve Table'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (e) => const ReserveTable(),
                ),
                );// Handle item 2 tap
              },
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/home_user.jpg', // Provide your background image path here
            fit: BoxFit.cover, // Cover the background
          ),
          Positioned(
            top: 250,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Meal of the Day : ',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 35),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('- Sukhi Bhaji : Matki', style: TextStyle(color: Colors.white, fontSize: 17)),
                    Text('- Rassa Bhaji : Chole', style: TextStyle(color: Colors.white, fontSize: 17)),
                    Text('- Sweet dish: Pineapple Shira', style: TextStyle(color: Colors.white, fontSize: 17)),
                    // Add more items as needed
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}