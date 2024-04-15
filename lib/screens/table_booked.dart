import 'package:flutter/material.dart';
import 'dart:async';
import 'package:supabase/supabase.dart';
import 'package:canteen_final/screens/home_user.dart';

class TableBooked extends StatefulWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final SupabaseClient supabase;

  const TableBooked({
    required this.selectedDate,
    required this.selectedTime,
    required this.supabase,
  });

  @override
  State<TableBooked> createState() => _TableBookedState();
}

class _TableBookedState extends State<TableBooked> {
  bool _isBooked = false;
  Timer? _timer;
  int _secondsRemaining = 15 * 60;
  bool _timerStarted = false;

  @override
  void initState() {
    super.initState();
    _fetchTableStatus();
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
            _updateTables();
            Navigator.pop(context);
          }
        });
      }
    });
  }

  Future<void> _fetchTableStatus() async {
    final response = await widget.supabase.from('tables').select('is_booked');
    final List<Map<String, dynamic>>? data = response;

    if (data != null) {
      setState(() {
        _isBooked = data.any((table) => table['is_booked'] == true);
      });
    }
  }

  Future<void> _updateTables() async {
    for (int tableNumber = 1; tableNumber <= 30; tableNumber++) {
      await widget.supabase
          .from('tables')
          .update({'is_booked': false})
          .eq('table_number', tableNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserve Table'),
        backgroundColor: Color(0xFFC39684),
        automaticallyImplyLeading: false, // Removes back button
        actions: [
          IconButton(
            icon: Icon(Icons.home), // Home icon button
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (e) =>  HomeUser(supabase: widget.supabase)
                ),
              );

            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/reservetable.png'),
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
                supabase: widget.supabase,
                isBooked: _isBooked,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final SupabaseClient supabase;
  final bool isBooked;

  const CountdownTimer({
    required this.selectedDate,
    required this.selectedTime,
    required this.supabase,
    required this.isBooked,
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
            _updateTables();
            Navigator.pop(context);
          }
        });
      }
    });
  }

  Future<void> _updateTables() async {
    for (int tableNumber = 1; tableNumber <= 30; tableNumber++) {
      await widget.supabase
          .from('tables')
          .update({'is_booked': false})
          .eq('table_number', tableNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.isBooked ?   Color(0xFF566D74) : Color(0xFF566D74),
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

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')} min';
  }
}





