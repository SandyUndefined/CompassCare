import 'package:compasscare_flutter/features/documents/data/models/document_model.dart';
import 'package:compasscare_flutter/features/documents/domain/repositories/documents_repository.dart';
import 'package:compasscare_flutter/features/documents/presentation/bloc/documents_bloc.dart';
import 'package:compasscare_flutter/features/documents/presentation/widgets/document_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DocumentsBloc(repository: context.read<DocumentsRepository>())
            ..add(const DocumentsRequested()),
      child: const _DocumentsView(),
    );
  }
}

class _DocumentsView extends StatelessWidget {
  const _DocumentsView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DocumentsBloc, DocumentsState>(
      listenWhen: (previous, current) =>
          previous.notice?.id != current.notice?.id && current.notice != null,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) {
          return;
        }

        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(
            content: Text(notice.message),
            backgroundColor: notice.type == DocumentsNoticeType.error
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
          ),
        );
        context.read<DocumentsBloc>().add(const DocumentsNoticeCleared());
      },
      builder: (context, state) {
        if (state.isInitialLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == DocumentsStatus.failure &&
            state.documents.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 40),
                  const SizedBox(height: 12),
                  const Text(
                    'Could not load documents.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {
                      context.read<DocumentsBloc>().add(
                        const DocumentsRequested(),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<DocumentsBloc>().add(const DocumentsRefreshed());
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              if (state.isRefreshing)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: LinearProgressIndicator(),
                ),
              if (state.isFromCache)
                _CacheBanner(
                  onRetry: () {
                    context.read<DocumentsBloc>().add(
                      const DocumentsRefreshed(),
                    );
                  },
                ),
              if (state.documents.isEmpty)
                const _EmptyState()
              else
                ...state.documents.map(
                  (document) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: DocumentListItem(
                      document: document,
                      onTap: () => _openDocumentPreview(context, document),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _openDocumentPreview(BuildContext context, DocumentModel document) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _DocumentPreviewSheet(document: document),
    );
  }
}

class _DocumentPreviewSheet extends StatelessWidget {
  const _DocumentPreviewSheet({required this.document});

  final DocumentModel document;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          mediaQuery.viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    document.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 300),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _iconForType(document.type),
                    size: 52,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    document.type.toString().toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    document.date,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Preview source is not attached yet.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'The app currently receives document metadata only. Add a file URL or uploaded asset to render the full document here.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type.toUpperCase()) {
      case 'PDF':
        return Icons.picture_as_pdf_outlined;
      case 'CSV':
      case 'XLSX':
        return Icons.table_chart_outlined;
      case 'PNG':
      case 'JPG':
      case 'JPEG':
        return Icons.image_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }
}

class _CacheBanner extends StatelessWidget {
  const _CacheBanner({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.secondaryContainer,
      ),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off_outlined,
            color: theme.colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text('Showing cached documents. Pull to refresh or retry.'),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.folder_open_outlined, size: 36),
          SizedBox(height: 10),
          Text('No documents found.'),
        ],
      ),
    );
  }
}
