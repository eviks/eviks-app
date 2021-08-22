import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import './auth_screen/auth_screen.dart';
import './favorites_screen.dart';
import './new_post_screen.dart';
import './posts_screen.dart';
import './user_profile_screen/user_profile_screen.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Widget> _pages = [];
  int _selectedPageIndex = 0;
  var _isInit = true;
  var _isAuth = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _pages = [
          PostScreen(),
          FavoritesScreen(),
          const NewPostScreen(),
          const UserProfileScreen(),
        ];
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _selectPage(int index) {
    if (index > 0 && !_isAuth) {
      Navigator.pushNamed(context, AuthScreen.routeName);
    } else {
      setState(() {
        _selectedPageIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _isAuth = Provider.of<Auth>(context, listen: true).isAuth;
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        showUnselectedLabels: true,
        selectedFontSize: 12.0,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(CustomIcons.search),
              label: AppLocalizations.of(context)!.tabsScreenSearch),
          BottomNavigationBarItem(
              icon: const Icon(CustomIcons.heart),
              label: AppLocalizations.of(context)!.favorites),
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
