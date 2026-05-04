import 'package:compasscare_flutter/core/config/app_config.dart';
import 'package:compasscare_flutter/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:compasscare_flutter/features/care_team/data/models/care_team_member_model.dart';
import 'package:compasscare_flutter/features/care_team/presentation/pages/care_team_page.dart';
import 'package:compasscare_flutter/features/documents/presentation/pages/documents_page.dart';
import 'package:compasscare_flutter/features/shell/presentation/cubit/shell_header_cubit.dart';
import 'package:compasscare_flutter/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDeleting = false;

  Future<void> _openPrivacyPolicy() async {
    final privacyPolicyUrl = context.read<AppConfig>().privacyPolicyUrl;
    final uri = Uri.tryParse(privacyPolicyUrl);

    if (uri == null) {
      _showNotice('Privacy policy link is unavailable right now.');
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      _showNotice('Unable to open the privacy policy right now.');
    }
  }

  void _showNotice(String message) {
    if (!mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  void _openSection({required String title, required Widget page}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: page,
        ),
      ),
    );
  }

  Future<void> _confirmDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete account?'),
          content: const Text(
            'This permanently removes your account and signs you out.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      await context.read<AuthCubit>().deleteAccount();
    } catch (_) {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        messenger.hideCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: colorScheme.error,
          ),
        );
      },
      builder: (context, state) {
        final user = state.user;
        final name = user?.name.trim();
        final email = user?.email.trim() ?? '';
        final displayName = name == null || name.isEmpty ? 'Account' : name;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    _initials(displayName, email),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text('More', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.folder_open_outlined),
              title: const Text('Documents'),
              subtitle: const Text('Medical files and records'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () =>
                  _openSection(title: 'Documents', page: const DocumentsPage()),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.groups_outlined),
              title: const Text('Care Team'),
              subtitle: const Text('Family and caregiver contacts'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () =>
                  _openSection(title: 'Care Team', page: const CareTeamPage()),
            ),
            const SizedBox(height: 24),
            Text('Status', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            BlocBuilder<ShellHeaderCubit, ShellHeaderState>(
              builder: (context, headerState) {
                return _CareTeamStatusTile(state: headerState);
              },
            ),
            const SizedBox(height: 24),
            Text('Settings', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                final isLight = themeState.themeMode == ThemeMode.light;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    transitionBuilder: (child, animation) {
                      return RotationTransition(
                        turns: Tween<double>(
                          begin: -0.18,
                          end: 0,
                        ).animate(animation),
                        child: ScaleTransition(scale: animation, child: child),
                      );
                    },
                    child: Icon(
                      isLight
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                      key: ValueKey(isLight),
                    ),
                  ),
                  title: Text(isLight ? 'Dark Mode' : 'Light Mode'),
                  subtitle: Text(
                    isLight ? 'Use dark appearance' : 'Use light appearance',
                  ),
                  trailing: Switch(
                    value: !isLight,
                    onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                  ),
                  onTap: context.read<ThemeCubit>().toggleTheme,
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.open_in_new),
              onTap: _openPrivacyPolicy,
            ),
            const SizedBox(height: 24),
            Text('Account', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.email_outlined),
              title: const Text('Email'),
              subtitle: Text(email),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Sign Out'),
              onTap: _isDeleting
                  ? null
                  : () {
                      context.read<AuthCubit>().logout();
                    },
            ),
            const SizedBox(height: 24),
            Text(
              'Danger Zone',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.delete_forever_outlined,
                color: colorScheme.error,
              ),
              title: Text(
                'Delete Account',
                style: TextStyle(color: colorScheme.error),
              ),
              subtitle: const Text('Remove your account from CompassCare.'),
              trailing: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _isDeleting
                    ? const SizedBox(
                        key: ValueKey('deleting'),
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(
                        Icons.chevron_right,
                        key: ValueKey('delete-chevron'),
                      ),
              ),
              onTap: _isDeleting ? null : _confirmDeleteAccount,
            ),
          ],
        );
      },
    );
  }

  String _initials(String name, String email) {
    final source = name.trim().isNotEmpty ? name : email;
    final parts = source
        .trim()
        .split(RegExp(r'[\s@._-]+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);

    if (parts.isEmpty) {
      return '?';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}'
        .toUpperCase();
  }
}

class _CareTeamStatusTile extends StatelessWidget {
  const _CareTeamStatusTile({required this.state});

  final ShellHeaderState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final members = state.members.take(4).toList(growable: false);
    final onlineCount = state.members.where((member) => member.online).length;

    if (state.status == ShellHeaderStatus.loading && state.members.isEmpty) {
      return const ListTile(
        contentPadding: EdgeInsets.zero,
        leading: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        title: Text('Care team status'),
        subtitle: Text('Loading...'),
      );
    }

    if (state.members.isEmpty) {
      return const ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.groups_outlined),
        title: Text('Care team status'),
        subtitle: Text('No members available'),
      );
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
        width: 74,
        height: 34,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (var index = 0; index < members.length; index += 1)
              Positioned(
                left: (index * 18).toDouble(),
                child: _ProfileTeamAvatar(member: members[index]),
              ),
          ],
        ),
      ),
      title: const Text('Care team status'),
      subtitle: Text(
        state.isFromCache
            ? '$onlineCount online • cached'
            : '$onlineCount online • ${state.members.length} total',
      ),
      trailing: Icon(
        state.isFromCache
            ? Icons.cloud_off_outlined
            : Icons.check_circle_outline,
        color: state.isFromCache
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.secondary,
      ),
    );
  }
}

class _ProfileTeamAvatar extends StatelessWidget {
  const _ProfileTeamAvatar({required this.member});

  final CareTeamMemberModel member;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      key: Key('profile-team-avatar-${member.id}'),
      width: 30,
      height: 30,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              _initials(member.name),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            bottom: -1,
            right: -1,
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: member.online
                    ? const Color(0xFF16A34A)
                    : theme.colorScheme.onSurfaceVariant,
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.surface, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);

    if (parts.isEmpty) {
      return '?';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}'
        .toUpperCase();
  }
}
