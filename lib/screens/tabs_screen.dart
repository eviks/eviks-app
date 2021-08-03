import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './auth_screen/auth_screen.dart';
import './posts_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Widget> _pages = [];
  int _selectedPageIndex = 0;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _pages = [
          PostScreen(),
          Text(AppLocalizations.of(context)!.tabsScreenCreate),
          const AuthScreen(),
        ];
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(CustomIcons.search),
              label: AppLocalizations.of(context)!.tabsScreenSearch),
          BottomNavigationBarItem(
              icon: const Icon(CustomIcons.plus),
              label: AppLocalizations.of(context)!.tabsScreenCreate),
          BottomNavigationBarItem(
              icon: const Icon(CustomIcons.settings),
              label: AppLocalizations.of(context)!.tabsScreenProfile),
        ],
      ),
    );
  }
}
