import 'package:flutter/material.dart';
import 'package:my_time_tracker/app/home/account/account_page.dart';
import 'package:my_time_tracker/app/home/account/account_page_manager.dart';
import 'package:my_time_tracker/app/home/bottom_navigation.dart';
import 'package:my_time_tracker/app/home/entries/entries_page.dart';
import 'package:my_time_tracker/app/home/jobs/jobs_page.dart';
import 'package:my_time_tracker/models_and_managers/models/custom_user_model.dart';
import 'package:my_time_tracker/app/home/tab_item.dart';
import 'package:my_time_tracker/services/connectivity_provider.dart';
import 'package:my_time_tracker/services/database.dart';
import 'package:provider/provider.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({Key key}) : super(key: key);

  @override
  HomeAppState createState() => HomeAppState();
}

class HomeAppState extends State<HomeApp>
    with TickerProviderStateMixin<HomeApp> {
  List<Key> _tabItemKeys;
  List<AnimationController> _faders;
  static int currentTab = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    _faders = tabs.map<AnimationController>((TabItem tabItem) {
      return AnimationController(
          vsync: this, duration: Duration(milliseconds: 200));
    }).toList();
    _faders[currentTab].value = 1.0;
    _tabItemKeys =
        List<Key>.generate(tabs.length, (index) => GlobalKey()).toList();
  }

  @override
  void dispose() {
    for (AnimationController controller in _faders) controller.dispose();
    super.dispose();
  }

  final List<TabItem> tabs = [
    TabItem(
      label: 'Jobs',
      icon: Icons.work,
      page: (_) => JobsPage(),
      backgroundColor: Color.fromRGBO(0, 195, 111, 0.5),
    ),
    TabItem(
      label: 'Entries',
      icon: Icons.view_headline,
      page: (context) => EntriesPage.create(context),
      backgroundColor: Color.fromRGBO(0, 88, 72, 0.5),
    ),
    TabItem(
      label: 'Account',
      icon: Icons.account_circle,
      page: (_) => AccountPage(
        manager: AccountPageManager(),
      ),
      backgroundColor: Color.fromRGBO(0, 144, 144, 0.5),
    )
  ];

  HomeAppState() {
    tabs.asMap().forEach((index, tabItem) {
      tabItem.setIndex(index);
    });
  }

  void _selectTab(int index) {
    if (index == currentTab) {
      tabs[index].key.currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => currentTab = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await tabs[currentTab].key.currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (currentTab != 0) {
            _selectTab(0);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: StreamProvider<CustomUser>.value(
        initialData: null,
        value: database.userProfileStream(),
        child: Scaffold(
          extendBody: true,
          body: SafeArea(
            top: false,
            child: IndexedStack(
              sizing: StackFit.expand,
              index: currentTab,
              children: tabs.map((tabItem) {
                final Widget view = FadeTransition(
                  opacity: _faders[tabItem.getIndex()]
                      .drive(CurveTween(curve: Curves.fastOutSlowIn)),
                  child: KeyedSubtree(
                    key: _tabItemKeys[tabItem.getIndex()],
                    child: tabItem.page,
                  ),
                );
                if (tabItem.getIndex() == currentTab) {
                  _faders[tabItem.getIndex()].forward();
                  return view;
                } else {
                  _faders[tabItem.getIndex()].reverse();
                  if (_faders[tabItem.getIndex()].isAnimating) {
                    return IgnorePointer(child: view);
                  }
                  return Offstage(child: view);
                }
              }).toList(),
            ),
          ),
          bottomNavigationBar: BottomNavigation(
            onSelectTab: _selectTab,
            currentIndex: currentTab,
            tabs: tabs,
          ),
        ),
      ),
    );
  }
}
