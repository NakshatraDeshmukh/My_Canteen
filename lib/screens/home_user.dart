import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:canteen_final/widgets/custom_scaffold.dart';
import 'package:canteen_final/theme/theme.dart';
import 'package:canteen_final/screens/order_food.dart';
import 'package:canteen_final/screens/reserve_table.dart';
import 'package:supabase/supabase.dart';
import 'package:canteen_final/screens/account_page.dart';

class HomeUser extends StatefulWidget {
  final SupabaseClient supabase;
  const HomeUser({Key? key, required this.supabase}) : super(key: key);
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
                color: Color(0xFF352922),
                image: DecorationImage(
                  image: AssetImage('assets/app_logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Text(
                "      What's on your mind ? ",
                style: TextStyle(
                  color: Color(0xFFD5C4BA),
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.restaurant, color: Colors.brown),
              title: Text('Order Food', style: TextStyle(color: Colors.brown)),
              onTap: () {
                final supabase = widget.supabase;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (e) =>  OrderFood(supabase: supabase),
                ),
                );
              },   // Handle item 1 tap},
            ),
            ListTile(
              leading: Icon(Icons.event_seat, color: Colors.brown),
              title: Text('Reserve Table', style: TextStyle(color: Colors.brown)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (e) =>  ReserveTable(),
                ),
                );// Handle item 2 tap
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle, color: Colors.brown),
              title: Text('Profile', style: TextStyle(color: Colors.brown)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountPage(),
                  ),
                );
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