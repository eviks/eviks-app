import 'package:image_picker/image_picker.dart';

class ImageData {
  XFile? file;
  String id;
  bool isUploaded;

  ImageData({
    this.file,
    required this.id,
    this.isUploaded = false,
  });
}
