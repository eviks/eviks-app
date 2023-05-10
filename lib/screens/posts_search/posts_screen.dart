import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import './map_search.dart';
import './subscribe_button.dart';
import './switch_search_view_button.dart';
import '../../constants.dart';
import '../../models/failure.dart';
import '../../providers/posts.dart';
import '../../widgets/post_item.dart';
import '../../widgets/sized_config.dart';
import '../filters_screen/filters_screen.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _mapView = false;
  final ScrollController _scrollController = ScrollController();

  void _switchViewMode() {
    setState(() {
      _mapView = !_mapView;
    });
    Provider.of<Posts>(context, listen: false).clearPosts();
    _fetchPosts(false);
  }

  Future<void> _fetchPosts(bool updatePosts) async {
    String errorMessage = '';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final pagination = Provider.of<Posts>(context, listen: false).pagination;

    if (pagination.available != null || pagination.current == 0 || _mapView) {
      try {
        if (!_mapView) {
          final page = pagination.current + 1;
          await Provider.of<Posts>(context, listen: false).fetchAndSetPosts(
            page: page,
            updatePosts: updatePosts,
          );
        } else {
          await Provider.of<Posts>(context, listen: false)
              .fetchAndSetPostsLocations();
        }
      } on Failure catch (error) {
        if (error.statusCode >= 500) {
          errorMessage = AppLocalizations.of(context)!.serverError;
        } else {
          errorMessage = AppLocalizations.of(context)!.networkError;
        }
      } catch (error) {
        errorMessage = AppLocalizations.of(context)!.unknownError;
        errorMessage = error.toString();
      }

      if (errorMessage.isNotEmpty) {
        if (!mounted) return;
        showSnackBar(context, errorMessage);
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
    if (_isInit) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      final posts = Provider.of<Posts>(context).posts;
      final url = Provider.of<Posts>(context).url;
      return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(FiltersScreen.routeName),
              child: Text(AppLocalizations.of(context)!.filters),
            ),
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CustomIcons.logo),
              const SizedBox(
                width: 5,
              ),
              Text(
                AppLocalizations.of(context)!.postsScreenTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        body: _mapView
            ? const MapSearch()
            : posts.isEmpty
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
                                  "assets/img/illustrations/no_result.png",
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.noResult,
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
                                      AppLocalizations.of(context)!
                                          .noResultHint,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context).dividerColor,
                                      ),
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
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      AnimationLimiter(
                        child: ListView.builder(
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SwitchSearchViewButton(
                mapView: _mapView,
                onPressed: _switchViewMode,
              ),
              SubscribeButton(url),
            ],
          ),
        ),
      );
    }
  }
}
