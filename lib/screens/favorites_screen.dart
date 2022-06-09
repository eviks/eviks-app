import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/failure.dart';
import '../providers/auth.dart';
import '../providers/posts.dart';
import '../widgets/post_item.dart';
import '../widgets/sized_config.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  var _isInit = true;
  var _isLoading = false;
  List<String> ids = [];
  final ScrollController _scrollController = ScrollController();

  Future<void> _fetchPosts(bool updatePosts) async {
    if (ids.isNotEmpty) {
      final Map<String, dynamic> _queryParameters = {'ids': ids.join(',')};

      String _errorMessage = '';
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      final _pagination = Provider.of<Posts>(context, listen: false).pagination;
      if (_pagination.available != null || _pagination.current == 0) {
        final _page = _pagination.current + 1;
        try {
          await Provider.of<Posts>(context, listen: false).fetchAndSetPosts(
            queryParameters: _queryParameters,
            page: _page,
            updatePosts: updatePosts,
          );
        } on Failure catch (error) {
          if (error.statusCode >= 500) {
            _errorMessage = AppLocalizations.of(context)!.serverError;
          } else {
            _errorMessage = AppLocalizations.of(context)!.networkError;
          }
        } catch (error) {
          _errorMessage = AppLocalizations.of(context)!.unknownError;
        }

        if (_errorMessage.isNotEmpty) {
          showSnackBar(context, _errorMessage);
        }
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

      final favorites = Provider.of<Auth>(context, listen: false).favorites;
      favorites.forEach((key, value) {
        if (value == true) {
          ids.add(key.toString());
        }
      });

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
    if (_isInit) {
      return const Center(
        child: CircularProgressIndicator(),
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
            AppLocalizations.of(context)!.favorites,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: posts.isEmpty
            ? SingleChildScrollView(
                child: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 40.0,
                            child: Image.asset(
                              "assets/img/illustrations/favorites.png",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.favoritesTitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.favoritesHint,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).dividerColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                            child: PostItem(
                              key: Key(posts[index].id.toString()),
                              post: posts[index],
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
