import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:canteen_final/screens/order_food.dart';

class ChefDesk extends StatefulWidget {
  const ChefDesk({Key? key}) : super(key: key);

  @override
  State<ChefDesk> createState() => _ChefDeskState();
}

class _ChefDeskState extends State<ChefDesk> {
  late SupabaseClient supabase;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    supabase = SupabaseClient(
      'https://ssqtpwmwqypgxdubxxqs.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzcXRwd213cXlwZ3hkdWJ4eHFzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTIyMjA3ODMsImV4cCI6MjAyNzc5Njc4M30.SFIQ0NHB8KowS26a4zwy80v0Dxl_7DzgQsXjfriSLtA',
    );
    fetchOrders();
  }

  List<Order> orders = [];

  Future<void> fetchOrders() async {
    try {
      final response = await supabase.from('orders').select().not('is_completed', 'eq', true).not('is_cancelled', 'eq', true);
      final List<Order> fetchedOrders = response.map<Order>((json) {
        return Order.fromJson({
          'id': json['id'],
          'name': json['name'],
          'quantity': json['quantity'],
          'is_completed': json['is_completed'] ?? false, // Set to false if null
          'is_cancelled': json['is_cancelled'] ?? false, // Set to false if null
        });
      }).toList();
      setState(() {
        orders = fetchedOrders;
      });
    } catch (error) {
      print('Error fetching orders: $error');
    }
  }

  Future<void> updateOrderStatus(int orderId, {bool isCompleted = false, bool isCancelled = false}) async {
    final response = await supabase.from('orders').update({
      'is_completed': isCompleted,
      'is_cancelled': isCancelled,
    }).eq('id', orderId);

    if (response.error != null) {
      print('Error updating order status: ${response.error!.message}');
    } else {
      print('Order status updated successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chef Desk'),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: fetchOrders,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/chefdesk.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          '${order.quantity}x ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          order.name,
                          style: TextStyle(
                            color: Colors.black,
                            decoration: order.isCancelled ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () async {
                          final order = orders[index];
                          setState(() {
                            orders[index] = orders[index].copyWith(isCancelled: true);
                          });
                          await updateOrderStatus(order.id, isCancelled: true);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () async {
                          final order = orders[index];
                          setState(() {
                            orders.removeAt(index);
                          });
                          await updateOrderStatus(order.id, isCompleted: true);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Order {
  final int id;
  final String name;
  final int quantity;
  bool isCompleted;
  bool isCancelled;

  Order({required this.id, required this.name, required this.quantity, this.isCompleted = false, this.isCancelled = false});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      isCompleted: json['is_completed'] ?? false,
      isCancelled: json['is_cancelled'] ?? false,
    );
  }

  // CopyWith method to create a new instance of Order with updated values
  Order copyWith({int? id, String? name, int? quantity, bool? isCompleted, bool? isCancelled}) {
    return Order(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      isCompleted: isCompleted ?? this.isCompleted,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }
}
