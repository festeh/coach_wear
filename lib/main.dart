import 'package:flutter/material.dart';
import 'package:wear_plus/wear_plus.dart';

class TimerDisplay extends StatefulWidget {
  const TimerDisplay({super.key});

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay> {
  final int _timeRemaining = 20;

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
            icon: const Icon(Icons.remove),
            onPressed: () {
              // Decrease time action
            },
          ),
        ),
        Text(
          "$_timeRemaining",
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Increase time action
            },
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

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Focus button action
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
