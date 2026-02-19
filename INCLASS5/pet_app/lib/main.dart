import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: DigiPetApp()),
  );
}

class DigiPetApp extends StatefulWidget {
  const DigiPetApp({super.key});

  @override
  State<DigiPetApp> createState() => _DigiPetState();
}

class _DigiPetState extends State<DigiPetApp> {
  // My pet
  String Petname = "Your Pet";
  int Happylvl = 50;
  int Hungie = 50;

  int EnerG = 70;
  String DoThing = "Play";

  final TextEditingController Namebox = TextEditingController();

  Timer? HungieTick;
  Timer? WinTick;
  DateTime? Above80ish;

  bool Gameoverish = false;
  bool Winish = false;

  @override
  void initState() {
    super.initState();

    HungieTick = Timer.periodic(const Duration(seconds: 30), (_) {
      MakeHungier(5, fromTick: true);
    });

    WinTick = Timer.periodic(const Duration(seconds: 1), (_) {
      CheckWinish();
    });
  }

  @override
  void dispose() {
    HungieTick?.cancel();
    WinTick?.cancel();
    Namebox.dispose();
    super.dispose();
  }

  int Clampie(int val) => val.clamp(0, 100);

  Color Moodcol(int happy) {
    if (happy > 70) return Colors.green;
    if (happy >= 30) return Colors.yellow;
    return Colors.red;
  }

  String Moodtext(int happy) {
    if (happy > 70) return "Happy";
    if (happy >= 30) return "Neutral";
    return "Unhappy";
  }

  String Moodemo(int happy) {
    if (happy > 70) return "😄";
    if (happy >= 30) return "😐";
    return "😢";
  }

  void Popupish({required String titl, required String mess}) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titl),
        content: Text(mess),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void StateDo({int happyAdd = 0, int hungAdd = 0, int enerAdd = 0}) {
    setState(() {
      Happylvl = Clampie(Happylvl + happyAdd);
      Hungie = Clampie(Hungie + hungAdd);
      EnerG = Clampie(EnerG + enerAdd);
    });

    CheckLoseish();
  }

  void MakeHungier(int amt, {bool fromTick = false}) {
    setState(() {
      Hungie = Clampie(Hungie + amt);

      if (Hungie >= 100) {
        Hungie = 100;
        Happylvl = Clampie(Happylvl - 20);
      }

      if (fromTick && Hungie >= 80) {
        Happylvl = Clampie(Happylvl - 5);
      }
    });

    CheckLoseish();
  }

  void Feedie() {
    setState(() {
      Hungie = Clampie(Hungie - 10);
    });

    if (Hungie < 30) {
      Happylvl = Clampie(Happylvl + 10);
    }
  }

  void Playie() {
    StateDo(happyAdd: 10, enerAdd: -10, hungAdd: 5);
  }

  void DoSelectedish() {
    switch (DoThing) {
      case "Run":
        StateDo(happyAdd: 15, enerAdd: -20, hungAdd: 10);
        break;
      case "Sleep":
        StateDo(happyAdd: 5, enerAdd: 25, hungAdd: 8);
        break;
      default:
        Playie();
    }
  }

  void NameSettie() {
    final txt = Namebox.text.trim();
    if (txt.isEmpty) return;

    setState(() {
      Petname = txt;
    });

    Namebox.clear();
  }

  void CheckLoseish() {
    if (Gameoverish) return;

    if (Hungie >= 100 && Happylvl <= 10) {
      Gameoverish = true;
      HungieTick?.cancel();
      WinTick?.cancel();

      Popupish(titl: "Game Over", mess: "$Petname died. You failed. 😭");
    }
  }

  void CheckWinish() {
    if (Winish || Gameoverish) return;

    if (Happylvl > 80) {
      Above80ish ??= DateTime.now();
      final elap = DateTime.now().difference(Above80ish!);

      if (elap >= const Duration(minutes: 3)) {
        Winish = true;
        HungieTick?.cancel();
        WinTick?.cancel();

        Popupish(titl: "You Win", mess: "$Petname is thriving 🎉");
      }
    } else {
      Above80ish = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mood = "${Moodtext(Happylvl)} ${Moodemo(Happylvl)}";

    return Scaffold(
      backgroundColor: const Color(0xFFFFE4EC),
      appBar: AppBar(
        title: const Text("Digital Pet"),
        backgroundColor: const Color(0xFFFFC1D6),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: Namebox,
                      decoration: const InputDecoration(
                        labelText: "Name your pet",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: NameSettie,
                    child: const Text("Set"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text("Name: $Petname"),
              const SizedBox(height: 10),
              Text("Mood: $mood"),
              const SizedBox(height: 20),
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Moodcol(Happylvl),
                  BlendMode.modulate,
                ),
                child: Image.asset("assets/pet.png", width: 180, height: 180),
              ),
              const SizedBox(height: 20),
              Text("Happy: $Happylvl"),
              Text("Hungry: $Hungie"),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: EnerG / 100),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: Gameoverish ? null : Playie,
                child: const Text("Play"),
              ),
              ElevatedButton(
                onPressed: Gameoverish ? null : Feedie,
                child: const Text("Feed"),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: DoThing,
                items: const [
                  DropdownMenuItem(value: "Play", child: Text("Play")),
                  DropdownMenuItem(value: "Run", child: Text("Run")),
                  DropdownMenuItem(value: "Sleep", child: Text("Sleep")),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => DoThing = v);
                },
              ),
              ElevatedButton(
                onPressed: Gameoverish ? null : DoSelectedish,
                child: const Text("Do something:"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
