import 'package:compasscare_flutter/core/storage/app_database.dart';
import 'package:compasscare_flutter/features/documents/data/models/document_model.dart';
import 'package:sqflite/sqflite.dart';

class DocumentLocalDataSource {
  const DocumentLocalDataSource({required AppDatabase database})
    : _database = database;

  static const _tableName = 'documents_cache';

  final AppDatabase _database;

  Future<List<DocumentModel>> fetchCachedDocuments() async {
    final db = await _database.open();
    final rows = await db.query(_tableName, orderBy: 'name COLLATE NOCASE ASC');
    return rows
        .map((row) => DocumentModel.fromDbMap(row))
        .toList(growable: false);
  }

  Future<void> replaceCachedDocuments(List<DocumentModel> documents) async {
    final db = await _database.open();

    await db.transaction((txn) async {
      await txn.delete(_tableName);

      if (documents.isEmpty) {
        return;
      }

      final batch = txn.batch();
      for (final document in documents) {
        batch.insert(
          _tableName,
          document.toDbMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }
}
