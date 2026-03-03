import 'package:compasscare_flutter/features/care_team/domain/repositories/care_team_repository.dart';
import 'package:compasscare_flutter/features/care_team/presentation/bloc/care_team_bloc.dart';
import 'package:compasscare_flutter/features/care_team/presentation/widgets/care_team_member_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CareTeamPage extends StatelessWidget {
  const CareTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CareTeamBloc(repository: context.read<CareTeamRepository>())
            ..add(const CareTeamRequested()),
      child: const _CareTeamView(),
    );
  }
}

class _CareTeamView extends StatelessWidget {
  const _CareTeamView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CareTeamBloc, CareTeamState>(
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
            backgroundColor: notice.type == CareTeamNoticeType.error
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
          ),
        );
        context.read<CareTeamBloc>().add(const CareTeamNoticeCleared());
      },
      builder: (context, state) {
        if (state.isInitialLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == CareTeamStatus.failure && state.members.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 40),
                  const SizedBox(height: 12),
                  const Text(
                    'Could not load care team.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {
                      context.read<CareTeamBloc>().add(
                        const CareTeamRequested(),
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
            context.read<CareTeamBloc>().add(const CareTeamRefreshed());
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
                    context.read<CareTeamBloc>().add(const CareTeamRefreshed());
                  },
                ),
              if (state.members.isEmpty)
                const _EmptyState()
              else
                ...state.members.map(
                  (member) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CareTeamMemberListItem(member: member),
                  ),
                ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.person_add_alt_1_outlined),
                      SizedBox(width: 8),
                      Text('Invite Care Team Member'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
            child: Text(
              'Showing cached care team data. Pull to refresh or retry.',
            ),
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
          Icon(Icons.groups_outlined, size: 36),
          SizedBox(height: 10),
          Text('No care team members found.'),
        ],
      ),
    );
  }
}
