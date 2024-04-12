import 'package:flutter/material.dart';
import 'dart:async';
import 'package:canteen_final/screens/order_food.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MaterialApp(
    home: TableBooked(
      selectedDate: DateTime.now(),
      selectedTime: TimeOfDay.now(),
    ),
  ));
}

class TableBooked extends StatefulWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  const TableBooked({
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  State<TableBooked> createState() => _TableBookedState();
}

class _TableBookedState extends State<TableBooked> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserve Table'),
        backgroundColor: Color(0xFFC39684),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/reservetable.png'), // Replace 'background_image.jpg' with your image file
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Table booked for:',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Date: ${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Time: ${widget.selectedTime.hour}:${widget.selectedTime.minute}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              CountdownTimer(
                selectedDate: widget.selectedDate,
                selectedTime: widget.selectedTime,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: OrderFoodButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class OrderFoodButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OrderFood(),
          ),
        );

        // Add functionality to order food here
      },
      label: Text('Order Food'),
      icon: Icon(Icons.fastfood),
      backgroundColor: Colors.blue,
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  const CountdownTimer({
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  int _secondsRemaining = 15 * 60;
  bool _timerStarted = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();
      if (!_timerStarted &&
          now.hour == widget.selectedTime.hour &&
          now.minute == widget.selectedTime.minute) {
        setState(() {
          _timerStarted = true;
        });
      }

      if (_timerStarted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _timer?.cancel();
            Navigator.pop(context); // Navigating back to previous page
          }
        });
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')} min';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        _formatTime(_secondsRemaining),
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

