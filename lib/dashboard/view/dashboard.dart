// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:live_for_better/dashboard/view/dashboard_view.dart';
import 'package:live_for_better/dashboard/view/profile.dart';
import 'package:live_for_better/student/view/student_dashboard.dart';
import 'package:live_for_better/student/view/student_registration.dart';
import 'package:live_for_better/student/view/students_registered_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tabItem.dart';
import 'bottomNavigation.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  // this is static property so other widget throughout the app
  // can access it simply by AppState.currentTab
  static int currentTab = 0;

  // list tabs here
  final List<TabItem> tabs = [
    TabItem(
      tabName: "",
      icon: Icons.home,
      page: DashboardView(),
    ),
    TabItem(
      tabName: "",
      icon: Icons.cast_for_education,
      page: StudentDashboard(),
    ),
    TabItem(
      tabName: "",
      icon: Icons.question_mark,
      page: Profile(),
    ),
    // TabItem(
    //   tabName: "Notification",
    //   icon: Icons.notifications,
    //   page: Notifications(),
    // ),
    TabItem(
      tabName: "",
      icon: Icons.admin_panel_settings,
      page: Profile(),
    ),
  ];

  DashboardState() {
    // indexing is necessary for proper funcationality
    // of determining which tab is active
    tabs.asMap().forEach((index, details) {
      details.setIndex(index);
    });
  }

  // sets current tab index
  // and update state
  void _selectTab(int index) {
    if (index == currentTab) {
      // pop to first route
      // if the user taps on the active tab
      tabs[index].key.currentState?.popUntil((route) => route.isFirst);
      print("i");
    } else {
      // update the state
      // in order to repaint
      setState(() => currentTab = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope handle android back btn
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await tabs[currentTab].key.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (currentTab != 0) {
            // select 'main' tab
            _selectTab(0);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      // this is the base scaffold
      // don't put appbar in here otherwise you might end up
      // with multiple appbars on one screen
      // eventually breaking the app
      child: Scaffold(
        // indexed stack shows only one child
        body: IndexedStack(
          index: currentTab,
          children: tabs.map((e) => e.page).toList(),
        ),
        // Bottom navigation

        bottomNavigationBar: BottomNavigation(
          onSelectTab: _selectTab,
          tabs: tabs,
        ),
      ),
    );
  }
}
