// ignore_for_file: use_key_in_widget_constructors

import 'dashboard.dart';
import 'package:flutter/material.dart';
import 'tabItem.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({
    required this.onSelectTab,
    required this.tabs,
  });
  final ValueChanged<int> onSelectTab;
  final List<TabItem> tabs;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // selectedLabelStyle: TextStyle(color: Colors.black),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.grey[600],
      // backgroundColor: Colors.red,
      selectedFontSize: 12,

      items: tabs
          .map(
            (e) => _buildItem(
              index: e.getIndex(),
              icon: e.icon,
              tabName: e.tabName,
            ),
          )
          .toList(),
      onTap: (index) => onSelectTab(
        index,
      ),
    );
  }

  BottomNavigationBarItem _buildItem(
      {required int index, required IconData icon, required String tabName}) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _tabColor(index: index),
      ),
      label: tabName,
    );
  }

  Color _tabColor({required int index}) {
    return DashboardState.currentTab == index ? Colors.cyan : Colors.grey;
  }
}
