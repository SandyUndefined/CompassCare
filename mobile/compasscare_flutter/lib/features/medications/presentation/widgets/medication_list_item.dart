import 'package:compasscare_flutter/features/medications/data/models/medication_model.dart';
import 'package:flutter/material.dart';

class MedicationListItem extends StatelessWidget {
  const MedicationListItem({
    super.key,
    required this.medication,
    required this.onMarkTaken,
    required this.onRemove,
    this.isMarkingTaken = false,
    this.isRemoving = false,
  });

  final MedicationModel medication;
  final VoidCallback onMarkTaken;
  final VoidCallback onRemove;
  final bool isMarkingTaken;
  final bool isRemoving;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.medication_outlined,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${medication.dosage} • ${medication.frequency}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (medication.critical)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Critical',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(
                  icon: Icons.schedule_outlined,
                  label: medication.time,
                ),
                _InfoChip(
                  icon: Icons.check_circle_outline,
                  label: medication.lastTaken ?? 'Not taken',
                ),
                _InfoChip(
                  icon: Icons.notifications_none_outlined,
                  label: medication.nextDue ?? 'Pending',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.tonalIcon(
                  onPressed: isMarkingTaken || isRemoving ? null : onMarkTaken,
                  icon: _AnimatedActionIcon(
                    loading: isMarkingTaken,
                    icon: Icons.check,
                  ),
                  label: Text(isMarkingTaken ? 'Saving' : 'Taken'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: isMarkingTaken || isRemoving ? null : onRemove,
                  icon: _AnimatedActionIcon(
                    loading: isRemoving,
                    icon: Icons.delete_outline,
                  ),
                  label: Text(isRemoving ? 'Removing' : 'Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 5),
          Text(label, style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _AnimatedActionIcon extends StatelessWidget {
  const _AnimatedActionIcon({required this.loading, required this.icon});

  final bool loading;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: loading
          ? const SizedBox(
              key: ValueKey('loading'),
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon, key: ValueKey(icon)),
    );
  }
}
