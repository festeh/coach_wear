import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wear_plus/wear_plus.dart';

class TimerDisplay extends StatefulWidget {
  const TimerDisplay({super.key});

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay> {
  int _timeRemaining = 20;

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
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
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

class FocusButton extends StatelessWidget {
  const FocusButton({
    super.key,
  });

  Future<void> _sendFocusRequest(int duration) async {
    try {
      // Get server address from environment variable or use default
      final serverAddress = Platform.environment['COACH_ADDR'] ?? 'https://foo.bar';
      
      final response = await http.post(
        Uri.parse('$serverAddress?duration=$duration'),
      );
      
      if (response.statusCode == 200) {
        debugPrint('Request successful: ${response.body}');
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sending request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Find the TimerDisplay widget to access its state
    final timerState = context.findAncestorStateOfType<_TimerDisplayState>();
    final duration = timerState?._timeRemaining ?? 20; // Default to 20 if not found
    
    return ElevatedButton(
      onPressed: () {
        _sendFocusRequest(duration);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(16),
        // Button style is now defined in the theme
      ),
      child: const Text(
        "Focus",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coach',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurple.shade300,
          secondary: Colors.deepPurple.shade200,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple.shade700,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const MyHomePage(title: 'Coach'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: WatchShape(
          builder: (context, shape, child) {
            // Optimize layout for round watch face
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TimerDisplay(),
                const SizedBox(height: 16),
                const FocusButton(),
              ],
            );
          },
          child: const SizedBox(), // Not used as we're building directly in the builder
        ),
      ),
    );
  }
}
