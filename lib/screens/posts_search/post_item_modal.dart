import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/posts.dart';
import '../../widgets/post_item.dart';

class PostItemModal extends StatefulWidget {
  final int id;

  const PostItemModal({Key? key, required this.id}) : super(key: key);

  @override
  State<PostItemModal> createState() => _PostItemModalState();
}

class _PostItemModalState extends State<PostItemModal> {
  var _isInit = true;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<Posts>(context).fetchSinglePost(id: widget.id);

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
    final postData = Provider.of<Posts>(context).postData;
    if (_isInit) {
      return Wrap(
        children: const [
          SizedBox(
            height: 250,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      );
    } else {
      if (postData == null) return const Placeholder();
      return Wrap(
        children: [
          PostItem(post: postData),
        ],
      );
    }
  }
}
