import 'package:flutter/material.dart';

class TimerDisplay extends StatefulWidget {
  const TimerDisplay({super.key});

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay> {
  int _timeRemaining = 20;

  // Getter to expose the time remaining to other widgets
  int get timeRemaining => _timeRemaining;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Icons.remove, size: 16),
            onPressed: () {
              setState(() {
                if (_timeRemaining > 5) {
                  _timeRemaining -= 5;
                } else {
                  _timeRemaining = 0;
                }
              });
            },
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
              maxWidth: 28,
              maxHeight: 28,
            ),
            iconSize: 16,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "$_timeRemaining",
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Icons.add, size: 16),
            onPressed: () {
              setState(() {
                if (_timeRemaining <= 55) {
                  _timeRemaining += 5;
                } else {
                  _timeRemaining = 60;
                }
              });
            },
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
              maxWidth: 28,
              maxHeight: 28,
            ),
            iconSize: 16,
          ),
        ),
      ],
    );
  }
}
