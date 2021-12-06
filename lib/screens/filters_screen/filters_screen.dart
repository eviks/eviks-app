import 'package:eviks_mobile/icons.dart';
import 'package:eviks_mobile/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/filters.dart';
import '../../models/settlement.dart';
import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';
import '../tabs_screen.dart';
import './city_filter.dart';
import './district_filter.dart';
import './main_filters.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key? key}) : super(key: key);

  static const routeName = '/filters';

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final _formKey = GlobalKey<FormState>();
  late Filters _filters;

  @override
  void initState() {
    _filters = Provider.of<Posts>(context, listen: false).filters ??
        Filters(
          city: Settlement(
            id: '10',
            name: 'Bakı',
            children: [
              Settlement(id: '117', name: 'Binəqədi'),
              Settlement(id: '112', name: 'Nərimanov'),
              Settlement(id: '111', name: 'Nəsimi'),
              Settlement(id: '113', name: 'Nizami'),
              Settlement(id: '122', name: 'Pirallahı'),
              Settlement(id: '121', name: 'Qaradağ'),
              Settlement(id: '118', name: 'Sabunçu'),
              Settlement(id: '115', name: 'Səbail'),
              Settlement(id: '119', name: 'Suraxanı'),
              Settlement(id: '114', name: 'Xətai'),
              Settlement(id: '120', name: 'Xəzər'),
              Settlement(id: '116', name: 'Yasamal'),
            ],
          ),
          dealType: DealType.sale,
        );
    super.initState();
  }

  void _updateState() {
    setState(() {});
  }

  void _setFilters() {
    if (_formKey.currentState == null) {
      return;
    }

    _formKey.currentState!.save();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    Provider.of<Posts>(context, listen: false).updateFilters(_filters);

    Navigator.of(context)
        .pushNamedAndRemoveUntil(TabsScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
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
                  Navigator.of(context).pop();
                },
                icon: const Icon(CustomIcons.close),
              )
            : null,
      ),
      body: SafeArea(
        child: SizedBox(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeBlockHorizontal * 8.0),
            child: SingleChildScrollView(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CityFilter(
                        filters: _filters,
                        updateState: _updateState,
                      ),
                      DistrictFilter(
                        filters: _filters,
                        updateState: _updateState,
                      ),
                      MainFilters(
                        filters: _filters,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StyledElevatedButton(
          text: AppLocalizations.of(context)!.showPosts,
          onPressed: _setFilters,
        ),
      ),
    );
  }
}
