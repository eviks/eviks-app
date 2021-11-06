import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../models/failure.dart';
import '../../../models/image_data.dart';
import '../../../models/post.dart';
import '../../../providers/posts.dart';
import '../../../widgets/sized_config.dart';
import '../../../widgets/styled_elevated_button.dart';
import '../step_title.dart';
import './uploaded_image.dart';

class EditPostImages extends StatefulWidget {
  final Post post;
  final Function(Post) updatePost;

  const EditPostImages({
    required this.post,
    required this.updatePost,
    Key? key,
  }) : super(key: key);

  @override
  _EditPostImagesState createState() => _EditPostImagesState();
}

class _EditPostImagesState extends State<EditPostImages> {
  final ImagePicker _picker = ImagePicker();
  List<ImageData> _imageDataList = [];

  void onImageSelect() async {
    final pickedFileList = await _picker.pickMultiImage();
    if (pickedFileList != null) {
      final List<ImageData> _newFiles = [];
      for (final file in pickedFileList) {
        var id = '';

        String _errorMessage = '';
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        try {
          id = await Provider.of<Posts>(context, listen: false)
              .getImageUploadId();
        } on Failure catch (error) {
          if (error.statusCode >= 500) {
            _errorMessage = AppLocalizations.of(context)!.serverError;
          } else {
            _errorMessage = error.toString();
          }
        } catch (error) {
          _errorMessage = AppLocalizations.of(context)!.unknownError;
        }

        if (_errorMessage.isNotEmpty) {
          displayErrorMessage(context, _errorMessage);
          return;
        }

        _newFiles.add(
          ImageData(
            file: file,
            id: id,
          ),
        );
      }

      setState(() {
        _imageDataList = [
          ..._imageDataList,
          ..._newFiles,
        ];
      });
    }
  }

  void setUploadStatus(String id) {
    setState(() {
      _imageDataList = _imageDataList
          .map((element) => element.id == id
              ? ImageData(
                  file: element.file,
                  id: element.id,
                  isUploaded: true,
                )
              : element)
          .toList();
    });
  }

  void deleteImage(String id) async {
    String _errorMessage = '';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    try {
      await Provider.of<Posts>(context, listen: false).deleteImage(id);
    } on Failure catch (error) {
      if (error.statusCode >= 500) {
        _errorMessage = AppLocalizations.of(context)!.serverError;
      } else {
        _errorMessage = error.toString();
      }
    } catch (error) {
      _errorMessage = AppLocalizations.of(context)!.unknownError;
    }

    if (_errorMessage.isNotEmpty) {
      displayErrorMessage(context, _errorMessage);
      return;
    }

    setState(() {
      _imageDataList =
          _imageDataList.where((element) => element.id != id).toList();
    });
  }

  void _continuePressed() {
    widget.updatePost(widget.post.copyWith(
      step: 6,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 8.0,
              8.0, SizeConfig.safeBlockHorizontal * 8.0, 32.0),
          child: Center(
            child: Column(
              children: [
                StepTitle(
                  title: AppLocalizations.of(context)!.images,
                  icon: CustomIcons.camera,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: _imageDataList.length + 1,
                      itemBuilder: (BuildContext ctx, index) {
                        if (index == _imageDataList.length) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: OutlinedButton(
                                onPressed: onImageSelect,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      CustomIcons.image,
                                      size: 48.0,
                                    ),
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                        AppLocalizations.of(context)!.addImage),
                                  ],
                                )),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: UploadedImage(
                                key: Key(_imageDataList[index].id),
                                imageData: _imageDataList[index],
                                setUploadStatus: setUploadStatus,
                                deleteImage: deleteImage,
                              ),
                            ),
                          );
                        }
                      }),
                ),
                const SizedBox(
                  height: 32.0,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  blurRadius: 8.0,
                  offset: const Offset(10.0, 10.0),
                )
              ],
            ),
            child: StyledElevatedButton(
              secondary: true,
              text: AppLocalizations.of(context)!.next,
              onPressed: _continuePressed,
              width: SizeConfig.safeBlockHorizontal * 100.0,
              suffixIcon: CustomIcons.next,
            ),
          ),
        ),
      ],
    );
  }
}
