import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:canteen_final/screens/table_booked.dart';
import 'dart:async';

class ReserveTable extends StatefulWidget {
  const ReserveTable({Key? key}) : super(key: key);

  @override
  State<ReserveTable> createState() => _ReserveTableState();
}

class _ReserveTableState extends State<ReserveTable> {
  List<int> selectedButtons = [];
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserve Table'),
        backgroundColor: Color(0xFFC39684),
      ),
      body: Column(
        children: [
          // Calendar and Time selector
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(selectedDate == null
                      ? 'Select Date'
                      : 'Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                ),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: Text(selectedTime == null
                      ? 'Select Time'
                      : 'Time: ${selectedTime!.hour}:${selectedTime!.minute}'),
                ),
              ],
            ),
          ),
          // Small buttons
          Expanded(
            child: Stack(
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
                  if (selectedDate != null && selectedTime != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TableBooked(
                          selectedDate: selectedDate!,
                          selectedTime: selectedTime!,
                        ),
                      ),
                    );
                  } else {
                    // Handle case where date or time is not selected
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Please select both date and time.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
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
