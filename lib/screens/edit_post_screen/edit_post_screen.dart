import 'package:flutter/material.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/post.dart';

import '../../widgets/sized_config.dart';
import './general_info.dart';
import './map.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen({Key? key}) : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              AppLocalizations.of(context)!.editPostScreenTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: FlowBuilder<Post>(
        state: Post(
          id: 0,
          userType: UserType.owner,
          estateType: EstateType.house,
          dealType: DealType.sale,
          price: 0,
          rooms: 0,
          sqm: 0,
          city: null,
          district: null,
          images: [],
          description: '',
          location: [],
        ),
        onGeneratePages: (post, pages) {
          return [
            const MaterialPage(child: GeneralInfo()),
            if (post.step == 1) const MaterialPage(child: Map()),
          ];
        },
      ),
    );
  }
}
