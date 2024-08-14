import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDb {
  static final LocalDb _instance = LocalDb._internal();
  factory LocalDb() => _instance;
  LocalDb._internal();

  Database? _database;

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the path to the database
    String path = join(await getDatabasesPath(), 'notifications.db');

    // Open the database, creating it if it doesn't exist
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the notifications table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        body TEXT,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  // Insert a new notification into the database
  Future<void> insertNotification(Map<String, dynamic> notification) async {
    final db = await database;
    await db.insert(
      'notifications',
      notification,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all notifications from the database
  Future<List<Map<String, dynamic>>> fetchAllNotifications() async {
    final db = await database;
    return await db.query('notifications', orderBy: 'timestamp DESC');
  }

  // Clear all notifications from the database
  Future<void> clearAllNotifications() async {
    final db = await database;
    await db.delete('notifications');
  }
}
