import 'package:compasscare_flutter/features/appointments/presentation/pages/appointments_page.dart';
import 'package:compasscare_flutter/features/care_team/data/models/care_team_member_model.dart';
import 'package:compasscare_flutter/features/care_team/presentation/pages/care_team_page.dart';
import 'package:compasscare_flutter/features/documents/presentation/pages/documents_page.dart';
import 'package:compasscare_flutter/features/medications/presentation/pages/medications_page.dart';
import 'package:compasscare_flutter/features/shopping/presentation/pages/shopping_page.dart';
import 'package:compasscare_flutter/features/shell/presentation/cubit/shell_cubit.dart';
import 'package:compasscare_flutter/features/shell/presentation/cubit/shell_header_cubit.dart';
import 'package:compasscare_flutter/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppShellPage extends StatefulWidget {
  const AppShellPage({super.key});

  @override
  State<AppShellPage> createState() => _AppShellPageState();
}

class _AppShellPageState extends State<AppShellPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<ShellHeaderCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _tabs;

    return BlocBuilder<ShellCubit, ShellState>(
      builder: (context, shellState) {
        final selectedTab = tabs[shellState.tabIndex];

        return Scaffold(
          appBar: AppBar(
            title: Text(selectedTab.label),
            actions: [
              BlocBuilder<ShellHeaderCubit, ShellHeaderState>(
                builder: (context, headerState) {
                  return _HeaderCareTeamAvatars(state: headerState);
                },
              ),
              BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, themeState) {
                  final isLight = themeState.themeMode == ThemeMode.light;
                  return IconButton(
                    onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                    tooltip: isLight ? 'Enable dark mode' : 'Enable light mode',
                    icon: Icon(isLight ? Icons.dark_mode : Icons.light_mode),
                  );
                },
              ),
            ],
          ),
          body: IndexedStack(
            index: shellState.tabIndex,
            children: [
              for (var index = 0; index < tabs.length; index += 1)
                shellState.loadedTabIndices.contains(index)
                    ? tabs[index].page
                    : const SizedBox.shrink(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: shellState.tabIndex,
            onDestinationSelected: context.read<ShellCubit>().selectTab,
            destinations: [
              for (final tab in tabs)
                NavigationDestination(icon: Icon(tab.icon), label: tab.label),
            ],
          ),
        );
      },
    );
  }

  static final List<_ShellTab> _tabs = [
    _ShellTab(
      label: 'Medications',
      icon: Icons.medication_outlined,
      page: const MedicationsPage(),
    ),
    _ShellTab(
      label: 'Appointments',
      icon: Icons.calendar_month_outlined,
      page: const AppointmentsPage(),
    ),
    _ShellTab(
      label: 'Documents',
      icon: Icons.folder_open_outlined,
      page: const DocumentsPage(),
    ),
    _ShellTab(
      label: 'Care Team',
      icon: Icons.groups_outlined,
      page: const CareTeamPage(),
    ),
    _ShellTab(
      label: 'Shopping',
      icon: Icons.shopping_bag_outlined,
      page: const ShoppingPage(),
    ),
  ];
}

class _ShellTab {
  const _ShellTab({
    required this.label,
    required this.icon,
    required this.page,
  });

  final String label;
  final IconData icon;
  final Widget page;
}

class _HeaderCareTeamAvatars extends StatelessWidget {
  const _HeaderCareTeamAvatars({required this.state});

  final ShellHeaderState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == ShellHeaderStatus.failure || state.members.isEmpty) {
      return const SizedBox.shrink();
    }

    final members = state.members.take(3).toList(growable: false);
    final extraCount = state.members.length - members.length;
    final stackWidth = 24 + ((members.length - 1) * 18);

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.isFromCache)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Tooltip(
                message: 'Showing cached care team status',
                child: Icon(Icons.cloud_off_outlined, size: 16),
              ),
            ),
          SizedBox(
            width: stackWidth.toDouble(),
            height: 30,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                for (var index = 0; index < members.length; index += 1)
                  Positioned(
                    left: (index * 18).toDouble(),
                    child: _HeaderTeamAvatar(member: members[index]),
                  ),
              ],
            ),
          ),
          if (extraCount > 0)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '+$extraCount',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeaderTeamAvatar extends StatelessWidget {
  const _HeaderTeamAvatar({required this.member});

  final CareTeamMemberModel member;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      key: Key('header-team-avatar-${member.id}'),
      width: 24,
      height: 24,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              _initials(member.name),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (member.online)
            Positioned(
              bottom: -1,
              right: -1,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 1,
                  ),
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

    final first = parts[0].substring(0, 1).toUpperCase();
    final second = parts[1].substring(0, 1).toUpperCase();
    return '$first$second';
  }
}
