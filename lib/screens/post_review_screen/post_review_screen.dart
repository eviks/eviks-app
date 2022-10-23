import 'package:eviks_mobile/icons.dart';
import 'package:eviks_mobile/models/post.dart';
import 'package:eviks_mobile/screens/post_detail_screen/post_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../widgets/sized_config.dart';
import '../../constants.dart';
import '../../models/failure.dart';
import '../../providers/posts.dart';

class PostReviewScreen extends StatefulWidget {
  const PostReviewScreen({Key? key}) : super(key: key);

  static const routeName = '/post_review';

  @override
  State<PostReviewScreen> createState() => _PostReviewScreenState();
}

class _PostReviewScreenState extends State<PostReviewScreen> {
  var _isInit = true;
  var _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  Future<void> _fetchPosts(bool updatePosts) async {
    String _errorMessage = '';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final _pagination = Provider.of<Posts>(context, listen: false).pagination;

    if (_pagination.available != null || _pagination.current == 0) {
      final _page = _pagination.current + 1;

      try {
        await Provider.of<Posts>(context, listen: false).fetchAndSetPosts(
          page: _page,
          updatePosts: updatePosts,
          postType: PostType.unreviewed,
        );
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
      }
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      _scrollController.addListener(
        () async {
          if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
            setState(() {
              _isLoading = true;
            });

            await _fetchPosts(true);

            setState(() {
              _isLoading = false;
            });
          }
        },
      );

      Provider.of<Posts>(context, listen: false).clearPosts();

      await _fetchPosts(false);

      if (mounted) {
        setState(() {
          _isInit = false;
        });
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final dateFormatter = DateFormat(
      'dd MMMM yyyy HH:mm',
      Localizations.localeOf(context).languageCode,
    );

    String getPostTitle(Post post) {
      return '#${post.id.toString()} | ${post.city.getLocalizedName(context)} | ${post.district.getLocalizedName(context)} | ${dealTypeDescriptionAlternative(post.dealType, context)}';
    }

    if (_isInit) {
      return Container(
        color: Theme.of(context).backgroundColor,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      final posts = Provider.of<Posts>(context).posts;

      return Scaffold(
        appBar: AppBar(
          leading: Navigator.canPop(context)
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(CustomIcons.back),
                )
              : null,
          title: Text(
            AppLocalizations.of(context)!.postReview,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: _isInit
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: ListTile(
                              trailing: const Icon(CustomIcons.next),
                              title: Text(getPostTitle(posts[index])),
                              subtitle: Text(
                                dateFormatter.format(posts[index].createdAt),
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  PostDetailScreen.routeName,
                                  arguments: posts[index].id,
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: posts.length,
                  ),
                  if (_isLoading)
                    Positioned(
                      bottom: 0,
                      width: SizeConfig.blockSizeHorizontal * 100.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      );
    }
  }
}
