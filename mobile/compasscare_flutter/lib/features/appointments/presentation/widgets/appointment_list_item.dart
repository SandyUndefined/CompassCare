import 'package:compasscare_flutter/features/appointments/data/models/appointment_model.dart';
import 'package:flutter/material.dart';

class AppointmentListItem extends StatelessWidget {
  const AppointmentListItem({
    super.key,
    required this.appointment,
    required this.onRemove,
    this.isRemoving = false,
  });

  final AppointmentModel appointment;
  final VoidCallback onRemove;
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.calendar_month_outlined,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.type,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        appointment.doctor,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      appointment.date,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    if (appointment.time.trim().isNotEmpty)
                      Text(appointment.time, style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
            if (appointment.location.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.place_outlined, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      appointment.location,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
            if (appointment.assignedTo.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.group_outlined, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Assigned to: ${appointment.assignedTo}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
            if ((appointment.notes ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  appointment.notes!,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: isRemoving ? null : onRemove,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isRemoving
                      ? const SizedBox(
                          key: ValueKey('removing'),
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(
                          Icons.delete_outline,
                          key: ValueKey('remove'),
                        ),
                ),
                label: Text(isRemoving ? 'Removing' : 'Remove'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
