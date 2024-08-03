import 'package:collection/collection.dart';
import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../models/failure.dart';
import '../../models/metro_station.dart';
import '../../models/settlement.dart';
import '../../providers/localities.dart';
import '../../providers/posts.dart';
import '../../widgets/post_item.dart';
import '../../widgets/sized_config.dart';
import '../filters_screen/filters_screen.dart';
import './map_search.dart';
import './subscribe_button.dart';
import './switch_search_view_button.dart';

class PostScreen extends StatefulWidget {
  final String? url;
  const PostScreen({this.url});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  var _isInit = true;
  var _isLoading = false;
  late bool _mapView;
  final ScrollController _scrollController = ScrollController();

  Future<void> getViewModePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _mapView = (prefs.getString('mapView') ?? '') == 'true';
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<void> saveViewModePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_mapView) {
        prefs.setString('mapView', 'true');
      } else {
        prefs.remove('mapView');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _switchViewMode() async {
    setState(() {
      _isInit = true;
      _mapView = !_mapView;
    });
    Provider.of<Posts>(context, listen: false).clearPosts();
    await _fetchPosts(false);
    setState(() {
      _isInit = false;
    });
    await saveViewModePreferences();
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
          if (!mounted) return;
          errorMessage = AppLocalizations.of(context)!.serverError;
        } else {
          if (!mounted) return;
          errorMessage = AppLocalizations.of(context)!.networkError;
        }
      } catch (error) {
        if (!mounted) return;
        errorMessage = AppLocalizations.of(context)!.unknownError;
        errorMessage = error.toString();
      }

      if (errorMessage.isNotEmpty) {
        if (!mounted) return;
        showSnackBar(context, errorMessage);
      }
    }
  }

  Future<void> _refreshList() async {
    Provider.of<Posts>(context, listen: false).clearPosts();
    await _fetchPosts(false);
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await getViewModePreferences();

      _scrollController.addListener(
        () async {
          if (_scrollController.position.pixels >
              _scrollController.position.maxScrollExtent - 3000) {
            if (!_isLoading) {
              setState(() {
                _isLoading = true;
              });

              await _fetchPosts(true);

              setState(() {
                _isLoading = false;
              });
            }
          }
        },
      );

      if (widget.url != null) {
        final params = Uri.splitQueryString(widget.url ?? '');

        Settlement city;
        List<Settlement>? districts;
        List<Settlement>? subdistricts;
        List<MetroStation>? metroStations;

        // City
        if (!mounted) return;
        final result = await Provider.of<Localities>(context, listen: false)
            .getLocalities({'id': params["cityId"]!, 'type': '2'});
        city = result[0];

        // District
        if (params["districtId"] != null) {
          if (!mounted) return;
          districts = await Provider.of<Localities>(context, listen: false)
              .getLocalities({'id': params["districtId"]!});
        }

        // Subdistrict
        if (params["subdistrictId"] != null) {
          if (!mounted) return;
          subdistricts = await Provider.of<Localities>(context, listen: false)
              .getLocalities({'id': params["subdistrictId"]!});
        }

        // Metro station
        if (params["metroStationId"] != null) {
          final metroStationId = (params["metroStationId"]!).split(',');
          metroStations = city.metroStations
              ?.where(
                (element) =>
                    metroStationId.firstWhereOrNull(
                      (id) => id == element.id.toString(),
                    ) !=
                    null,
              )
              .toList();
        }

        if (!mounted) return;
        final filters = Provider.of<Posts>(context, listen: false)
            .getFiltersfromQueryParameters(
          params,
          city,
          districts,
          subdistricts,
          metroStations,
        );

        Provider.of<Posts>(context, listen: false).setFilters(filters);
      }

      if (!mounted) return;
      Provider.of<Posts>(context, listen: false).clearPosts();

      await _fetchPosts(false);

      setState(() {
        _isInit = false;
      });
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CustomIcons.logo,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                AppLocalizations.of(context)!.postsScreenTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
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
                : RefreshIndicator(
                    onRefresh: _refreshList,
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        AnimationLimiter(
                          child: ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
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
                        if (_isLoading) const LinearProgressIndicator(),
                      ],
                    ),
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
