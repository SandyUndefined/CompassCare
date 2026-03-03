import 'package:compasscare_flutter/features/appointments/presentation/pages/appointments_page.dart';
import 'package:compasscare_flutter/features/care_team/data/models/care_team_member_model.dart';
import 'package:compasscare_flutter/features/care_team/presentation/pages/care_team_page.dart';
import 'package:compasscare_flutter/features/documents/presentation/pages/documents_page.dart';
import 'package:compasscare_flutter/features/medications/presentation/pages/medications_page.dart';
import 'package:compasscare_flutter/features/shopping/presentation/pages/shopping_page.dart';
import 'package:compasscare_flutter/features/shell/presentation/cubit/shell_cubit.dart';
import 'package:compasscare_flutter/features/shell/presentation/cubit/shell_header_cubit.dart';
import 'package:compasscare_flutter/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
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
        final colorScheme = Theme.of(context).colorScheme;
        final screenWidth = MediaQuery.sizeOf(context).width;
        final horizontalMargin = screenWidth < 360
            ? 2.0
            : screenWidth < 400
            ? 6.0
            : 10.0;
        final horizontalItemPadding = screenWidth < 360
            ? 1.0
            : screenWidth < 400
            ? 3.0
            : 6.0;
        final navRowWidth = screenWidth - (horizontalMargin * 2);
        final tabItemWidth =
            ((navRowWidth / tabs.length) - (horizontalItemPadding * 2)).clamp(
              42.0,
              84.0,
            );
        final tabLabelFontSize = (tabItemWidth / 6.2).clamp(8.0, 12.0);
        final tabIconSize = (tabItemWidth / 2.9).clamp(16.0, 22.0);
        final tabLabelSpacing = tabLabelFontSize < 9 ? 1.0 : 2.0;
        final verticalItemPadding = screenWidth < 360 ? 6.0 : 8.0;

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
          bottomNavigationBar: DotNavigationBar(
            currentIndex: shellState.tabIndex,
            onTap: context.read<ShellCubit>().selectTab,
            enableFloatingNavBar: false,
            enablePaddingAnimation: false,
            backgroundColor: colorScheme.surface,
            dotIndicatorColor: colorScheme.primaryContainer,
            selectedItemColor: colorScheme.primary,
            unselectedItemColor: colorScheme.onSurfaceVariant,
            splashColor: colorScheme.primary.withAlpha(24),
            margin: EdgeInsets.fromLTRB(
              horizontalMargin,
              8,
              horizontalMargin,
              10,
            ),
            itemPadding: EdgeInsets.symmetric(
              vertical: verticalItemPadding,
              horizontal: horizontalItemPadding,
            ),
            items: [
              for (final tab in tabs)
                DotNavigationBarItem(
                  icon: _DotTabItemContent(
                    icon: tab.icon,
                    label: tab.label,
                    itemWidth: tabItemWidth,
                    iconSize: tabIconSize,
                    labelFontSize: tabLabelFontSize,
                    labelSpacing: tabLabelSpacing,
                  ),
                ),
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

class _DotTabItemContent extends StatelessWidget {
  const _DotTabItemContent({
    required this.icon,
    required this.label,
    required this.itemWidth,
    required this.iconSize,
    required this.labelFontSize,
    required this.labelSpacing,
  });

  final IconData icon;
  final String label;
  final double itemWidth;
  final double iconSize;
  final double labelFontSize;
  final double labelSpacing;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final iconColor = iconTheme.color;

    return SizedBox(
      width: itemWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, semanticLabel: label, size: iconSize),
          SizedBox(height: labelSpacing),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Merriweather',
              fontSize: labelFontSize,
              height: 1.1,
              color: iconColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
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
