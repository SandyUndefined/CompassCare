import 'package:compasscare_flutter/core/storage/app_database.dart';
import 'package:compasscare_flutter/features/medications/data/models/medication_model.dart';
import 'package:sqflite/sqflite.dart';

class MedicationLocalDataSource {
  const MedicationLocalDataSource({required AppDatabase database})
    : _database = database;

  static const _tableName = 'medications_cache';

  final AppDatabase _database;

  Future<List<MedicationModel>> fetchCachedMedications() async {
    final db = await _database.open();
    final rows = await db.query(_tableName, orderBy: 'name COLLATE NOCASE ASC');
    return rows
        .map((row) => MedicationModel.fromDbMap(row))
        .toList(growable: false);
  }

  Future<void> replaceCachedMedications(
    List<MedicationModel> medications,
  ) async {
    final db = await _database.open();

    await db.transaction((txn) async {
      await txn.delete(_tableName);

      if (medications.isEmpty) {
        return;
      }

      final batch = txn.batch();
      for (final medication in medications) {
        batch.insert(
          _tableName,
          medication.toDbMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Future<void> upsertCachedMedication(MedicationModel medication) async {
    final db = await _database.open();
    await db.insert(
      _tableName,
      medication.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCachedMedication(int id) async {
    final db = await _database.open();
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> nextLocalMedicationId() async {
    final db = await _database.open();
    final result = await db.rawQuery(
      'SELECT COALESCE(MAX(id), 99999) + 1 AS next_id FROM $_tableName',
    );
    return (result.first['next_id'] as int?) ?? 100000;
  }
}
