import 'package:compasscare_flutter/core/storage/app_database.dart';
import 'package:compasscare_flutter/features/appointments/data/models/appointment_model.dart';
import 'package:sqflite/sqflite.dart';

class AppointmentLocalDataSource {
  const AppointmentLocalDataSource({required AppDatabase database})
    : _database = database;

  static const _tableName = 'appointments_cache';

  final AppDatabase _database;

  Future<List<AppointmentModel>> fetchCachedAppointments() async {
    final db = await _database.open();
    final rows = await db.query(_tableName, orderBy: 'date ASC, time ASC');
    return rows
        .map((row) => AppointmentModel.fromDbMap(row))
        .toList(growable: false);
  }

  Future<void> replaceCachedAppointments(
    List<AppointmentModel> appointments,
  ) async {
    final db = await _database.open();

    await db.transaction((txn) async {
      await txn.delete(_tableName);

      if (appointments.isEmpty) {
        return;
      }

      final batch = txn.batch();
      for (final appointment in appointments) {
        batch.insert(
          _tableName,
          appointment.toDbMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Future<void> upsertCachedAppointment(AppointmentModel appointment) async {
    final db = await _database.open();
    await db.insert(
      _tableName,
      appointment.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCachedAppointment(int id) async {
    final db = await _database.open();
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
