import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/failure.dart';
import '../../models/pages_payload.dart';
import '../../providers/subscriptions.dart' as provider;
import '../../widgets/sized_config.dart';
import '../../widgets/subscription_modal.dart';
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
    String errorMessage = '';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    try {
      await Provider.of<provider.Subscriptions>(context, listen: false)
          .getSubscriptions();
    } on Failure catch (error) {
      if (error.statusCode >= 500) {
        errorMessage = AppLocalizations.of(context)!.serverError;
      } else {
        errorMessage = AppLocalizations.of(context)!.networkError;
      }
    } catch (error) {
      errorMessage = AppLocalizations.of(context)!.unknownError;
    }

    if (errorMessage.isNotEmpty) {
      if (!mounted) return;
      showSnackBar(context, errorMessage);
    }
  }

  Future<void> _goToPosts(String url) async {
    Navigator.of(context).pushNamedAndRemoveUntil(
      TabsScreen.routeName,
      (route) => false,
      arguments: PagesPayload(Pages.posts, {'url': url}),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
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
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      subscriptions[index].name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (subscriptions[index].numberOfElements > 0)
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .subscriptionText(
                                            subscriptions[index]
                                                .numberOfElements,
                                          ),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              trailing: PopupMenuButton<MenuItems>(
                                onSelected: (value) async {
                                  if (value == MenuItems.delete) {
                                    await Provider.of<provider.Subscriptions>(
                                      context,
                                      listen: false,
                                    ).deleteSubscription(
                                      subscriptions[index].id,
                                    );
                                  } else {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16.0),
                                          topRight: Radius.circular(16.0),
                                        ),
                                      ),
                                      builder: (BuildContext context) {
                                        return SubscriptionModal(
                                          subscriptions[index].url,
                                          subscriptions[index].name,
                                          subscriptions[index].id,
                                        );
                                      },
                                    );
                                  }
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
                                _goToPosts(subscriptions[index].url);
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
