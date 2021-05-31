import 'package:flutter/material.dart';

enum TabItem { jobs, entries, account }

class TabItemData {
  const TabItemData({
    @required this.label,
    @required this.icon,
    this.backgroundColor,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.jobs: TabItemData(
      label: 'Jobs',
      icon: Icons.work,
      //backgroundColor: Colors.white,
    ),
    TabItem.entries: TabItemData(
      label: 'Entries',
      icon: Icons.view_headline,
      //backgroundColor: Colors.tealAccent,
    ),
    TabItem.account: TabItemData(
      label: 'Account',
      icon: Icons.account_circle,
      //backgroundColor: Colors.lightBlueAccent,
    ),
  };
}
