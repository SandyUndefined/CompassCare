part of 'documents_bloc.dart';

sealed class DocumentsEvent extends Equatable {
  const DocumentsEvent();

  @override
  List<Object?> get props => [];
}

class DocumentsRequested extends DocumentsEvent {
  const DocumentsRequested();
}

class DocumentsRefreshed extends DocumentsEvent {
  const DocumentsRefreshed();
}

class DocumentsNoticeCleared extends DocumentsEvent {
  const DocumentsNoticeCleared();
}
