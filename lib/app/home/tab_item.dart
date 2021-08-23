import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/home_app.dart';

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
