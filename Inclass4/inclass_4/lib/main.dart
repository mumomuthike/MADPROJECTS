import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanced Counter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;
  int _incrementValue = 1;
  final int _maxLimit = 100;

  final List<int> _history = [];
  final TextEditingController _incController = TextEditingController(text: "1");

  // ✅ Spec Task 4 hint: logic goes in style via getter
  Color get counterColor {
    if (_counter == 0) return Colors.red;
    if (_counter > 50) return Colors.green;
    return Colors.black;
  }

  void _showMaxMessage() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Maximum limit reached!")));
  }

  void _checkSuccessTarget() {
    if (_counter == 50 || _counter == 100) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("🎉 Congratulations!"),
          content: Text("You reached $_counter!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  // ✅ History saved ONLY on increment/decrement (strict spec)
  void _increment() {
    final next = _counter + _incrementValue;

    if (next > _maxLimit) {
      _showMaxMessage();
      return;
    }

    setState(() {
      _history.add(_counter); // save previous value
      _counter = next;
    });

    _checkSuccessTarget();
  }

  void _decrement() {
    final next = _counter - _incrementValue;
    if (next < 0) return; // limit of 0

    setState(() {
      _history.add(_counter); // save previous value
      _counter = next;
    });
  }

  // ✅ Reset does NOT add to history (strict spec)
  void _reset() {
    setState(() {
      _counter = 0;
    });
  }

  // ✅ Undo uses history (history only comes from inc/dec)
  void _undo() {
    if (_history.isEmpty) return;
    setState(() {
      _counter = _history.removeLast();
    });
  }

  void _updateIncrementValue(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null || parsed <= 0) return; // validate number
    setState(() {
      _incrementValue = parsed;
    });
  }

  @override
  void dispose() {
    _incController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stateful Widget')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 18),

            /// Counter display (color changes per spec)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                color: Colors.blue.shade100,
                child: Text(
                  '$_counter',
                  style: TextStyle(fontSize: 50.0, color: counterColor),
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// Slider (still controls counter, but does NOT affect history)
            Slider(
              min: 0,
              max: _maxLimit.toDouble(),
              value: _counter.toDouble(),
              onChanged: (double value) {
                setState(() {
                  _counter = value.toInt();
                });
                _checkSuccessTarget();
              },
              activeColor: Colors.blue,
              inactiveColor: Colors.red,
            ),

            const SizedBox(height: 10),

            /// Custom increment input (validated as a number)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _incController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Custom Increment Value (e.g. 2, 5)",
                  border: const OutlineInputBorder(),
                  helperText: "Current increment: +$_incrementValue",
                ),
                onChanged: _updateIncrementValue,
              ),
            ),

            const SizedBox(height: 12),

            /// Buttons
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _increment,
                  child: const Text("Increment"),
                ),
                ElevatedButton(
                  onPressed: _decrement,
                  child: const Text("Decrement"),
                ),
                ElevatedButton(onPressed: _reset, child: const Text("Reset")),
                ElevatedButton(onPressed: _undo, child: const Text("Undo")),
              ],
            ),

            const SizedBox(height: 18),

            /// History list (previous values only from inc/dec)
            const Text(
              "History (previous values from Increment/Decrement):",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            if (_history.isEmpty)
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("No history yet — use Increment or Decrement."),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final value = _history[index];
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text("Value: $value"),
                  );
                },
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
