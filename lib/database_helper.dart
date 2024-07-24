import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'expense.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'expenses.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE expenses(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, amount REAL, date TEXT, category TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertExpense(Expense expense) async {
    final db = await database;
    await db!.insert('expenses', expense.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('expenses');
    return List.generate(maps.length, (i) {
      return Expense(
        id: maps[i]['id'],
        title: maps[i]['title'],
        amount: maps[i]['amount'],
        date: DateTime.parse(maps[i]['date']),
        category: maps[i]['category'],
      );
    });
  }

  Future<void> updateExpense(Expense expense) async {
    final db = await database;
    await db!.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<void> deleteExpense(int id) async {
    final db = await database;
    await db!.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
