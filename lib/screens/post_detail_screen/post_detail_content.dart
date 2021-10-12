import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/post.dart';
import './post_detail_main_info.dart';
import './post_detail_map.dart';

class PostDetailContent extends StatelessWidget {
  final Post post;

  const PostDetailContent(this.post);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostDetailMainInfo(post: post),
              Divider(
                color: Theme.of(context).dividerColor,
              ),
              _ContentTitle(
                  AppLocalizations.of(context)!.postDetailDescription),
              Text(
                post.description,
                style: const TextStyle(fontSize: 16.0),
              ),
              _ContentTitle(AppLocalizations.of(context)!.postDetailLocation),
              SizedBox(
                height: 200.0,
                child: PostDetailMap(post.location),
              )
            ],
          ),
        ),
      ]),
    );
  }
}

class _ContentTitle extends StatelessWidget {
  final String title;

  const _ContentTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
