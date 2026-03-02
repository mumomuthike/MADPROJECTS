import 'package:flutter/material.dart';
import 'database_helper.dart';

// global variable
final dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize the database
  await dbHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQlite Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // the homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('sqlite')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _btn(label: 'insert', onPressed: _insert),
                const SizedBox(height: 10),

                _btn(label: 'query', onPressed: _query),
                const SizedBox(height: 10),

                // Part 2 requirement: Query by ID
                _btn(label: 'query by id (1)', onPressed: _queryById),
                const SizedBox(height: 10),

                _btn(label: 'update', onPressed: _update),
                const SizedBox(height: 10),

                _btn(label: 'delete', onPressed: _delete),
                const SizedBox(height: 10),

                // Part 2 requirement: Delete All Records
                _btn(label: 'delete all', onPressed: () => _deleteAll(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _btn({required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(label),
        ),
      ),
    );
  }

  // Methods button

  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: 'Bob',
      DatabaseHelper.columnAge: 23,
    };

    final id = await dbHelper.insert(row);
    debugPrint('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    debugPrint('query all rows:');

    for (final row in allRows) {
      debugPrint(row.toString());
    }
  }

  // Query by ID
  void _queryById() async {
    const idToFind = 1;

    final row = await dbHelper.queryById(idToFind);
    if (row == null) {
      debugPrint('no row found for id: $idToFind');
      return;
    }

    debugPrint('query by id ($idToFind): $row');
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'Mary',
      DatabaseHelper.columnAge: 32,
    };

    final rowsAffected = await dbHelper.update(row);
    debugPrint('updated $rowsAffected row(s)');
  }

  void _delete() async {
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('deleted $rowsDeleted row(s): row $id');
  }

  //  Delete all the rows
  void _deleteAll(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete all records?'),
        content: const Text('This will remove every row from the table.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (ok != true) {
      debugPrint('delete all cancelled');
      return;
    }

    final rowsDeleted = await dbHelper.deleteAll();
    debugPrint('deleted ALL rows: $rowsDeleted');
  }
}
