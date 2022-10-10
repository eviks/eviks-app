import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import './carousel.dart';
import './post_buttons/delete_post_button.dart';
import './post_buttons/edit_post_button.dart';
import './post_buttons/favorite_button.dart';
import './styled_elevated_button.dart';
import '../constants.dart';
import '../models/failure.dart';
import '../models/post.dart';
import '../providers/auth.dart';
import '../providers/posts.dart';
import '../screens/post_detail_screen/post_detail_screen.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final bool unreviewed;

  const PostItem({
    Key? key,
    required this.post,
    this.unreviewed = false,
  }) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    const headerHeight = 250.0;

    final dateFormatter = DateFormat(
      'dd MMMM yyyy HH:mm',
      Localizations.localeOf(context).languageCode,
    );

    Future<void> _callPhoneNumber() async {
      final postId = widget.post.id;
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

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(PostDetailScreen.routeName, arguments: widget.post.id);
      },
      child: Container(
        margin: const EdgeInsets.only(
          top: 20.0,
          right: 9.0,
          left: 9.0,
        ),
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Carousel(
                    images: widget.post.images,
                    height: headerHeight,
                    temp: widget.unreviewed,
                  ),
                ),
                Consumer<Auth>(
                  builder: (context, auth, child) {
                    if ((auth.user?.id ?? '') == widget.post.user) {
                      return Container(
                        margin: const EdgeInsets.only(top: 16.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            EditPostButton(widget.post.id),
                            const SizedBox(width: 8.0),
                            DeletePostButton(widget.post.id),
                          ],
                        ),
                      );
                    }
                    return Container(
                      margin: const EdgeInsets.only(top: 16.0, right: 8.0),
                      child: FavoriteButton(
                        postId: widget.post.id,
                      ),
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Column(
                    children: [
                      Row(
                        children: <Widget>[
                          Text(
                            currencyFormat.format(widget.post.price),
                            style: const TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            widget.post.subdistrict
                                    ?.getLocalizedName(context) ??
                                widget.post.district.getLocalizedName(context),
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
                                '${widget.post.sqm} ${AppLocalizations.of(context)!.m2}',
                              ),
                              VerticalDivider(
                                color: Theme.of(context).dividerColor,
                              ),
                              Text(
                                widget.post.estateType == EstateType.apartment
                                    ? AppLocalizations.of(context)!
                                        .postApartmentRoomsTitle(
                                        widget.post.rooms,
                                      )
                                    : AppLocalizations.of(context)!
                                        .postHouseRoomsTitle(
                                        widget.post.rooms,
                                      ),
                              ),
                              VerticalDivider(
                                color: Theme.of(context).dividerColor,
                              ),
                              Text(
                                widget.post.estateType == EstateType.apartment
                                    ? AppLocalizations.of(context)!
                                        .postFloorTitle(
                                        widget.post.floor ?? 0,
                                        widget.post.totalFloors ?? 0,
                                      )
                                    : AppLocalizations.of(context)!
                                        .postLotSqmTitle(
                                        widget.post.lotSqm ?? 0,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (widget.post.metroStation != null)
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
                                widget.post.metroStation
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
                              dateFormatter.format(widget.post.updatedAt),
                              style: TextStyle(
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StyledElevatedButton(
                        text: AppLocalizations.of(context)!.call,
                        height: 50.0,
                        onPressed: _callPhoneNumber,
                      ),
                    ],
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
