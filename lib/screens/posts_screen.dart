import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/failure.dart';
import '../providers/posts.dart';
import '../widgets/post_item.dart';

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
    }

    String _errorMessage = '';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    await Provider.of<Posts>(context, listen: false).fetchAndSetPosts({});
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
      displayErrorMessage(context, _errorMessage);
    }

    setState(() {
      _isLoading = false;
    });

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final postsData = Provider.of<Posts>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
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
          : (ListView.builder(
              itemBuilder: (ctx, index) {
                return PostItem(
                  id: postsData.posts[index].id,
                  estateType: postsData.posts[index].estateType,
                  price: postsData.posts[index].price,
                  rooms: postsData.posts[index].rooms,
                  sqm: postsData.posts[index].sqm,
                  city: postsData.posts[index].city,
                  district: postsData.posts[index].district,
                  images: postsData.posts[index].images,
                  floor: postsData.posts[index].floor,
                  totalFloors: postsData.posts[index].totalFloors,
                  lotSqm: postsData.posts[index].lotSqm,
                );
              },
              itemCount: postsData.posts.length,
            )),
    );
  }
}
