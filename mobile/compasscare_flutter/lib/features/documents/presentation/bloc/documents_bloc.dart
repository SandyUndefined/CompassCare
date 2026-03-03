import 'package:compasscare_flutter/features/documents/data/models/document_model.dart';
import 'package:compasscare_flutter/features/documents/domain/repositories/documents_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'documents_event.dart';
part 'documents_state.dart';

class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  DocumentsBloc({required DocumentsRepository repository})
    : _repository = repository,
      super(const DocumentsState()) {
    on<DocumentsRequested>(_onDocumentsRequested);
    on<DocumentsRefreshed>(_onDocumentsRefreshed);
    on<DocumentsNoticeCleared>(_onDocumentsNoticeCleared);
  }

  final DocumentsRepository _repository;
  int _noticeCounter = 0;

  Future<void> _onDocumentsRequested(
    DocumentsRequested event,
    Emitter<DocumentsState> emit,
  ) async {
    await _fetchDocuments(emit, isRefresh: false);
  }

  Future<void> _onDocumentsRefreshed(
    DocumentsRefreshed event,
    Emitter<DocumentsState> emit,
  ) async {
    await _fetchDocuments(emit, isRefresh: true);
  }

  Future<void> _fetchDocuments(
    Emitter<DocumentsState> emit, {
    required bool isRefresh,
  }) async {
    if (isRefresh) {
      emit(state.copyWith(isRefreshing: true, clearNotice: true));
    } else {
      emit(state.copyWith(status: DocumentsStatus.loading, clearNotice: true));
    }

    try {
      final result = await _repository.fetchDocuments();
      emit(
        state.copyWith(
          status: DocumentsStatus.success,
          documents: result.documents,
          isFromCache: result.origin == DocumentDataOrigin.cache,
          isRefreshing: false,
          clearNotice: true,
        ),
      );
    } catch (_) {
      if (state.documents.isNotEmpty) {
        emit(
          state.copyWith(
            isRefreshing: false,
            notice: _createNotice(
              type: DocumentsNoticeType.error,
              message: 'Unable to refresh documents right now.',
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: DocumentsStatus.failure,
            isRefreshing: false,
            notice: _createNotice(
              type: DocumentsNoticeType.error,
              message: 'Unable to load documents. Please try again.',
            ),
          ),
        );
      }
    }
  }

  void _onDocumentsNoticeCleared(
    DocumentsNoticeCleared event,
    Emitter<DocumentsState> emit,
  ) {
    emit(state.copyWith(clearNotice: true));
  }

  DocumentsNotice _createNotice({
    required DocumentsNoticeType type,
    required String message,
  }) {
    _noticeCounter += 1;
    return DocumentsNotice(id: _noticeCounter, message: message, type: type);
  }
}
