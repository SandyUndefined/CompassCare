part of 'documents_bloc.dart';

enum DocumentsStatus { initial, loading, success, failure }

enum DocumentsNoticeType { success, error }

class DocumentsNotice extends Equatable {
  const DocumentsNotice({
    required this.id,
    required this.message,
    required this.type,
  });

  final int id;
  final String message;
  final DocumentsNoticeType type;

  @override
  List<Object?> get props => [id, message, type];
}

class DocumentsState extends Equatable {
  const DocumentsState({
    this.status = DocumentsStatus.initial,
    this.documents = const [],
    this.isRefreshing = false,
    this.isFromCache = false,
    this.notice,
  });

  final DocumentsStatus status;
  final List<DocumentModel> documents;
  final bool isRefreshing;
  final bool isFromCache;
  final DocumentsNotice? notice;

  bool get isInitialLoading =>
      status == DocumentsStatus.loading && documents.isEmpty;

  DocumentsState copyWith({
    DocumentsStatus? status,
    List<DocumentModel>? documents,
    bool? isRefreshing,
    bool? isFromCache,
    DocumentsNotice? notice,
    bool clearNotice = false,
  }) {
    return DocumentsState(
      status: status ?? this.status,
      documents: documents ?? this.documents,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isFromCache: isFromCache ?? this.isFromCache,
      notice: clearNotice ? null : (notice ?? this.notice),
    );
  }

  @override
  List<Object?> get props => [
    status,
    documents,
    isRefreshing,
    isFromCache,
    notice,
  ];
}
