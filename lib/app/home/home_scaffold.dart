import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/tab_item.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';

import 'account/account_page.dart';
import 'entries/entries_page.dart';
import 'jobs/jobs_page.dart';

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({
    Key key,
    @required this.currentTabItem,
    @required this.onSelectTab,
    @required this.widgets,
    @required this.navigatorKeys,
    @required this.currentIndex,
  }) : super(key: key);

  final TabItem currentTabItem;
  final int currentIndex;
  final ValueChanged<int> onSelectTab;
  final Map<int, Widget> widgets;
  final Map<int, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  _HomeScaffoldState createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          JobsPage(),
          EntriesPage.create(context),
          AccountPage(),
        ].elementAt(index);
      }
    };
  }

  Widget _buildOffStageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: widget.currentIndex != index,
      child: Navigator(
        key: widget.navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            _buildOffStageNavigator(0),
            _buildOffStageNavigator(1),
            _buildOffStageNavigator(2),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _buildItem(TabItem.jobs),
          _buildItem(TabItem.entries),
          _buildItem(TabItem.account),
        ],
        type: BottomNavigationBarType.shifting,
        onTap: (index) => widget.onSelectTab(index),
        selectedItemColor: Colors.deepOrangeAccent,
        unselectedItemColor: Colors.grey[700].withOpacity(.60),
        backgroundColor: Colors.white,
        elevation: 5.0,
        currentIndex: widget.currentIndex,
        showUnselectedLabels: true,
        selectedLabelStyle: CustomTextStyles.textStyleBold(),
      ),
      // tabBuilder: (context, index) {
      //   final item = TabItem.values[index];
      //   return Center(
      //     child: CupertinoTabView(
      //       builder: (context) => widgetBuilders[item](context),
      //       navigatorKey: navigatorKeys[item],
      //     ),
      //   );
      // },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(itemData.icon),
      label: itemData.label,
      backgroundColor: itemData.backgroundColor,
    );
  }
}
