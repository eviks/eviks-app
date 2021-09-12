import 'package:flutter/material.dart';
import 'package:flow_builder/flow_builder.dart';

import '../../models/post.dart';

import '../../widgets/sized_config.dart';
import './general_info.dart';

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
        onGeneratePages: (profile, pages) {
          return [
            const MaterialPage(child: GeneralInfo()),
          ];
        },
      ),
    );
  }
}
