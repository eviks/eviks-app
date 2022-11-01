import 'package:eviks_mobile/icons.dart';
import 'package:eviks_mobile/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import './post_detail_content.dart';
import './post_detail_header.dart';
import './post_detail_moderation_buttons.dart';
import '../../../models/failure.dart';
import '../../../models/post.dart';
import '../../constants.dart';
import '../../providers/auth.dart';
import '../../providers/posts.dart';
import '../../widgets/post_buttons/edit_post_button.dart';
import '../../widgets/post_buttons/favorite_button.dart';
import '../../widgets/sized_config.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({Key? key}) : super(key: key);

  static const routeName = '/post-detail';

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  var _isInit = true;
  var _leadingVisibility = false;
  var _isBlocked = false;

  bool get _isAppBarExpanded {
    final headerHeight =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? 45.0
            : 60.0;

    return _scrollController.hasClients &&
        _scrollController.offset >
            (SizeConfig.safeBlockVertical * headerHeight - kToolbarHeight);
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      final _userRole = Provider.of<Auth>(context, listen: false).userRole;

      if (_userRole == UserRole.moderator) {
        final postId = ModalRoute.of(context)!.settings.arguments! as int;

        String _errorMessage = '';
        bool _result = false;

        try {
          _result = await Provider.of<Posts>(context, listen: false)
              .blockPostForModeration(postId);
        } on Failure catch (error) {
          if (error.statusCode >= 500) {
            _errorMessage = AppLocalizations.of(context)!.serverError;
          } else {
            _errorMessage = AppLocalizations.of(context)!.networkError;
          }
        } catch (error) {
          _errorMessage = AppLocalizations.of(context)!.unknownError;
          _errorMessage = error.toString();
        }

        if (_errorMessage.isNotEmpty) {
          if (!mounted) return;
          showSnackBar(context, _errorMessage);
          return;
        }

        if (!_result) {
          setState(() {
            _isBlocked = true;
          });
        }
      }

      if (mounted) {
        setState(() {
          _isInit = false;
        });
      }
    }

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

  Widget getAppBarTitle(Post loadedPost) {
    if (!_leadingVisibility) {
      return Row(
        children: [
          Flexible(
            child: Text(
              currencyFormat.format(loadedPost.price),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
                color: Theme.of(context).textTheme.bodyText1?.color,
              ),
            ),
          ),
          const SizedBox(
            width: 16.0,
          ),
          Text(
            AppLocalizations.of(context)!.priceForM2(
              currencyFormat.format(loadedPost.price / loadedPost.sqm),
            ),
            style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).textTheme.bodyText1?.color,
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Text(
            currencyFormat.format(loadedPost.price),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
              color: Theme.of(context).textTheme.bodyText1?.color,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.priceForM2(
              currencyFormat.format(loadedPost.price / loadedPost.sqm),
            ),
            style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).textTheme.bodyText1?.color,
            ),
          ),
        ],
      );
    }
  }

  @override
  Future<void> dispose() async {
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
    final userRole = Provider.of<Auth>(context, listen: false).userRole;
    SizeConfig().init(context);
    return Scaffold(
      body: _isBlocked
          ? null
          : SafeArea(
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
                      reviewStatus: loadedPost.reviewStatus,
                      postType: loadedPost.postType,
                    ),
                  ),
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    flexibleSpace: Stack(
                      children: [
                        Container(
                          color: Theme.of(context).backgroundColor,
                        )
                      ],
                    ),
                    leading: Navigator.canPop(context)
                        ? AnimatedOpacity(
                            opacity: _leadingVisibility ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 500),
                            child: Visibility(
                              visible: _leadingVisibility,
                              child: IconButton(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.color,
                                onPressed: () {
                                  final _userRole =
                                      Provider.of<Auth>(context, listen: false)
                                          .userRole;

                                  if (_userRole == UserRole.moderator) {
                                    final postId = ModalRoute.of(context)!
                                        .settings
                                        .arguments! as int;

                                    Provider.of<Posts>(context, listen: false)
                                        .unblockPostFromModeration(postId);
                                  }

                                  Navigator.pop(context);
                                },
                                icon: const Icon(CustomIcons.back),
                              ),
                            ),
                          )
                        : null,
                    title: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: getAppBarTitle(loadedPost),
                    ),
                    pinned: true,
                    actions: [
                      AnimatedOpacity(
                        opacity: _leadingVisibility ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Visibility(
                          visible: _leadingVisibility,
                          child: Container(
                            child: userId == loadedPost.user
                                ? Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 4.0,
                                    ),
                                    child: EditPostButton(
                                      postId: postId,
                                      reviewStatus: loadedPost.reviewStatus,
                                      postType: loadedPost.postType,
                                    ),
                                  )
                                : Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 4.0,
                                    ),
                                    child: FavoriteButton(
                                      postId: postId,
                                      elevation: 0.0,
                                    ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
          padding: const EdgeInsets.all(16.0),
          child: userRole == UserRole.moderator
              ? PostDetailModerationButtons(
                  postId: postId,
                )
              : null),
    );
  }
}
