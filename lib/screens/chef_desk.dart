
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:canteen_final/widgets/custom_scaffold.dart';
import 'package:canteen_final/theme/theme.dart';
import 'package:canteen_final/screens/verify_chef.dart';
class ChefDesk extends StatefulWidget {
  const ChefDesk({super.key});

  @override
  State<ChefDesk> createState() => _ChefDeskState();
}
class _ChefDeskState extends State<ChefDesk> {
  List<Order> orders = [
    Order(id: 1, name: 'Shevbhaji Thali', isCompleted: false, isCanceled: false),
    Order(id: 2, name: 'Uttappa', isCompleted: false, isCanceled: false),
    Order(id: 3, name: 'Pav Bhaji', isCompleted: false, isCanceled: false),
    Order(id: 4, name: 'Rice Plate', isCompleted: false, isCanceled: false),
  ];

  void toggleOrderCompletion(int id) {
    setState(() {
      final index = orders.indexWhere((order) => order.id == id);
      orders[index].isCompleted = !orders[index].isCompleted;
      if (orders[index].isCompleted) {
        // If the order is completed, remove it from the list
        orders.removeAt(index);
      }
    });
  }

  void cancelOrder(int id) {
    setState(() {
      final index = orders.indexWhere((order) => order.id == id);
      orders[index].isCanceled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chef Desk'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/chefdesk.png'), // Provide your image path here
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return ListTile(
              title: Container(
                color: Colors.white,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  order.name,
                  style: TextStyle(
                    decoration: order.isCanceled ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!order.isCompleted)
                    IconButton(
                      icon: order.isCompleted ? Icon(Icons.done) : Icon(Icons.done),
                      onPressed: () {
                        toggleOrderCompletion(order.id);
                      },
                    ),
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      cancelOrder(order.id);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class Order {
  final int id;
  final String name;
  bool isCompleted;
  bool isCanceled;

  Order({required this.id, required this.name, this.isCompleted = false, this.isCanceled = false});
}