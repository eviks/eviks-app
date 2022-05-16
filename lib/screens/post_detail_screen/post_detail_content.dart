import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './post_detail_additional.dart';
import './post_detail_building.dart';
import './post_detail_general.dart';
import './post_detail_main_info.dart';
import './post_detail_map.dart';
import './post_detail_user.dart';
import '../../models/post.dart';
import '../../widgets/sized_config.dart';

class PostDetailContent extends StatefulWidget {
  final Post post;

  const PostDetailContent(this.post);

  @override
  State<PostDetailContent> createState() => _PostDetailContentState();
}

class _PostDetailContentState extends State<PostDetailContent> {
  bool _postHasAdditionalItems() {
    return (widget.post.kidsAllowed ?? false) ||
        (widget.post.petsAllowed ?? false) ||
        (widget.post.garage ?? false) ||
        (widget.post.pool ?? false) ||
        (widget.post.bathhouse ?? false) ||
        (widget.post.balcony ?? false) ||
        (widget.post.furniture ?? false) ||
        (widget.post.kitchenFurniture ?? false) ||
        (widget.post.cableTv ?? false) ||
        (widget.post.phone ?? false) ||
        (widget.post.internet ?? false) ||
        (widget.post.electricity ?? false) ||
        (widget.post.gas ?? false) ||
        (widget.post.water ?? false) ||
        (widget.post.heating ?? false) ||
        (widget.post.tv ?? false) ||
        (widget.post.conditioner ?? false) ||
        (widget.post.washingMachine ?? false) ||
        (widget.post.dishwasher ?? false) ||
        (widget.post.refrigerator ?? false);
  }

  bool _postHasBuildingInfo() {
    return (widget.post.yearBuild != null && widget.post.yearBuild != 0) ||
        (widget.post.ceilingHeight != null && widget.post.ceilingHeight != 0) ||
        (widget.post.elevator ?? false) ||
        (widget.post.parkingLot ?? false);
  }

  final List<bool> _isOpen = [true, true, true, true, true];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final int _descriptionIndex = _postHasBuildingInfo() ? 2 : 1;
    final int _additionalItemsIndex = _postHasBuildingInfo() ? 3 : 2;
    final int _locationIndex =
        (_postHasBuildingInfo() ? 3 : 2) + (_postHasAdditionalItems() ? 1 : 0);

    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostDetailMainInfo(
                post: widget.post,
              ),
              PostDetailUser(
                post: widget.post,
              ),
              const SizedBox(
                height: 8.0,
              ),
              ExpansionPanelList(
                children: [
                  // General
                  ExpansionPanel(
                    headerBuilder: (context, isOpen) {
                      return _ContentTitle(
                        AppLocalizations.of(context)!.postDetailGeneral,
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PostDetailGeneral(
                        post: widget.post,
                      ),
                    ),
                    isExpanded: _isOpen[0],
                  ),
                  // Building
                  if (_postHasBuildingInfo())
                    ExpansionPanel(
                      headerBuilder: (context, isOpen) {
                        return _ContentTitle(
                          AppLocalizations.of(context)!.postDetailBuilding,
                        );
                      },
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PostDetailBuilding(
                          post: widget.post,
                        ),
                      ),
                      isExpanded: _isOpen[1],
                    ),
                  // Description
                  ExpansionPanel(
                    headerBuilder: (context, isOpen) {
                      return _ContentTitle(
                        AppLocalizations.of(context)!.postDetailDescription,
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.post.description ?? '',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                    isExpanded: _isOpen[_descriptionIndex],
                  ),
                  // Additional items
                  if (_postHasAdditionalItems())
                    ExpansionPanel(
                      headerBuilder: (context, isOpen) {
                        return _ContentTitle(
                          AppLocalizations.of(context)!.postDetailAdditional,
                        );
                      },
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PostDetailAdditional(
                          post: widget.post,
                        ),
                      ),
                      isExpanded: _isOpen[_additionalItemsIndex],
                    ),
                  // Location
                  ExpansionPanel(
                    headerBuilder: (context, isOpen) {
                      return _ContentTitle(
                        AppLocalizations.of(context)!.postDetailLocation,
                      );
                    },
                    body: SizedBox(
                      height: 300.0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, right: 8.0, left: 8.0, bottom: 32.0),
                        child: PostDetailMap(
                          widget.post,
                        ),
                      ),
                    ),
                    isExpanded: _isOpen[_locationIndex],
                  ),
                ],
                expansionCallback: (index, isOpen) {
                  setState(() {
                    _isOpen[index] = !isOpen;
                  });
                },
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 10.0,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class _ContentTitle extends StatelessWidget {
  final String title;

  const _ContentTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
