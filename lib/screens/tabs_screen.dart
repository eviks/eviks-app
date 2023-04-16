import 'package:eviks_mobile/icons.dart';
import 'package:eviks_mobile/models/user.dart';
import 'package:eviks_mobile/screens/post_review_screen/post_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import './auth_screen/auth_screen.dart';
import './favorites_screen/favorites_screen.dart';
import './new_post_screen.dart';
import './posts_screen.dart';
import './user_profile_screen/user_profile_screen.dart';
import '../providers/auth.dart';

enum Pages { postReview, posts, favorites, newPost, userProfile }

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
  UserRole _userRole = UserRole.user;
  Map<Pages, int> pages = {};

  int getPageIndex() {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    final pageValue = arguments != null ? arguments as Pages : Pages.posts;
    final pageIndex = pages[pageValue] ?? 0;
    return pageIndex;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      pages = {
        Pages.posts: 0,
        Pages.favorites: 1,
        Pages.newPost: 2,
        Pages.userProfile: 3
      };

      final pageIndex = getPageIndex();

      setState(() {
        _selectedPageIndex = pageIndex;
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
    if (index != 0 && index != 3 && !_isAuth) {
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

    final _currentUserRole = Provider.of<Auth>(
      context,
      listen: true,
    ).userRole;

    if (_currentUserRole == UserRole.moderator) {
      pages = {
        Pages.postReview: 0,
        Pages.posts: 1,
        Pages.favorites: 2,
        Pages.newPost: 3,
        Pages.userProfile: 4
      };
    } else {
      pages = {
        Pages.posts: 0,
        Pages.favorites: 1,
        Pages.newPost: 2,
        Pages.userProfile: 3
      };
    }

    final pageIndex = getPageIndex();

    if (_userRole != _currentUserRole) {
      setState(() {
        _userRole = _currentUserRole;
        _selectedPageIndex = pageIndex;
        _pages = [
          if (_currentUserRole == UserRole.moderator) const PostReviewScreen(),
          PostScreen(),
          FavoritesScreen(),
          const NewPostScreen(),
          const UserProfileScreen(),
        ];
      });
    }

    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        showUnselectedLabels: true,
        selectedFontSize: 12.0,
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        items: [
          if (_currentUserRole == UserRole.moderator)
            BottomNavigationBarItem(
              icon: const Icon(CustomIcons.shield),
              label: AppLocalizations.of(context)!.postReview,
            ),
          BottomNavigationBarItem(
            icon: const Icon(CustomIcons.search),
            label: AppLocalizations.of(context)!.tabsScreenSearch,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CustomIcons.heart),
            label: AppLocalizations.of(context)!.favorites,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CustomIcons.plus),
            label: AppLocalizations.of(context)!.tabsScreenCreate,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CustomIcons.settings),
            label: AppLocalizations.of(context)!.tabsScreenProfile,
          ),
        ],
      ),
    );
  }
}
