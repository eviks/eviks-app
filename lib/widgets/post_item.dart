import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../models/failure.dart';
import '../models/post.dart';
import '../providers/auth.dart';
import '../providers/posts.dart';
import '../screens/post_detail_screen/post_detail_screen.dart';
import './carousel.dart';
import './post_buttons/delete_post_button.dart';
import './post_buttons/edit_post_button.dart';
import './post_buttons/favorite_button.dart';
import './styled_elevated_button.dart';
import 'post_item_review_status.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final PostType postType;

  const PostItem({
    Key? key,
    required this.post,
    this.postType = PostType.confirmed,
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

    Future<void> callPhoneNumber() async {
      final postId = widget.post.id;
      String phoneNumber = '';
      String errorMessage = '';
      try {
        phoneNumber = await Provider.of<Posts>(context, listen: false)
            .fetchPostPhoneNumber(postId);
      } on Failure catch (error) {
        if (error.statusCode >= 500) {
          if (!context.mounted) return;
          errorMessage = AppLocalizations.of(context)!.serverError;
        } else {
          errorMessage = error.toString();
        }
      } catch (error) {
        if (!context.mounted) return;
        errorMessage = AppLocalizations.of(context)!.unknownError;
      }

      if (errorMessage.isNotEmpty) {
        if (!context.mounted) return;
        showSnackBar(context, errorMessage);
        return;
      }

      if (await Permission.phone.request().isGranted) {
        final uri = Uri.parse('tel://$phoneNumber');
        await launchUrl(uri);
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
            if (widget.post.postType == PostType.unreviewed &&
                widget.post.reviewStatus != null)
              Row(
                children: [
                  PostReviewStatus(
                    reviewStatus: widget.post.reviewStatus!,
                  ),
                ],
              ),
            Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Carousel(
                    images: widget.post.images,
                    height: headerHeight,
                    external: widget.post.isExternal ?? false,
                    temp: widget.postType == PostType.unreviewed,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 16.0,
                    right: 8.0,
                    left: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: widget.post.videoLink?.isNotEmpty ?? false,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                8.0,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.play,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.hasVideo,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Consumer<Auth>(
                        builder: (context, auth, child) {
                          if ((auth.user?.id ?? '') == widget.post.user) {
                            return Row(
                              children: [
                                EditPostButton(
                                  postId: widget.post.id,
                                  reviewStatus: widget.post.reviewStatus,
                                  postType: widget.post.postType,
                                ),
                                const SizedBox(width: 4.0),
                                DeletePostButton(
                                  postId: widget.post.id,
                                  reviewStatus: widget.post.reviewStatus,
                                  postType: widget.post.postType,
                                ),
                              ],
                            );
                          } else {
                            return Container(
                              margin:
                                  const EdgeInsets.only(top: 16.0, right: 8.0),
                              child: FavoriteButton(
                                postId: widget.post.id,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
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
                              dateFormatter
                                  .format(widget.post.updatedAt.toLocal()),
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
                        onPressed: callPhoneNumber,
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
