import 'package:compasscare_flutter/features/shopping/domain/models/shopping_models.dart';
import 'package:compasscare_flutter/features/shopping/domain/repositories/shopping_repository.dart';
import 'package:compasscare_flutter/features/shopping/presentation/bloc/shopping_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ShoppingBloc(repository: context.read<ShoppingRepository>())
            ..add(const ShoppingRequested()),
      child: const _ShoppingView(),
    );
  }
}

class _ShoppingView extends StatelessWidget {
  const _ShoppingView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShoppingBloc, ShoppingState>(
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
            backgroundColor: notice.type == ShoppingNoticeType.error
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
          ),
        );
        context.read<ShoppingBloc>().add(const ShoppingNoticeCleared());
      },
      builder: (context, state) {
        if (state.isInitialLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == ShoppingStatus.failure && state.data == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 40),
                  const SizedBox(height: 12),
                  const Text(
                    'Could not load shopping suggestions.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () {
                      context.read<ShoppingBloc>().add(
                        const ShoppingRequested(),
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

        final data = state.data;
        if (data == null) {
          return const SizedBox.shrink();
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<ShoppingBloc>().add(const ShoppingRefreshed());
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Text(
                'Care Supplies & Medications',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                'Quick access to essential care supplies with convenient delivery options.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              if (state.isRefreshing)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: LinearProgressIndicator(),
                ),
              if (state.isFromCache || state.isStaticOnly)
                _CacheBanner(
                  message: state.isStaticOnly
                      ? 'Showing shopping links without personalized medication suggestions.'
                      : 'Showing cached personalized shopping suggestions.',
                  onRetry: () {
                    context.read<ShoppingBloc>().add(const ShoppingRefreshed());
                  },
                ),
              _FeaturedLinksGrid(
                links: data.featuredLinks,
                onTap: (link) => _openLink(context, link),
              ),
              const SizedBox(height: 20),
              Text(
                'Shop by Category',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              _CategoryLinksGrid(
                links: data.categoryLinks,
                onTap: (link) => _openLink(context, link),
              ),
              const SizedBox(height: 16),
              if (data.medicationNames.isNotEmpty)
                _MedicationSuggestionCard(
                  medicationNames: data.medicationNames,
                  onTapLink: (link) => _openLink(context, link),
                ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Shopping convenience: CompassCare may earn a commission from qualifying purchases. This helps keep the app free.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
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

  Future<void> _openLink(BuildContext context, ShoppingLink link) async {
    final uri = Uri.tryParse(link.url);
    if (uri == null) {
      _showLinkError(context, 'Invalid link for ${link.title}.');
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      _showLinkError(context, 'Unable to open ${link.title} right now.');
    }
  }

  void _showLinkError(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

class _FeaturedLinksGrid extends StatelessWidget {
  const _FeaturedLinksGrid({required this.links, required this.onTap});

  final List<ShoppingLink> links;
  final ValueChanged<ShoppingLink> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSingleColumn = constraints.maxWidth < 520;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: links
              .map((link) {
                return SizedBox(
                  width: isSingleColumn
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 10) / 2,
                  child: _ShoppingLinkCard(
                    link: link,
                    icon: link.id.contains('monitoring')
                        ? Icons.monitor_heart_outlined
                        : Icons.medication_outlined,
                    highlighted: true,
                    onTap: () => onTap(link),
                  ),
                );
              })
              .toList(growable: false),
        );
      },
    );
  }
}

class _CategoryLinksGrid extends StatelessWidget {
  const _CategoryLinksGrid({required this.links, required this.onTap});

  final List<ShoppingLink> links;
  final ValueChanged<ShoppingLink> onTap;

  IconData _iconFor(String id) {
    if (id.contains('daily-living')) return Icons.favorite_border;
    if (id.contains('mobility')) return Icons.accessible_forward_outlined;
    if (id.contains('medical')) return Icons.healing_outlined;
    if (id.contains('nutrition')) return Icons.restaurant_outlined;
    return Icons.shield_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 860
            ? 3
            : constraints.maxWidth > 520
            ? 2
            : 1;
        final cardWidth =
            (constraints.maxWidth - ((columns - 1) * 10)) / columns;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: links
              .map(
                (link) => SizedBox(
                  width: cardWidth,
                  child: _ShoppingLinkCard(
                    link: link,
                    icon: _iconFor(link.id),
                    onTap: () => onTap(link),
                  ),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _ShoppingLinkCard extends StatelessWidget {
  const _ShoppingLinkCard({
    required this.link,
    required this.icon,
    required this.onTap,
    this.highlighted = false,
  });

  final ShoppingLink link;
  final IconData icon;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: highlighted ? theme.colorScheme.primaryContainer : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: highlighted
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.primary,
              ),
              const SizedBox(height: 10),
              Text(
                link.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: highlighted
                      ? theme.colorScheme.onPrimaryContainer
                      : null,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                link.subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: highlighted
                      ? theme.colorScheme.onPrimaryContainer.withValues(
                          alpha: 0.8,
                        )
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MedicationSuggestionCard extends StatelessWidget {
  const _MedicationSuggestionCard({
    required this.medicationNames,
    required this.onTapLink,
  });

  final List<String> medicationNames;
  final ValueChanged<ShoppingLink> onTapLink;

  @override
  Widget build(BuildContext context) {
    final links = [
      ShoppingLink(
        id: 'recommend-pill-organizer',
        title: 'Weekly Pill Organizer',
        subtitle: _subtitleForMeds(medicationNames),
        url: compassCareAmazonStoreUrl,
      ),
      const ShoppingLink(
        id: 'recommend-pill-reminder',
        title: 'Medication Reminder Timer',
        subtitle: 'Never miss a dose with audio alerts',
        url: compassCareAmazonStoreUrl,
      ),
    ];

    return Card(
      color: Theme.of(
        context,
      ).colorScheme.primaryContainer.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Based on Your Medications',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Supplies that might help with managing your medication list:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            ...links.map(
              (link) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton(
                  onPressed: () => onTapLink(link),
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(link.title),
                            const SizedBox(height: 2),
                            Text(
                              link.subtitle,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_outward, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _subtitleForMeds(List<String> names) {
    if (names.isEmpty) {
      return 'Easy way to organize daily medications';
    }
    if (names.length == 1) {
      return 'Helpful for ${names.first}';
    }
    return 'Helpful for ${names.take(2).join(' & ')}';
  }
}

class _CacheBanner extends StatelessWidget {
  const _CacheBanner({required this.message, required this.onRetry});

  final String message;
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
          Expanded(child: Text(message)),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
