import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../widgets/sized_config.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context, listen: false).user;
    SizeConfig().init(context);
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.safeBlockHorizontal * 25.0,
          width: SizeConfig.safeBlockVertical * 25.0,
          child: CircleAvatar(
            backgroundImage:
                const AssetImage('assets/img/illustrations/avatar.png'),
            backgroundColor: Theme.of(context).backgroundColor,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          user?.displayName ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
