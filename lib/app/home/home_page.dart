import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/account/account_page.dart';
import 'package:my_time_tracker/app/home/entries/entries_page.dart';
import 'package:my_time_tracker/app/home/home_scaffold.dart';
import 'package:my_time_tracker/app/home/tab_item.dart';

import 'jobs/jobs_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;
  int _selectedIndex = 0;

  final Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
  };

  Map<int, Widget> get widgets {
    return {
      0: JobsPage(),
      1: EntriesPage.create(context),
      2: AccountPage(),
    };
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      navigatorKeys[index].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_selectedIndex].currentState.maybePop(),
      child: HomeScaffold(
        navigatorKeys: navigatorKeys,
        currentTabItem: _currentTab,
        onSelectTab: _onItemTapped,
        widgets: widgets,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
