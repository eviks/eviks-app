import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import './post_detail_content.dart';
import './post_detail_header.dart';
import '../../../models/failure.dart';
import '../../../models/post.dart';
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
            : 60.0;

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

  Future<void> _callPhoneNumber() async {
    final postId = ModalRoute.of(context)!.settings.arguments! as int;
    String phoneNumber = '';
    String _errorMessage = '';
    try {
      phoneNumber = await Provider.of<Posts>(context, listen: false)
          .fetchPostPhoneNumber(postId);
    } on Failure catch (error) {
      if (error.statusCode >= 500) {
        _errorMessage = AppLocalizations.of(context)!.serverError;
      } else {
        _errorMessage = error.toString();
      }
    } catch (error) {
      _errorMessage = AppLocalizations.of(context)!.unknownError;
    }

    if (_errorMessage.isNotEmpty) {
      if (!mounted) return;
      showSnackBar(context, _errorMessage);
      return;
    }

    if (await Permission.phone.request().isGranted) {
      launch('tel://$phoneNumber');
    }
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
                reviewStatus: loadedPost.reviewStatus,
                unreviewed: loadedPost.unreviewed,
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
                          color: Theme.of(context).textTheme.bodyText1?.color,
                          onPressed: () {
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
                                unreviewed: loadedPost.unreviewed,
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
        child: StyledElevatedButton(
          text: AppLocalizations.of(context)!.call,
          onPressed: _callPhoneNumber,
        ),
      ),
    );
  }
}
