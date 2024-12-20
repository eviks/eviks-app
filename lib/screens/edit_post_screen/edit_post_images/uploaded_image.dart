import 'dart:io';
import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/failure.dart';
import '../../../models/image_data.dart';
import '../../../providers/posts.dart';

class UploadedImage extends StatefulWidget {
  final ImageData imageData;
  final bool unreviewed;
  final Function(String) setUploadStatus;
  final Function(String) deleteImage;

  const UploadedImage({
    required this.imageData,
    required this.unreviewed,
    required this.setUploadStatus,
    required this.deleteImage,
    Key? key,
  }) : super(key: key);

  @override
  _UploadedImageState createState() => _UploadedImageState();
}

class _UploadedImageState extends State<UploadedImage> {
  Future<void> uploadImage() async {
    String errorMessage = '';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    try {
      final res = await Provider.of<Posts>(context, listen: false)
          .uploadImage(widget.imageData.file!, widget.imageData.id);
      if (res) {
        widget.setUploadStatus(widget.imageData.id);
      }
    } on Failure catch (error) {
      if (error.statusCode >= 500) {
        if (!mounted) return;
        errorMessage = AppLocalizations.of(context)!.serverError;
      } else {
        errorMessage = error.toString();
      }
    } catch (error) {
      if (!mounted) return;
      errorMessage = AppLocalizations.of(context)!.unknownError;
    }

    if (errorMessage.isNotEmpty) {
      widget.deleteImage(widget.imageData.id);
      if (!mounted) return;
      showSnackBar(context, errorMessage);
      return;
    }
  }

  @override
  void didChangeDependencies() {
    if (!widget.imageData.isUploaded) {
      uploadImage();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.imageData.isUploaded
        ? Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                '$baseUrl/uploads/${(widget.imageData.isTemp || widget.unreviewed) ? 'temp/' : ''}post_images/${widget.imageData.id}/image_320.webp',
                fit: BoxFit.fill,
              ),
              Positioned(
                right: 5.0,
                top: 5.0,
                child: Container(
                  width: 32.0,
                  height: 32.0,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surface.withOpacity(0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: IconButton(
                    icon: const Icon(CustomIcons.close),
                    iconSize: 16.0,
                    onPressed: () {
                      widget.deleteImage(widget.imageData.id);
                    },
                  ),
                ),
              ),
            ],
          )
        : Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(widget.imageData.file?.path ?? ''),
                fit: BoxFit.fill,
              ),
              Container(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              ),
              Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          );
  }
}
