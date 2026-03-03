import 'package:compasscare_flutter/features/care_team/data/models/care_team_member_model.dart';
import 'package:flutter/material.dart';

class CareTeamMemberListItem extends StatelessWidget {
  const CareTeamMemberListItem({super.key, required this.member});

  final CareTeamMemberModel member;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  child: Text(
                    member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: member.online
                          ? const Color(0xFF16A34A)
                          : const Color(0xFF64748B),
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.name, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(member.role, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 2),
                  Text(
                    member.online
                        ? 'Online'
                        : member.lastActive == null
                        ? 'Offline'
                        : 'Last active: ${member.lastActive}',
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: null,
              icon: const Icon(Icons.message_outlined),
              label: const Text('Message'),
            ),
          ],
        ),
      ),
    );
  }
}
