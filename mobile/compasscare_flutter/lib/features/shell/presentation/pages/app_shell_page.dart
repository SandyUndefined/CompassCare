import 'package:compasscare_flutter/features/appointments/presentation/pages/appointments_page.dart';
import 'package:compasscare_flutter/features/medications/presentation/pages/medications_page.dart';
import 'package:compasscare_flutter/features/profile/presentation/pages/profile_page.dart';
import 'package:compasscare_flutter/features/shopping/presentation/pages/shopping_page.dart';
import 'package:compasscare_flutter/features/shell/presentation/cubit/shell_cubit.dart';
import 'package:compasscare_flutter/features/shell/presentation/cubit/shell_header_cubit.dart';
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
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: Text(selectedTab.label, key: ValueKey(selectedTab.label)),
            ),
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
              for (var index = 0; index < tabs.length; index += 1)
                DotNavigationBarItem(
                  icon: _DotTabItemContent(
                    icon: tabs[index].icon,
                    label: tabs[index].label,
                    selected: shellState.tabIndex == index,
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
      label: 'Shopping',
      icon: Icons.shopping_bag_outlined,
      page: const ShoppingPage(),
    ),
    _ShellTab(
      label: 'Profile',
      icon: Icons.person_outline,
      page: const ProfilePage(),
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
    required this.selected,
    required this.itemWidth,
    required this.iconSize,
    required this.labelFontSize,
    required this.labelSpacing,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final double itemWidth;
  final double iconSize;
  final double labelFontSize;
  final double labelSpacing;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final iconColor = iconTheme.color;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: itemWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(end: selected ? 1 : 0),
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 1 + (value * 0.14),
                child: Container(
                  width: iconSize + 12,
                  height: iconSize + 12,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color.lerp(
                      Colors.transparent,
                      colorScheme.primaryContainer.withAlpha(130),
                      value,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: child,
                ),
              );
            },
            child: Icon(icon, semanticLabel: label, size: iconSize),
          ),
          SizedBox(height: labelSpacing),
          AnimatedOpacity(
            opacity: selected ? 1 : 0.68,
            duration: const Duration(milliseconds: 180),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: labelFontSize,
                height: 1.1,
                color: iconColor,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
