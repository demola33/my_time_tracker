import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/home_app.dart';

//enum TabItem { jobs, entries, account }
class TabItem {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
  int _index = 0;
  WidgetBuilder _page;
  TabItem({
    @required this.label,
    @required this.icon,
    @required this.backgroundColor,
    @required WidgetBuilder page,
  }) {
    _page = page;
  }

  void setIndex(int i) {
    _index = i;
  }

  int getIndex() => _index;

  Widget get page {
    return Visibility(
      visible: _index == HomeAppState.currentTab,
      maintainState: true,
      child: Navigator(
        key: key,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: _page,
          );
        },
      ),
    );
  }
}

// const List<TabItem> allTabs = <TabItem>[
//   TabItem('Jobs', Icons.work, Colors.deepOrangeAccent),
//   TabItem('Entries', Icons.view_headline, Colors.tealAccent),
//   TabItem('Account', Icons.account_circle, Colors.lightBlueAccent)
// ];

// class TabItemData {
//   const TabItemData({
//     @required this.label,
//     @required this.icon,
//     this.backgroundColor,
//   });

//   final String label;
//   final IconData icon;
//   final Color backgroundColor;

//   static const Map<TabItem, TabItemData> allTabs = {
//     TabItem.jobs: TabItemData(
//       label: 'Jobs',
//       icon: Icons.work,
//       backgroundColor: Colors.white,
//     ),
//     TabItem.entries: TabItemData(
//       label: 'Entries',
//       icon: Icons.view_headline,
//       //backgroundColor: Colors.tealAccent,
//     ),
//     TabItem.account: TabItemData(
//       label: 'Account',
//       icon: Icons.account_circle,
//       //backgroundColor: Colors.lightBlueAccent,
//     ),
//   };
// }
