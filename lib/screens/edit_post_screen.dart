import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/post.dart';
import '../models/settlement.dart';
import '../widgets/sized_config.dart';
import '../widgets/toggle_field.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen({Key? key}) : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  Post _postData = Post(
    id: 0,
    userType: null,
    estateType: null,
    dealType: null,
    price: 0,
    rooms: 0,
    sqm: 0,
    city: null,
    district: null,
    images: [],
    description: '',
    location: [],
  );

  void _updatePostData(String name, dynamic value) {
    setState(() {
      _postData = Post(
        id: name == 'id' ? value as int : _postData.id,
        userType: name == 'userType' ? value as UserType : _postData.userType,
        estateType:
            name == 'estateType' ? value as EstateType : _postData.estateType,
        dealType: name == 'dealType' ? value as DealType : _postData.dealType,
        price: name == 'price' ? value as int : _postData.price,
        rooms: name == 'rooms' ? value as int : _postData.rooms,
        sqm: name == 'sqm' ? value as int : _postData.sqm,
        city: name == 'city' ? value as Settlement : _postData.city,
        district: name == 'district' ? value as Settlement : _postData.district,
        images: name == 'images' ? value as List<String> : _postData.images,
        description:
            name == 'description' ? value as String : _postData.description,
        location:
            name == 'location' ? value as List<double> : _postData.location,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: SizeConfig.safeBlockVertical * 100.0,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleField(
                  name: 'userType',
                  title: AppLocalizations.of(context)!.userTypeTitle,
                  values: UserType.values,
                  setValue: _updatePostData,
                  getDescription: userTypeDescription,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
