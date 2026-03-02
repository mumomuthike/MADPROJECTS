import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'my_table';

  static const columnId = '_id';
  static const columnName = 'name';
  static const columnAge = 'age';

  late Database _db;

  // Creates teh DB/opens it up
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Creating the table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnAge INTEGER NOT NULL
      )
    ''');
  }

  // CRUD

  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(table);
  }

  Future<int> queryRowCount() async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<int> update(Map<String, dynamic> row) async {
    int id = row[columnId];
    return await _db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    return await _db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  // Query by ID
  Future<Map<String, dynamic>?> queryById(int id) async {
    final rows = await _db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return rows.first;
  }

  // Delete all records
  Future<int> deleteAll() async {
    return await _db.delete(table);
  }
}
