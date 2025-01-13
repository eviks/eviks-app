import 'package:eviks_mobile/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../models/failure.dart';
import '../../../models/post.dart';
import '../../constants.dart';
import '../../providers/auth.dart';
import '../../providers/posts.dart';
import '../../widgets/post_buttons/edit_post_button.dart';
import '../../widgets/post_buttons/favorite_button.dart';
import '../../widgets/post_buttons/share_button.dart';
import '../../widgets/sized_config.dart';
import './post_detail_buttons.dart';
import './post_detail_content.dart';
import './post_detail_header.dart';
import './post_detail_moderation_buttons.dart';

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
            ? 40.0
            : 55.0;

    return _scrollController.hasClients &&
        _scrollController.offset >
            (SizeConfig.safeBlockVertical * headerHeight - kToolbarHeight);
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      final userRole = Provider.of<Auth>(context, listen: false).userRole;

      if (userRole == UserRole.moderator) {
        final postId = ModalRoute.of(context)!.settings.arguments! as int;

        String errorMessage = '';
        bool result = false;

        try {
          result = await Provider.of<Posts>(context, listen: false)
              .blockPostForModeration(postId);
        } on Failure catch (error) {
          if (error.statusCode >= 500) {
            if (!mounted) return;
            errorMessage = AppLocalizations.of(context)!.serverError;
          } else {
            if (!mounted) return;
            errorMessage = AppLocalizations.of(context)!.networkError;
          }
        } catch (error) {
          if (!mounted) return;
          errorMessage = AppLocalizations.of(context)!.unknownError;
          errorMessage = error.toString();
        }

        if (errorMessage.isNotEmpty) {
          if (!mounted) return;
          showSnackBar(context, errorMessage);
          return;
        }

        if (!result) {
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
                color: Theme.of(context).textTheme.bodyLarge?.color,
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
              color: Theme.of(context).textTheme.bodyLarge?.color,
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
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.priceForM2(
              currencyFormat.format(loadedPost.price / loadedPost.sqm),
            ),
            style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).textTheme.bodyLarge?.color,
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
            ? 40.0
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
                      isExternal: loadedPost.isExternal ?? false,
                      districtName:
                          loadedPost.district.getLocalizedName(context),
                      price: loadedPost.price,
                      rooms: loadedPost.rooms,
                      videoLink: loadedPost.videoLink,
                    ),
                  ),
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    flexibleSpace: Stack(
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.surface,
                        ),
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
                                    .bodyLarge
                                    ?.color,
                                onPressed: () {
                                  final userRole0 =
                                      Provider.of<Auth>(context, listen: false)
                                          .userRole;

                                  if (userRole0 == UserRole.moderator) {
                                    final postId = ModalRoute.of(context)!
                                        .settings
                                        .arguments! as int;

                                    Provider.of<Posts>(context, listen: false)
                                        .unblockPostFromModeration(postId);
                                  }

                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  LucideIcons.arrowLeft,
                                  size: 18.0,
                                ),
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
                                    child: Row(
                                      children: [
                                        ShareButton(
                                          postId: postId,
                                          districtName: loadedPost.district
                                              .getLocalizedName(context),
                                          price: loadedPost.price,
                                          rooms: loadedPost.rooms,
                                          elevation: 0.0,
                                        ),
                                        const SizedBox(
                                          width: 4.0,
                                        ),
                                        EditPostButton(
                                          postId: postId,
                                          reviewStatus: loadedPost.reviewStatus,
                                          postType: loadedPost.postType,
                                          elevation: 0.0,
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 4.0,
                                    ),
                                    child: Row(
                                      children: [
                                        FavoriteButton(
                                          postId: postId,
                                          elevation: 0.0,
                                        ),
                                        const SizedBox(
                                          width: 4.0,
                                        ),
                                        ShareButton(
                                          postId: postId,
                                          districtName: loadedPost.district
                                              .getLocalizedName(context),
                                          price: loadedPost.price,
                                          rooms: loadedPost.rooms,
                                          elevation: 0.0,
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
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
        child: (userRole == UserRole.moderator &&
                loadedPost.reviewStatus == ReviewStatus.onreview)
            ? PostDetailModerationButtons(
                postId: postId,
              )
            : const PostDetailButtons(),
      ),
    );
  }
}
