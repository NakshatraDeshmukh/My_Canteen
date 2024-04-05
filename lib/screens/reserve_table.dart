import 'package:canteen_final/screens/table_booked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:canteen_final/widgets/custom_scaffold.dart';
import 'package:canteen_final/theme/theme.dart';
import 'package:canteen_final/screens/home_user.dart';
import 'package:canteen_final/screens/table_booked.dart';


class ReserveTable extends StatefulWidget {
  const ReserveTable({Key? key}) : super(key: key);

  @override
  State<ReserveTable> createState() => _ReserveTableState();
}

class _ReserveTableState extends State<ReserveTable> {
  List<int> selectedButtons = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserve Table'),
        backgroundColor: Color(0xFFC39684),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/reservetable.png', // Replace 'background_image.jpg' with your image asset
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Center(
            child: GridView.count(
              crossAxisCount: 5, // 5 buttons per row
              children: List.generate(30, (index) {
                // Generate 30 buttons
                return ColorChangeButton(
                  index: index,
                  isSelected: selectedButtons.contains(index),
                  onBookingChanged: () {
                    setState(() {
                      if (selectedButtons.contains(index)) {
                        selectedButtons.remove(index);
                      } else {
                        selectedButtons.add(index);
                      }
                    });
                  },
                );
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.green, // Bar background color
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedButtons.isNotEmpty) // Only show the button if at least one table is booked
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (e) => const TableBooked(),
                    ),
                  );
                  // Handle bar button press
                },
                child: Text(
                  'Book Table',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ColorChangeButton extends StatelessWidget {
  final int index;
  final bool isSelected;
  final VoidCallback onBookingChanged;

  const ColorChangeButton({
    required this.index,
    required this.isSelected,
    required this.onBookingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onBookingChanged,
        child: Container(
          width: 50,
          height: 50,
          color: isSelected ? Colors.red : Colors.blue,
          child: Center(
            child: Text(
              '$index',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

