import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import './additional_filters.dart';
import './city_filter.dart';
import './district_filter.dart';
import './floor_filters.dart';
import './main_filters.dart';
import './metro_filter.dart';
import './sort_button.dart';
import './sqm_filters.dart';
import '../../models/filters.dart';
import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';
import '../tabs_screen.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key? key}) : super(key: key);

  static const routeName = '/filters';

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final _formKey = GlobalKey<FormState>();
  late final Filters prevFilters;

  void _setFilters() {
    if (_formKey.currentState == null) {
      return;
    }

    _formKey.currentState!.save();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context)
        .pushNamedAndRemoveUntil(TabsScreen.routeName, (route) => false);
  }

  @override
  void initState() {
    prevFilters = Provider.of<Posts>(context, listen: false).filters.copy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.filters,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () {
                  Provider.of<Posts>(context, listen: false)
                      .setFilters(prevFilters);
                  Navigator.of(context).pop();
                },
                icon: const Icon(CustomIcons.close),
              )
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SortButton(),
                    const CityFilter(),
                    const DistrictFilter(),
                    Consumer<Posts>(
                      builder: (context, posts, child) =>
                          posts.filters.city.metroStations?.isNotEmpty ?? false
                              ? const MetroFilter()
                              : const SizedBox(),
                    ),
                    const MainFilters(),
                    const SqmFilters(),
                    const FloorFilters(),
                    const AdditionalFilters(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: StyledElevatedButton(
          text: AppLocalizations.of(context)!.showPosts,
          onPressed: _setFilters,
        ),
      ),
    );
  }
}
