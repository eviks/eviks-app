import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/failure.dart';
import '../../../providers/auth.dart';
import '../../../providers/posts.dart';
import '../../../widgets/post_item.dart';
import '../../../widgets/sized_config.dart';
import '../../../widgets/styled_app_bar.dart';

class UserPosts extends StatefulWidget {
  @override
  _UserPostsState createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  var _isInit = true;
  var _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  Future<void> _fetchPosts(bool updatePosts) async {
    final userId = Provider.of<Auth>(context, listen: false).user?.id;
    if (userId != null) {
      final Map<String, dynamic> _queryParameters = {'userId': userId};

      String _errorMessage = '';
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      final _pagination = Provider.of<Posts>(context, listen: false).pagination;
      if (_pagination.available != null || _pagination.current == 0) {
        final _page = _pagination.current + 1;
        await Provider.of<Posts>(context, listen: false).fetchAndSetPosts(
          queryParameters: _queryParameters,
          page: _page,
          updatePosts: updatePosts,
        );
        try {} on Failure catch (error) {
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
  Widget build(BuildContext context) {
    if (_isInit) {
      return Container(
        color: Theme.of(context).backgroundColor,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      final posts = Provider.of<Posts>(context).posts;
      SizeConfig().init(context);
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: StyledAppBar(
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
        body: posts.isEmpty
            ? SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 40.0,
                          child: Image.asset(
                            "assets/img/illustrations/my_posts.png",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.myPostsTitle,
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
                                AppLocalizations.of(context)!.myPostsHint,
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
              )
            : Stack(
                children: [
                  ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (ctx, index) {
                      return PostItem(
                        key: Key(posts[index].id.toString()),
                        post: posts[index],
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
