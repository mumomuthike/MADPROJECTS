import 'package:flutter/material.dart';

//Mumo Musyoka
//Inclass 1
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(length: 4, child: TabsDemo()),
    );
  }
}

class TabsDemo extends StatefulWidget {
  const TabsDemo({super.key});

  @override
  State<TabsDemo> createState() => _TabsDemoState();
}

class _TabsDemoState extends State<TabsDemo>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  final RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'tab_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('TABS Inclass_1'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: [for (final t in tabs) Tab(text: t)],
        ),
      ),

      // Bottom Bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.pink.shade50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.home, color: Colors.pinkAccent),
              const SizedBox(width: 12),
              const Text(
                'Bottom App Bar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1
          _tab1(context),

          // Tab 2
          _tab2(),

          // Tab 3 (button)
          _tab3(context),

          // Tab 4 (list and cards)
          _tab4(),
        ],
      ),
    );
  }
}

// TAB 1
Widget _tab1(BuildContext context) {
  return Container(
    color: Colors.lightBlue.shade50,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Welcome to Tab 1',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Alert'),
                  content: const Text('This is the alert dialog.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Show Alert'),
          ),
        ],
      ),
    ),
  );
}

// TAB 2
Widget _tab2() {
  return Container(
    color: Colors.indigo.shade50,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Image.network(
              'https://images.unsplash.com/photo-1769008301504-0236118f86cd?q=80&w=987&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    ),
  );
}

// TAB 3
Widget _tab3(BuildContext context) {
  return Container(
    color: Colors.purple.shade50,
    child: Center(
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Button pressed in Tab 3!'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: const Text('Click me'),
      ),
    ),
  );
}

// TAB 4
Widget _tab4() {
  return Container(
    color: Colors.brown.shade50,
    child: ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 15,
      itemBuilder: (context, index) {
        final n = index + 1;
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade400,
              child: Text('$n', style: const TextStyle(color: Colors.white)),
            ),
            title: Text(
              'List Item $n',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('This is item number #$n. The details go here.'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    ),
  );
}
