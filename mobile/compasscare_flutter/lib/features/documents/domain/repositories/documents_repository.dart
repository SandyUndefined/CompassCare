import 'package:compasscare_flutter/features/documents/data/models/document_model.dart';
import 'package:equatable/equatable.dart';

enum DocumentDataOrigin { network, cache }

class DocumentsFetchResult extends Equatable {
  const DocumentsFetchResult({required this.documents, required this.origin});

  final List<DocumentModel> documents;
  final DocumentDataOrigin origin;

  @override
  List<Object?> get props => [documents, origin];
}

abstract class DocumentsRepository {
  Future<DocumentsFetchResult> fetchDocuments();
}
