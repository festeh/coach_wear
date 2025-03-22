import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'timer_display.dart';

class FocusButton extends StatefulWidget {
  final int duration;
  
  const FocusButton({
    super.key,
    required this.duration,
  });

  @override
  State<FocusButton> createState() => _FocusButtonState();
}

class _FocusButtonState extends State<FocusButton> {
  bool _isFocused = false;

  Future<void> _sendFocusRequest(int duration) async {
    try {
      final serverAddress = const String.fromEnvironment('COACH_ADDR');
      final uri = Uri.parse(serverAddress);
      final requestUri = uri.replace(
        queryParameters: {
          ...uri.queryParameters, // Preserve any existing query parameters
          'duration': (duration * 60).toString(),
          'focusing': 'true',
        },
      );
      final response = await http.post(requestUri);
      if (response.statusCode == 200) {
        debugPrint('Request successful: ${response.body}');
        setState(() {
          _isFocused = true;
        });

        // Reset button text after 10 seconds
        Future.delayed(const Duration(seconds: 10), () {
          if (mounted) {
            setState(() {
              _isFocused = false;
            });
          }
        });
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error sending request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isFocused ? null : () => _sendFocusRequest(widget.duration),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(16),
        // Button style is now defined in the theme
      ),
      child: Text(
        _isFocused ? "Focused!" : "Focus",
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
