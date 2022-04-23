import 'package:collection/collection.dart';
import 'package:eviks_mobile/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import './uploaded_image.dart';
import '../../../constants.dart';
import '../../../models/failure.dart';
import '../../../models/image_data.dart';
import '../../../models/post.dart';
import '../../../providers/posts.dart';
import '../../../widgets/sized_config.dart';
import '../../../widgets/styled_elevated_button.dart';
import '../edit_post_price.dart';
import '../step_title.dart';

class EditPostImages extends StatefulWidget {
  const EditPostImages({
    Key? key,
  }) : super(key: key);

  @override
  _EditPostImagesState createState() => _EditPostImagesState();
}

class _EditPostImagesState extends State<EditPostImages> {
  late Post? postData;
  bool _goToNextStep = false;

  final ImagePicker _picker = ImagePicker();
  List<ImageData> _imageDataList = [];
  bool _isValid = true;

  @override
  void didChangeDependencies() {
    postData = Provider.of<Posts>(context, listen: true).postData;

    bool _isTemp(String id) {
      return postData?.originalImages
              .firstWhereOrNull((element) => element == id) ==
          null;
    }

    if ((postData?.lastStep ?? -1) >= 5) {
      _imageDataList = postData?.images
              .map((id) =>
                  ImageData(id: id, isUploaded: true, isTemp: _isTemp(id)))
              .toList() ??
          [];
    }

    super.didChangeDependencies();
  }

  Future<void> _selectImageFromGallery() async {
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
          showSnackBar(context, _errorMessage);
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

  Future<void> _takeAPhoto() async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      var id = '';

      String _errorMessage = '';
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      try {
        id =
            await Provider.of<Posts>(context, listen: false).getImageUploadId();
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
        showSnackBar(context, _errorMessage);
        return;
      }

      setState(() {
        _imageDataList = [
          ..._imageDataList,
          ImageData(
            file: file,
            id: id,
          ),
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

  Future<void> deleteImage(String id) async {
    String _errorMessage = '';
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if ((postData?.id ?? 0) == 0) {
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
    }

    if (_errorMessage.isNotEmpty) {
      showSnackBar(context, _errorMessage);
      return;
    }

    setState(() {
      _imageDataList =
          _imageDataList.where((element) => element.id != id).toList();
    });
  }

  bool get _isLoading {
    return _imageDataList.firstWhereOrNull(
          (element) => element.isUploaded == false,
        ) !=
        null;
  }

  void _continuePressed() {
    if (_imageDataList.length < 3) {
      setState(() {
        _isValid = false;
      });
      return;
    }

    _goToNextStep = true;
    _updatePost();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const EditPostPrice()));
  }

  void _updatePost() {
    Provider.of<Posts>(context, listen: false).setPostData(
      postData?.copyWith(
        images: _imageDataList.map((element) => element.id).toList(),
        lastStep: 5,
        step: _goToNextStep ? 6 : 4,
      ),
    );
  }

  void _prevStep() {
    _updatePost();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StepTitle(
          title: AppLocalizations.of(context)!.images,
        ),
        leading: IconButton(
          onPressed: () {
            _prevStep();
          },
          icon: const Icon(CustomIcons.back),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal * 8.0, 8.0,
            SizeConfig.safeBlockHorizontal * 8.0, 32.0),
        child: Center(
          child: Column(
            children: [
              if (!_isValid)
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.imagesError,
                      style: TextStyle(color: Theme.of(context).errorColor),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                  ],
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
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16.0),
                                          topRight: Radius.circular(16.0)),
                                    ),
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        height:
                                            SizeConfig.safeBlockVertical * 40.0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton.icon(
                                              onPressed: () async {
                                                if (await Permission.storage
                                                    .request()
                                                    .isGranted) {
                                                  _selectImageFromGallery();
                                                  Navigator.pop(context);
                                                }
                                              },
                                              icon:
                                                  const Icon(CustomIcons.image),
                                              label: Text(
                                                  AppLocalizations.of(context)!
                                                      .selectImageFromGallery),
                                            ),
                                            TextButton.icon(
                                              onPressed: () async {
                                                final Map<Permission,
                                                        PermissionStatus>
                                                    statuses = await [
                                                  Permission.camera,
                                                  Permission.storage
                                                ].request();
                                                bool _areGranted = true;
                                                statuses.forEach(
                                                  (key, value) {
                                                    if (_areGranted &&
                                                        value !=
                                                            PermissionStatus
                                                                .granted) {
                                                      _areGranted = false;
                                                    }
                                                  },
                                                );
                                                if (_areGranted) {
                                                  _takeAPhoto();
                                                  Navigator.pop(context);
                                                }
                                              },
                                              icon: const Icon(
                                                  CustomIcons.camera),
                                              label: Text(
                                                  AppLocalizations.of(context)!
                                                      .takeAPhoto),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
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
                                  Text(AppLocalizations.of(context)!.addImage),
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
      bottomNavigationBar: StyledElevatedButton(
        secondary: true,
        text: AppLocalizations.of(context)!.next,
        loading: _isLoading,
        onPressed: _continuePressed,
        width: SizeConfig.safeBlockHorizontal * 100.0,
        suffixIcon: CustomIcons.next,
      ),
    );
  }
}
