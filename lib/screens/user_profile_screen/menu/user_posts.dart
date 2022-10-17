import 'package:eviks_mobile/icons.dart';
import 'package:eviks_mobile/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './user_posts_tab_bar_view.dart';

class UserPosts extends StatefulWidget {
  @override
  _UserPostsState createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(text: AppLocalizations.of(context)!.activePosts),
              Tab(text: AppLocalizations.of(context)!.postsOnModeration),
            ],
          ),
          leading: Navigator.canPop(context)
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(CustomIcons.back),
                )
              : null,
          title: Text(
            AppLocalizations.of(context)!.myPosts,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            UserPostsTabBarView(
              postType: PostType.confirmed,
            ),
            UserPostsTabBarView(
              postType: PostType.unreviewed,
            )
          ],
        ),
      ),
    );
  }
}
