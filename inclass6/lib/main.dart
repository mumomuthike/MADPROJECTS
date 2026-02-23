import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rocket Launch Controller',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CounterWidget(),
      debugShowCheckedModeBanner: false,
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
  bool _liftoffDialogShown = false;

  // The safety bounds (0..100)
  int _clamp(int value) {
    if (value < 0) return 0;
    if (value > 100) return 100;
    return value;
  }

  // Visual status color, red orange then green when liftoff
  Color _statusColorFor(int value) {
    if (value == 0) return Colors.red;
    if (value <= 50) return Colors.orange;
    return Colors.green;
  }

  Widget _buttonNEW(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFC3D21), // NASA red
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // BONUS becuase I had time
  void _maybeShowLiftoffDialog({required int previous, required int next}) {
    if (!_liftoffDialogShown && previous < 100 && next == 100) {
      _liftoffDialogShown = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('🚀 Launch Successful!'),
            content: const Text(
              'LIFTOFF! The rocket has reached maximum fuel.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Awesome'),
              ),
            ],
          ),
        );
      });
    }
  }

  void _setCounter(int newValue) {
    final prev = _counter;
    final next = _clamp(newValue);

    setState(() {
      _counter = next;
    });

    _maybeShowLiftoffDialog(previous: prev, next: next);
  }

  // The Main controls
  void _ignite() => _setCounter(_counter + 1);
  void _decrement() => _setCounter(_counter - 1);

  void _reset() {
    setState(() {
      _counter = 0;
      _liftoffDialogShown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColorFor(_counter);

    return Scaffold(
      backgroundColor: const Color(0xFF0B3D91),
      appBar: AppBar(
        title: const Text('Rocket Launch Controller'),
        backgroundColor: const Color(0xFF0B3D91),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Adding a cute rocket pic for fun ig.
          Center(child: Image.asset('assets/images/rocket.png', height: 140)),

          const SizedBox(height: 30),

          // Display the numeer or Liftoff as well as cute colors too!!
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFC3D21), width: 3),
              ),
              child: Text(
                _counter == 100 ? 'LIFTOFF!' : '$_counter',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Slider controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Slider(
              min: 0,
              max: 100,
              divisions: 100,
              value: _counter.toDouble(),
              onChanged: (value) => _setCounter(value.round()),
              activeColor: const Color(0xFFFC3D21), // NASA red
              inactiveColor: Colors.white54,
            ),
          ),

          const SizedBox(height: 20),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buttonNEW('Ignite', Icons.local_fire_department, _ignite),
              _buttonNEW('Decrement', Icons.remove, _decrement),
              _buttonNEW('Reset', Icons.refresh, _reset),
            ],
          ),

          const SizedBox(height: 20),

          // Status label
          Text(
            _counter == 0
                ? 'STATUS: READY'
                : _counter == 100
                ? 'STATUS: LAUNCHED'
                : 'STATUS: FUELING',
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
