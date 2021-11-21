import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/filters.dart';
import '../../providers/posts.dart';
import '../../widgets/sized_config.dart';
import '../../widgets/styled_elevated_button.dart';
import '../tabs_screen.dart';
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
    _filters = Provider.of<Posts>(context, listen: false).filters ?? Filters();
    super.initState();
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
        child: Container(
          constraints: BoxConstraints(
            minHeight: SizeConfig.safeBlockVertical * 100.0,
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    SizeConfig.safeBlockHorizontal * 8.0,
                    8.0,
                    SizeConfig.safeBlockHorizontal * 8.0,
                    32.0),
                child: SingleChildScrollView(
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          MainFilters(
                            filters: _filters,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                width: SizeConfig.safeBlockHorizontal * 100.0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: StyledElevatedButton(
                      text: AppLocalizations.of(context)!.showPosts,
                      onPressed: _setFilters,
                      width: SizeConfig.safeBlockHorizontal * 80.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
