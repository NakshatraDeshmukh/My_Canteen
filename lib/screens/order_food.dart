import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:canteen_final/widgets/custom_scaffold.dart';
import 'package:canteen_final/theme/theme.dart';
import 'package:canteen_final/screens/home_user.dart';
import 'package:canteen_final/screens/table_booked.dart';

class OrderFood extends StatefulWidget {
  const OrderFood({Key? key}) : super(key: key);

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
            image: AssetImage("assets/orderfood.png"), // Replace "background_image.jpg" with your image file
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
            MaterialPageRoute(builder: (context) => CartScreen(cartItems: cartItems)),
          );
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

  CartScreen({required this.cartItems});

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
            image: AssetImage("assets/cart.png"), // Replace "background_image.jpg" with your image file
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BillScreen(cartItems: cartItems, totalPrice: totalPrice),
                    ),
                  );
                },
                child: Text('Confirm Order'),
              ),
            ),
          ],
        ),
      ),
    );
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

class BillScreen extends StatelessWidget {
  final Map<String, int> cartItems;
  final double totalPrice;

  BillScreen({required this.cartItems, required this.totalPrice});

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
        child: Center(
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (e) => const HomeUser(),
                    ),
                  );

                },
                child: Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
