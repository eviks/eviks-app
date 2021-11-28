import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants.dart';
import '../models/failure.dart';
import '../models/settlement.dart';
import '../providers/localities.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  var _isInit = true;
  var _isLoading = false;

  List<Settlement> settlements = [];
  List<Settlement> filteredSettlements = [];
  late TextEditingController _controller;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      String _errorMessage = '';
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      try {
        final result = await Provider.of<Localities>(context, listen: false)
            .getLocalities({'type': '2'});
        setState(() {
          settlements = result;
          filteredSettlements = result;
        });
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
        displayErrorMessage(context, _errorMessage);
      }

      setState(() {
        _isLoading = false;
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(CustomIcons.back),
              )
            : null,
        title: Text(
          AppLocalizations.of(context)!.selectCity,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? (const Center(
              child: CircularProgressIndicator(),
            ))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    cursorColor: Theme.of(context).iconTheme.color,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.selectCityHint,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      filled: true,
                      suffixIcon: const Icon(Icons.saved_search),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        filteredSettlements = settlements
                            .where((element) =>
                                removeAzerbaijaniChars(element.name)
                                    .contains(RegExp(
                                  removeAzerbaijaniChars(value),
                                  caseSensitive: false,
                                )))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          title: Text(filteredSettlements[index].name),
                          onTap: () {
                            Navigator.of(context)
                                .pop(filteredSettlements[index]);
                          },
                        );
                      },
                      itemCount: filteredSettlements.length,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
