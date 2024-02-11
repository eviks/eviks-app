import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../widgets/sized_config.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<Auth>(
      builder: (context, auth, child) {
        return Column(
          children: [
            if (auth.user?.picture != null)
              CircleAvatar(
                radius: 50.0,
                backgroundImage:
                    CachedNetworkImageProvider(auth.user!.picture!),
                backgroundColor: Theme.of(context).colorScheme.background,
              )
            else
              CircleAvatar(
                radius: 50.0,
                backgroundImage: const AssetImage(
                  'assets/img/illustrations/avatar.png',
                ),
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              auth.user?.displayName ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ],
        );
      },
    );
  }
}
