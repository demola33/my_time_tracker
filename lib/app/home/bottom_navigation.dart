import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/home_app.dart';
import 'package:my_time_tracker/app/home/tab_item.dart';
import 'package:my_time_tracker/common_widgets/custom_text_style.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation(
      {this.onSelectTab, this.tabs, @required this.currentIndex});
  final ValueChanged<int> onSelectTab;
  final List<TabItem> tabs;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: false,
      selectedLabelStyle: CustomTextStyles.textStyleBold(),
      items: tabs
          .map(
            (tabItem) => _buildItem(
              index: tabItem.getIndex(),
              icon: tabItem.icon,
              label: tabItem.label,
              backgroundColor: tabItem.backgroundColor,
            ),
          )
          .toList(),
      onTap: (index) => onSelectTab(index),
      type: BottomNavigationBarType.shifting,
      currentIndex: currentIndex,
    );
  }

  Color _tabColor({int index}) {
    return HomeAppState.currentTab == index
        ? Color.fromRGBO(241, 71, 23, 1)
        : Colors.grey[560];
  }

  BottomNavigationBarItem _buildItem({
    int index,
    IconData icon,
    String label,
    Color backgroundColor,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _tabColor(index: index),
      ),
      label: label,
      backgroundColor: backgroundColor,
    );
  }
}
