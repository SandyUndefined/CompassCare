import 'package:compasscare_flutter/core/storage/app_database.dart';
import 'package:compasscare_flutter/features/care_team/data/models/care_team_member_model.dart';
import 'package:sqflite/sqflite.dart';

class CareTeamLocalDataSource {
  const CareTeamLocalDataSource({required AppDatabase database})
    : _database = database;

  static const _tableName = 'care_team_cache';

  final AppDatabase _database;

  Future<List<CareTeamMemberModel>> fetchCachedCareTeamMembers() async {
    final db = await _database.open();
    final rows = await db.query(_tableName, orderBy: 'name COLLATE NOCASE ASC');
    return rows
        .map((row) => CareTeamMemberModel.fromDbMap(row))
        .toList(growable: false);
  }

  Future<void> replaceCachedCareTeamMembers(
    List<CareTeamMemberModel> members,
  ) async {
    final db = await _database.open();

    await db.transaction((txn) async {
      await txn.delete(_tableName);

      if (members.isEmpty) {
        return;
      }

      final batch = txn.batch();
      for (final member in members) {
        batch.insert(
          _tableName,
          member.toDbMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }
}
