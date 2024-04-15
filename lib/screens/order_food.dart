import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:canteen_final/screens/home_user.dart';
import 'package:canteen_final/screens/bill_screen.dart';

class OrderFood extends StatefulWidget {
  final SupabaseClient supabase;
  const OrderFood({Key? key, required this.supabase}) : super(key: key);

  @override
  State<OrderFood> createState() => _OrderFoodState();
}

class _OrderFoodState extends State<OrderFood> {
  Map<String, int> cartItems = {};

  void addToCart(String item) {
    setState(() {
      if (cartItems.containsKey(item)) {
        cartItems[item] = cartItems[item]! + 1;
      } else {
        cartItems[item] = 1;
      }
    });
  }

  void removeFromCart(String item) {
    setState(() {
      if (cartItems.containsKey(item)) {
        if (cartItems[item]! > 1) {
          cartItems[item] = cartItems[item]! - 1;
        } else {
          cartItems.remove(item);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MENU"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/orderfood.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildMenuItem('Extra Chapati', 7),
              _buildMenuItem('Extra Pav', 6),
              _buildMenuItem('Bhaji Chapati', 40),
              _buildMenuItem('Dosa', 40),
              _buildMenuItem('Uttappa', 40),
              _buildMenuItem('Pav Bhaji', 40),
              _buildMenuItem('Sabudana Khichadi', 40),
              _buildMenuItem('Misal Pav', 50),
              _buildMenuItem('Masala Rice', 50),
              _buildMenuItem('Rice Plate', 60),
              _buildMenuItem('Shevbhaji Thali', 75),
              _buildMenuItem('Paneer Thali', 100),
              _buildMenuItem('Paneer Butter Masala', 120),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartScreen(cartItems: cartItems, supabaseClient: widget.supabase),
            ),
          ).then((_) {
            // Refresh the UI if necessary after returning from the CartScreen
            setState(() {});
          });
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }

  Widget _buildMenuItem(String name, double price) {
    bool isAdded = cartItems.containsKey(name);
    return ListTile(
      title: Text(name),
      subtitle: Text('Rs ${price.toStringAsFixed(2)}'),
      trailing: isAdded
          ? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () => removeFromCart(name),
          ),
          Text(
            '${cartItems[name]}',
            style: TextStyle(fontSize: 16),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => addToCart(name),
          ),
        ],
      )
          : IconButton(
        icon: Icon(Icons.add),
        onPressed: () => addToCart(name),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final Map<String, int> cartItems;
  final SupabaseClient supabaseClient;

  CartScreen({required this.cartItems, required this.supabaseClient});

  @override
  Widget build(BuildContext context) {
    double totalPrice = calculateTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/cart.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems.keys.elementAt(index);
                  final count = cartItems[item];
                  return ListTile(
                    title: Text('$item (Quantity: $count)'),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total: Rs ${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BillScreen(cartItems: cartItems, totalPrice: totalPrice, supabaseClient: supabaseClient),
                    ),
                  );
                  await addItemsToSupabase(context, supabaseClient, cartItems, totalPrice);
                },
                child: Text('Confirm Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addItemsToSupabase(BuildContext context, SupabaseClient supabaseClient, Map<String, int> cartItems, double totalPrice) async {
    List<Map<String, dynamic>> records = [];

    cartItems.forEach((item, quantity) {
      records.add({
        'name': item,
        'quantity': quantity,
        'totalprice': getItemPrice(item) * quantity,
        'is_cancelled': false,
        'is_completed': false,
      });
    });

    final response = await supabaseClient.from('orders').insert(records);

    if (response.error != null) {
      final snackBar = SnackBar(
        content: Text('Error: ${response.error!.message}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('Error: ${response.error!.message}');
    } else {
      print('Items added to Supabase successfully');
    }
  }


  double getItemPrice(String item) {
    switch (item) {
      case 'Extra Chapati':
        return 7.0;
      case 'Extra Pav':
        return 6.0;
      case 'Bhaji Chapati':
        return 40.0;
      case 'Dosa':
        return 40.0;
      case 'Uttappa':
        return 40.0;
      case 'Pav Bhaji':
        return 40.0;
      case 'Sabudana Khichadi':
        return 40.0;
      case 'Misal Pav':
        return 50.0;
      case 'Masala Rice':
        return 50.0;
      case 'Rice Plate':
        return 60.0;
      case 'Shevbhaji Thali':
        return 75.0;
      case 'Paneer Thali':
        return 100.0;
      case 'Paneer Butter Masala':
        return 120.0;
      default:
        return 0.0;
    }
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    cartItems.forEach((item, quantity) {
      double itemPrice = getItemPrice(item);
      totalPrice += itemPrice * quantity;
    });
    return totalPrice;
  }
}
