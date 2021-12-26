import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import './post_detail_content.dart';
import './post_detail_header.dart';
import '../../constants.dart';
import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/post-detail';

  @override
  Widget build(BuildContext context) {
    final postId = ModalRoute.of(context)!.settings.arguments! as int;
    final loadedPost =
        Provider.of<Posts>(context, listen: false).findById(postId);
    final headerHeight =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? 50.0
            : 70.0;
    SizeConfig().init(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              delegate: PostDetailHeader(
                  images: loadedPost.images,
                  height: SizeConfig.safeBlockVertical * headerHeight)),
          SliverAppBar(
            leading: Navigator.canPop(context)
                ? IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(CustomIcons.back),
                  )
                : null,
            title: Text(
              currencyFormat.format(loadedPost.price),
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
            pinned: true,
          ),
          PostDetailContent(
            loadedPost,
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StyledElevatedButton(
          text: AppLocalizations.of(context)!.call,
          suffixIcon: CustomIcons.phonecall,
          onPressed: () async {
            launch('tel://${loadedPost.contact}');
          },
        ),
      ),
    );
  }
}
