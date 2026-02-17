import 'package:flutter/material.dart';

import '../data/app_database.dart';
import '../features/equipment/equipment_list_page.dart';

/// Main enterprise shell: NavigationRail on wide screens, NavigationBar on narrow.
class AppShell extends StatefulWidget {
  final AppDatabase db;
  const AppShell({super.key, required this.db});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  List<_NavItem> get _items => [
        _NavItem(
          label: 'المعدات',
          icon: Icons.inventory_2_outlined,
          selectedIcon: Icons.inventory_2,
          builder: () => EquipmentListPage(db: widget.db),
        ),
        _NavItem(
          label: 'التقارير',
          icon: Icons.bar_chart_outlined,
          selectedIcon: Icons.bar_chart,
          builder: () => const _PlaceholderPage(
            title: 'التقارير',
            message: 'سنقوم ببناء التقارير بشكل احترافي في المرحلة القادمة.',
          ),
        ),
        _NavItem(
          label: 'الإعدادات',
          icon: Icons.settings_outlined,
          selectedIcon: Icons.settings,
          builder: () => const _PlaceholderPage(
            title: 'الإعدادات',
            message: 'هنا سنضيف إعدادات المؤسسة (الأقسام، المكاتب، المستخدمون...).',
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        final items = _items;
        final page = items[_index].builder();

        if (!isWide) {
          return Scaffold(
            body: page,
            bottomNavigationBar: NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: [
                for (final it in items)
                  NavigationDestination(
                    icon: Icon(it.icon),
                    selectedIcon: Icon(it.selectedIcon),
                    label: it.label,
                  ),
              ],
            ),
          );
        }

        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: _index,
                onDestinationSelected: (i) => setState(() => _index = i),
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (final it in items)
                    NavigationRailDestination(
                      icon: Icon(it.icon),
                      selectedIcon: Icon(it.selectedIcon),
                      label: Text(it.label),
                    ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: page),
            ],
          ),
        );
      },
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget Function() builder;
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.builder,
  });
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final String message;
  const _PlaceholderPage({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
