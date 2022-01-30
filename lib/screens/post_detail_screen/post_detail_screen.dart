import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import './post_detail_content.dart';
import './post_detail_header.dart';
import '../../constants.dart';
import '../../providers/auth.dart';
import '../../providers/posts.dart';
import '../../widgets/post_buttons/edit_post_button.dart';
import '../../widgets/post_buttons/favorite_button.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/post-detail';

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _leadingVisibility = false;

  bool get _isAppBarExpanded {
    final headerHeight =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? 45.0
            : 65.0;

    return _scrollController.hasClients &&
        _scrollController.offset >
            (SizeConfig.safeBlockVertical * headerHeight - kToolbarHeight);
  }

  @override
  void didChangeDependencies() {
    _scrollController.addListener(() {
      if (_isAppBarExpanded && _leadingVisibility == false) {
        setState(
          () {
            _leadingVisibility = true;
          },
        );
      } else if (!_isAppBarExpanded && _leadingVisibility == true) {
        setState(
          () {
            _leadingVisibility = false;
          },
        );
      }
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postId = ModalRoute.of(context)!.settings.arguments! as int;
    final loadedPost =
        Provider.of<Posts>(context, listen: false).findById(postId);
    final headerHeight =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? 50.0
            : 70.0;
    final userId = Provider.of<Auth>(context, listen: false).user?.id ?? '';
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPersistentHeader(
              delegate: PostDetailHeader(
                user: loadedPost.user,
                postId: loadedPost.id,
                images: loadedPost.images,
                height: SizeConfig.safeBlockVertical * headerHeight,
                buttonsVisibility: !_leadingVisibility,
              ),
            ),
            SliverAppBar(
              leading: Navigator.canPop(context)
                  ? Visibility(
                      visible: _leadingVisibility,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(CustomIcons.back),
                      ),
                    )
                  : null,
              title: Text(
                currencyFormat.format(loadedPost.price),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 28.0),
              ),
              pinned: true,
              actions: [
                Visibility(
                  visible: _leadingVisibility,
                  child: Container(
                    child: userId == loadedPost.user
                        ? Container(
                            margin: const EdgeInsets.all(4.0),
                            child: EditPostButton(postId),
                          )
                        : Container(
                            margin: const EdgeInsets.all(4.0),
                            child: FavoriteButton(
                              postId: postId,
                              elevation: 0.0,
                            ),
                          ),
                  ),
                )
              ],
            ),
            PostDetailContent(
              loadedPost,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StyledElevatedButton(
          text: AppLocalizations.of(context)!.call,
          suffixIcon: CustomIcons.phonecall,
          onPressed: () async {
            if (await Permission.phone.request().isGranted) {
              launch('tel://${loadedPost.contact}');
            }
          },
        ),
      ),
    );
  }
}
