import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:canteen_final/screens/table_booked.dart';
import 'dart:async';
import 'package:supabase/supabase.dart';

class ReserveTable extends StatefulWidget {
  const ReserveTable({Key? key}) : super(key: key);

  @override
  State<ReserveTable> createState() => _ReserveTableState();
}

class _ReserveTableState extends State<ReserveTable> {
  List<int> selectedButtons = [];
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final supabase = SupabaseClient(
      'https://ssqtpwmwqypgxdubxxqs.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzcXRwd213cXlwZ3hkdWJ4eHFzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTIyMjA3ODMsImV4cCI6MjAyNzc5Njc4M30.SFIQ0NHB8KowS26a4zwy80v0Dxl_7DzgQsXjfriSLtA');

  late StreamSubscription<List<Map<String, dynamic>>> subscription;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    final response = await supabase.from('tables').select('table_number, is_booked');
    final List<Map<String, dynamic>> data = response as List<Map<String, dynamic>>;

    // Extract table numbers that are already booked
    final List<int> bookedTables = [];
    for (final row in data) {
      if (row['is_booked'] == true) {
        bookedTables.add(row['table_number'] as int);
      }
    }

    setState(() {
      selectedButtons.addAll(bookedTables);
    });

    // Listen to real-time updates on 'tables' table
    subscription = supabase.from('tables').stream(primaryKey: ['table_number']).listen((data) {
      setState(() {
        // Reset selectedButtons list
        selectedButtons.clear();
        // Extract table numbers that are already booked
        for (final row in data) {
          if (row['is_booked'] == true) {
            selectedButtons.add(row['table_number'] as int);
          }
        }
      });
    });
  }



  @override
  void dispose() {
    // Unsubscribe from real-time updates when the widget is disposed
    subscription.cancel();
    super.dispose();
  }

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
                    'assets/reservetable.png',
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
                        isBooked: selectedButtons.contains(index + 1),
                        onBookingChanged: () {
                          setState(() {
                            if (!selectedButtons.contains(index + 1)) {
                              selectedButtons.add(index + 1);
                            } else {
                              selectedButtons.remove(index + 1);
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
                onPressed: () async {
                  if (selectedDate != null && selectedTime != null) {
                    // Update is_booked column for selected tables
                    for (int tableNumber in selectedButtons) {
                      await supabase
                          .from('tables')
                          .update({'is_booked': true})
                          .eq('table_number', tableNumber);
                    }
                    // Navigate to TableBooked screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TableBooked(
                          selectedDate: selectedDate!,
                          selectedTime: selectedTime!,
                          supabase: supabase,
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
  final bool isBooked;
  final VoidCallback onBookingChanged;

  const ColorChangeButton({
    required this.index,
    required this.isBooked,
    required this.onBookingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          if (!isBooked) {
            onBookingChanged();
          }
        },
        child: Container(
          width: 50,
          height: 50,
          color: isBooked ? Colors.red : Colors.blue,
          child: Center(
            child: Text(
              '${index + 1}', // Index starts from 1
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
