import 'package:flutter/material.dart';

void main() {
  runApp(const Counter_tog_App());
}

class Counter_tog_App extends StatefulWidget {
  const Counter_tog_App({super.key});

  @override
  State<Counter_tog_App> createState() => _counterTOGState();
}

class _counterTOGState extends State<Counter_tog_App> {
  bool isDark_mode = false;

  void togTheme() => setState(() => isDark_mode = !isDark_mode);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CW1 Counter & Toggle',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDark_mode ? ThemeMode.dark : ThemeMode.light,
      home: Home_pg(isDark: isDark_mode, onTogTheme: togTheme),
    );
  }
}

class Home_pg extends StatefulWidget {
  const Home_pg({super.key, required this.isDark, required this.onTogTheme});

  final bool isDark;
  final VoidCallback onTogTheme;

  @override
  State<Home_pg> createState() => _HOMEpgSTATE();
}

class _HOMEpgSTATE extends State<Home_pg> with SingleTickerProviderStateMixin {
  int Counter_val = 0;
  int step_sz = 1;

  static const int max_colr_val = 120;

  static const Color pink_colr = Color(0xFFE91E63);
  static const Color lavenderColr = Color(0xFFB388FF);
  static const Color deep_purpColr = Color(0xFF4A148C);

  late final AnimationController img_togController;

  bool get isSecondIMG => img_togController.value >= 0.5;

  @override
  void initState() {
    super.initState();
    img_togController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      value: 0.0,
    );
  }

  @override
  void dispose() {
    img_togController.dispose();
    super.dispose();
  }

  Color getCounterColr() {
    final t_val = (Counter_val / max_colr_val).clamp(0.0, 1.0);

    if (t_val <= 0.5) {
      final midT = t_val / 0.5;
      return Color.lerp(pink_colr, lavenderColr, midT)!;
    } else {
      final highT = (t_val - 0.5) / 0.5;
      return Color.lerp(lavenderColr, deep_purpColr, highT)!;
    }
  }

  void incCounter_val() => setState(() => Counter_val += step_sz);

  void dec_counter() {
    if (Counter_val == 0) return;
    setState(() {
      Counter_val -= step_sz;
      if (Counter_val < 0) Counter_val = 0;
    });
  }

  void reset_all() {
    setState(() {
      Counter_val = 0;
      step_sz = 1;
      img_togController.value = 0.0;
    });
  }

  void setStep_sz(int newStep) => setState(() => step_sz = newStep);

  void togIMG() {
    if (isSecondIMG) {
      img_togController.reverse();
    } else {
      img_togController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final canDec = Counter_val > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CW1 Counter & Toggle'),
        actions: [
          IconButton(
            onPressed: widget.onTogTheme,
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Counter', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),

              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: getCounterColr(),
                ),
                child: Text('$Counter_val'),
              ),

              const SizedBox(height: 16),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('+1'),
                    selected: step_sz == 1,
                    onSelected: (_) => setStep_sz(1),
                  ),
                  ChoiceChip(
                    label: const Text('+5'),
                    selected: step_sz == 5,
                    onSelected: (_) => setStep_sz(5),
                  ),
                  ChoiceChip(
                    label: const Text('+10'),
                    selected: step_sz == 10,
                    onSelected: (_) => setStep_sz(10),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: incCounter_val,
                    icon: const Icon(Icons.add),
                    label: Text('Increment (+$step_sz)'),
                  ),
                  OutlinedButton.icon(
                    onPressed: canDec ? dec_counter : null,
                    icon: const Icon(Icons.remove),
                    label: Text('Decrement (-$step_sz)'),
                  ),
                  TextButton.icon(
                    onPressed: reset_all,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: 200,
                height: 200,
                child: AnimatedBuilder(
                  animation: img_togController,
                  builder: (context, _) {
                    final t_val = Curves.easeInOut.transform(
                      img_togController.value,
                    );

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Opacity(
                          opacity: 1.0 - t_val,
                          child: Image.asset(
                            'images/image1.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Opacity(
                          opacity: t_val,
                          child: Image.asset(
                            'images/image2.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: togIMG,
                child: Text(isSecondIMG ? 'Show Sun' : 'Show Moon'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
