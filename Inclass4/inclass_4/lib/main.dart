import 'package:flutter/material.dart';

void main() => runApp(const Appthing());

class Appthing extends StatelessWidget {
  const Appthing({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanced Counter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CountieWidg(),
    );
  }
}

class CountieWidg extends StatefulWidget {
  const CountieWidg({super.key});

  @override
  State<CountieWidg> createState() => _CountieState();
}

class _CountieState extends State<CountieWidg> {
  int NumbieCount = 0;
  int BumpieStep = 1;
  final int MaxieCap = 100;

  final List<int> PastieVals = [];
  final TextEditingController StepieBox = TextEditingController(text: "1");

  // Using the hint professor henry kindly gave us for color!
  Color get ColieMood {
    if (NumbieCount == 0) return Colors.red;
    if (NumbieCount > 50) return Colors.green;
    return Colors.black;
  }

  void MaxieWarn() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Maximum limit reached!")));
  }

  void GoalieCheck() {
    if (NumbieCount == 50 || NumbieCount == 100) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("🎉 Congratulations!"),
          content: Text("You reached $NumbieCount!"),
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

  // History saving only for increment and decrement (found on stack overflow if it matters)
  void UpieTap() {
    final NxtieVal = NumbieCount + BumpieStep;

    if (NxtieVal > MaxieCap) {
      MaxieWarn();
      return;
    }

    setState(() {
      PastieVals.add(NumbieCount);
      NumbieCount = NxtieVal;
    });

    GoalieCheck();
  }

  void DownieTap() {
    final NxtieVal = NumbieCount - BumpieStep;
    if (NxtieVal < 0) return;

    setState(() {
      // saving the  previous value
      PastieVals.add(NumbieCount);
      NumbieCount = NxtieVal;
    });
  }

  // Resetting doesnt count as history
  void ZeroieZap() {
    setState(() {
      NumbieCount = 0;
    });
  }

  // For undo to work, its using the history
  void BackieFix() {
    if (PastieVals.isEmpty) return;
    setState(() {
      NumbieCount = PastieVals.removeLast();
    });
  }

  void StepieSet(String value) {
    final NewieStep = int.tryParse(value);
    if (NewieStep == null || NewieStep <= 0) return;

    setState(() {
      BumpieStep = NewieStep;
    });
  }

  @override
  void dispose() {
    StepieBox.dispose();
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

            //Displaying counter
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                color: Colors.blue.shade100,
                child: Text(
                  '$NumbieCount',
                  style: TextStyle(fontSize: 50.0, color: ColieMood),
                ),
              ),
            ),

            const SizedBox(height: 14),

            //The slider
            Slider(
              min: 0,
              max: MaxieCap.toDouble(),
              value: NumbieCount.toDouble(),
              onChanged: (double value) {
                setState(() {
                  NumbieCount = value.toInt();
                });
                GoalieCheck();
              },
              activeColor: Colors.blue,
              inactiveColor: Colors.red,
            ),

            const SizedBox(height: 10),

            //Increment is customized
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: StepieBox,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Custom Increment Value (e.g. 2, 5)",
                  border: const OutlineInputBorder(),
                  helperText: "Current increment: +$BumpieStep",
                ),
                onChanged: StepieSet,
              ),
            ),

            const SizedBox(height: 12),

            //The buttons
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: UpieTap,
                  child: const Text("Increment"),
                ),
                ElevatedButton(
                  onPressed: DownieTap,
                  child: const Text("Decrement"),
                ),
                ElevatedButton(
                  onPressed: ZeroieZap,
                  child: const Text("Reset"),
                ),
                ElevatedButton(onPressed: BackieFix, child: const Text("Undo")),
              ],
            ),

            const SizedBox(height: 18),

            //History
            const Text(
              "History (previous values from Increment/Decrement):",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            if (PastieVals.isEmpty)
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("No history yet — use Increment or Decrement."),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: PastieVals.length,
                itemBuilder: (context, index) {
                  final value = PastieVals[index];
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
