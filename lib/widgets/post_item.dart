import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import './carousel.dart';
import './styled_elevated_button.dart';
import './post_buttons/delete_post_button.dart';
import './post_buttons/edit_post_button.dart';
import './post_buttons/favorite_button.dart';
import '../constants.dart';
import '../models/failure.dart';
import '../models/post.dart';
import '../providers/auth.dart';
import '../providers/posts.dart';
import '../screens/post_detail_screen/post_detail_screen.dart';

class PostItem extends StatelessWidget {
  final Post post;

  const PostItem({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const headerHeight = 250.0;

    final dateFormatter = DateFormat(
        'dd MMMM yyyy HH:mm', Localizations.localeOf(context).languageCode);

    Future<void> _callPhoneNumber() async {
      final postId = post.id;
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
        showSnackBar(context, _errorMessage);
        return;
      }

      if (await Permission.phone.request().isGranted) {
        launch('tel://$phoneNumber');
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(PostDetailScreen.routeName, arguments: post.id);
      },
      child: Container(
        margin: const EdgeInsets.only(
          top: 20.0,
          right: 10.0,
          left: 10.0,
        ),
        child: Column(
          children: <Widget>[
            ColorFiltered(
              colorFilter: post.active
                  ? const ColorFilter.mode(Colors.transparent, BlendMode.color)
                  : const ColorFilter.mode(Colors.white30, BlendMode.modulate),
              child: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Carousel(
                      images: post.images,
                      height: headerHeight,
                    ),
                  ),
                  Consumer<Auth>(
                    builder: (context, auth, child) {
                      if ((auth.user?.id ?? '') == post.user) {
                        return Container(
                          margin: const EdgeInsets.only(top: 16.0, right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              EditPostButton(post.id),
                              const SizedBox(width: 8.0),
                              DeletePostButton(post.id),
                            ],
                          ),
                        );
                      }
                      return Container(
                        margin: const EdgeInsets.only(top: 16.0, right: 8.0),
                        child: FavoriteButton(
                          postId: post.id,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  if (!post.active)
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            AppLocalizations.of(context)!.postIsDeactivated,
                            style:
                                TextStyle(color: Theme.of(context).errorColor),
                          ),
                        ),
                      ],
                    ),
                  ColorFiltered(
                    colorFilter: post.active
                        ? const ColorFilter.mode(
                            Colors.transparent, BlendMode.color)
                        : const ColorFilter.mode(
                            Colors.white30, BlendMode.modulate),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Text(
                              currencyFormat.format(post.price),
                              style: const TextStyle(
                                  fontSize: 22.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              post.subdistrict?.getLocalizedName(context) ??
                                  post.district.getLocalizedName(context),
                              style: const TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          child: IntrinsicHeight(
                            child: Row(
                              children: <Widget>[
                                Text(
                                    '${post.sqm} ${AppLocalizations.of(context)!.m2}'),
                                VerticalDivider(
                                  color: Theme.of(context).dividerColor,
                                ),
                                Text(post.estateType == EstateType.apartment
                                    ? AppLocalizations.of(context)!
                                        .postApartmentRoomsTitle(post.rooms)
                                    : AppLocalizations.of(context)!
                                        .postHouseRoomsTitle(post.rooms)),
                                VerticalDivider(
                                  color: Theme.of(context).dividerColor,
                                ),
                                Text(post.estateType == EstateType.apartment
                                    ? AppLocalizations.of(context)!
                                        .postFloorTitle(post.floor ?? 0,
                                            post.totalFloors ?? 0)
                                    : AppLocalizations.of(context)!
                                        .postLotSqmTitle(post.lotSqm ?? 0)),
                              ],
                            ),
                          ),
                        ),
                        if (post.metroStation != null)
                          Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: <Widget>[
                                const Icon(
                                  CustomIcons.metro,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                Text(
                                  post.metroStation
                                          ?.getLocalizedName(context) ??
                                      '',
                                ),
                              ],
                            ),
                          ),
                        Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                dateFormatter.format(post.updatedAt),
                                style: TextStyle(
                                    color: Theme.of(context).disabledColor),
                              ),
                            ],
                          ),
                        ),
                        StyledElevatedButton(
                          text: AppLocalizations.of(context)!.call,
                          onPressed: _callPhoneNumber,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
