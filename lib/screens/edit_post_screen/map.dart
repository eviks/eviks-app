import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flow_builder/flow_builder.dart';

import '../../models/post.dart';
import '../../widgets/sized_config.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  void _prevStep() {
    context.flow<Post>().update((post) {
      print(post.apartmentType);
      return post.copyWith(
        step: 0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 8.0,
            ),
            width: SizeConfig.safeBlockHorizontal * 50,
            height: 60.0,
            child: ElevatedButton(
              onPressed: _prevStep,
              child: Text(
                AppLocalizations.of(context)!.next,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
