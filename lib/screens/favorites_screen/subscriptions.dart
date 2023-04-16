import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/failure.dart';
import '../../providers/subscriptions.dart' as provider;
import '../../widgets/sized_config.dart';
import '../tabs_screen.dart';

enum MenuItems { edit, delete }

class Subscriptions extends StatefulWidget {
  const Subscriptions({Key? key}) : super(key: key);

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  var _isInit = true;

  Future<void> _fetchSubscriptions() async {
    String _errorMessage = '';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    try {
      await Provider.of<provider.Subscriptions>(context, listen: false)
          .getSubscriptions();
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
      if (!mounted) return;
      showSnackBar(context, _errorMessage);
    }
  }

  void _goToPosts() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      TabsScreen.routeName,
      (route) => false,
      arguments: Pages.posts,
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      Provider.of<provider.Subscriptions>(context, listen: false)
          .clearSubscriptions();

      await _fetchSubscriptions();

      if (mounted) {
        setState(() {
          _isInit = false;
        });
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    if (_isInit) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      final subscriptions =
          Provider.of<provider.Subscriptions>(context).subscriptions;
      return subscriptions.isEmpty
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
                            "assets/img/illustrations/subscriptions.png",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!
                                    .subscriptionsTitle,
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
                                AppLocalizations.of(context)!.subscriptionsHint,
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
          : Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Card(
                            child: ListTile(
                              key: Key(subscriptions[index].id),
                              leading: const Icon(CustomIcons.search),
                              title: Text(subscriptions[index].name),
                              trailing: PopupMenuButton<MenuItems>(
                                onSelected: (value) {
                                  // todo
                                },
                                itemBuilder: (BuildContext bc) {
                                  return [
                                    PopupMenuItem(
                                      value: MenuItems.edit,
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .subscriptionEdit,
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: MenuItems.delete,
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .subscriptionDelete,
                                      ),
                                    ),
                                  ];
                                },
                              ),
                              onTap: () {
                                _goToPosts();
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: subscriptions.length,
                ),
              ],
            );
    }
  }
}
