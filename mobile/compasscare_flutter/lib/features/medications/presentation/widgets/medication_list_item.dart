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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    medication.name,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (medication.critical)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Critical',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${medication.dosage} • ${medication.frequency}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Schedule: ${medication.time}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Last taken: ${medication.lastTaken ?? 'Not yet taken'}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              'Next due: ${medication.nextDue ?? 'Pending'}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.tonalIcon(
                  onPressed: isMarkingTaken || isRemoving ? null : onMarkTaken,
                  icon: isMarkingTaken
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(isMarkingTaken ? 'Marking...' : 'Mark Taken'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: isMarkingTaken || isRemoving ? null : onRemove,
                  icon: isRemoving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete_outline),
                  label: Text(isRemoving ? 'Removing...' : 'Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
