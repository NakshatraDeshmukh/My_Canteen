import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:canteen_final/widgets/custom_scaffold.dart';
import 'package:canteen_final/theme/theme.dart';
import 'package:canteen_final/screens/home_user.dart';
import 'package:canteen_final/screens/table_booked.dart';

class OrderFood extends StatefulWidget {
  const OrderFood({super.key});

  @override
  State<OrderFood> createState() => _OrderFoodState();
}

class _OrderFoodState extends State<OrderFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Text("order food "),
    );
  }}

