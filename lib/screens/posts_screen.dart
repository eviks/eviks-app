import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/failure.dart';
import '../providers/posts.dart';
import '../widgets/post_item.dart';
import '../widgets/sized_config.dart';
import './filters_screen/filters_screen.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      String _errorMessage = '';
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      try {
        await Provider.of<Posts>(context, listen: false).fetchAndSetPosts();
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
        displayErrorMessage(context, _errorMessage);
      }

      setState(() {
        _isLoading = false;
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final postsData = Provider.of<Posts>(context, listen: true);
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
      body: _isLoading
          ? (const Center(
              child: CircularProgressIndicator(),
            ))
          : postsData.posts.isEmpty
              ? SingleChildScrollView(
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
                                  AppLocalizations.of(context)!.noResultHint,
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
              : (ListView.builder(
                  itemBuilder: (ctx, index) {
                    return PostItem(
                      post: postsData.posts[index],
                    );
                  },
                  itemCount: postsData.posts.length,
                )),
    );
  }
}
