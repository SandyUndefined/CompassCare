import 'package:compasscare_flutter/core/data/bundled_care_data.dart';
import 'package:compasscare_flutter/features/documents/data/datasources/document_local_data_source.dart';
import 'package:compasscare_flutter/features/documents/data/datasources/document_remote_data_source.dart';
import 'package:compasscare_flutter/features/documents/domain/repositories/documents_repository.dart';

class DocumentsRepositoryImpl implements DocumentsRepository {
  const DocumentsRepositoryImpl({
    required DocumentRemoteDataSource remoteDataSource,
    required DocumentLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final DocumentRemoteDataSource _remoteDataSource;
  final DocumentLocalDataSource _localDataSource;

  @override
  Future<DocumentsFetchResult> fetchDocuments() async {
    try {
      final documents = await _remoteDataSource.fetchDocuments();
      await _localDataSource.replaceCachedDocuments(documents);

      return DocumentsFetchResult(
        documents: documents,
        origin: DocumentDataOrigin.network,
      );
    } catch (_) {
      final cached = await _localDataSource.fetchCachedDocuments();
      if (cached.isNotEmpty) {
        return DocumentsFetchResult(
          documents: cached,
          origin: DocumentDataOrigin.cache,
        );
      }

      await _localDataSource.replaceCachedDocuments(BundledCareData.documents);
      return const DocumentsFetchResult(
        documents: BundledCareData.documents,
        origin: DocumentDataOrigin.cache,
      );
    }
  }
}
