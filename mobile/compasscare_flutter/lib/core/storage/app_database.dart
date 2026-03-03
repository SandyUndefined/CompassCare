import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const _databaseName = 'compasscare.db';
  static const _databaseVersion = 5;

  Database? _database;

  Future<Database> open() async {
    if (_database != null) {
      return _database!;
    }

    final databasesPath = await getDatabasesPath();
    final databasePath = p.join(databasesPath, _databaseName);

    _database = await openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: (db, _) async {
        await _createCoreTables(db);
      },
      onUpgrade: (db, oldVersion, _) async {
        if (oldVersion < 2) {
          await _createMedicationCacheTable(db);
        }
        if (oldVersion < 3) {
          await _createAppointmentCacheTable(db);
        }
        if (oldVersion < 4) {
          await _createDocumentCacheTable(db);
        }
        if (oldVersion < 5) {
          await _createCareTeamCacheTable(db);
        }
      },
    );

    return _database!;
  }

  Future<void> close() async {
    if (_database == null) {
      return;
    }
    await _database!.close();
    _database = null;
  }

  Future<void> _createCoreTables(Database db) async {
    await db.execute('''
      CREATE TABLE app_metadata (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    await _createMedicationCacheTable(db);
    await _createAppointmentCacheTable(db);
    await _createDocumentCacheTable(db);
    await _createCareTeamCacheTable(db);

    await db.insert('app_metadata', {
      'key': 'created_at',
      'value': DateTime.now().toUtc().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> _createMedicationCacheTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS medications_cache (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        frequency TEXT NOT NULL,
        time TEXT NOT NULL,
        last_taken TEXT,
        next_due TEXT,
        critical INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> _createAppointmentCacheTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS appointments_cache (
        id INTEGER PRIMARY KEY,
        type TEXT NOT NULL,
        doctor TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        location TEXT NOT NULL,
        assigned_to TEXT NOT NULL,
        notes TEXT
      )
    ''');
  }

  Future<void> _createDocumentCacheTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS documents_cache (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        type TEXT NOT NULL
      )
    ''');
  }

  Future<void> _createCareTeamCacheTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS care_team_cache (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        role TEXT NOT NULL,
        online INTEGER NOT NULL DEFAULT 0,
        last_active TEXT
      )
    ''');
  }
}
