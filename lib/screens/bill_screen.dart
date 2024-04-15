import 'package:flutter/material.dart';
import 'package:canteen_final/screens/home_user.dart';
import 'package:supabase/supabase.dart';

class BillScreen extends StatelessWidget {
  final Map<String, int> cartItems;
  final double totalPrice;
  final SupabaseClient supabaseClient;

  BillScreen({required this.cartItems, required this.totalPrice, required this.supabaseClient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/orderfood.png"), // Background image for the bill screen
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Your order has been confirmed!',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  // Display ordered items with quantity
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: cartItems.entries.map((entry) {
                      return Text('${entry.key}: ${entry.value}'); // Display item name and quantity
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Amount: Rs ${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeUser(supabase: supabaseClient)),
                        (route) => false, // Remove all existing routes from the stack
                  );
                },
                child: Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
