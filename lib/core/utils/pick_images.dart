import 'package:image_picker/image_picker.dart';

class PickImage {
  final ImagePicker picker = ImagePicker();
  
  Future<XFile?> pickImage(ImageSource src) async {
    final XFile? image = await picker.pickImage(source: src);
    if (image != null) {
      return image;
    } else {
      print("Could not pick a Image");
      return null;
    }
  }
}
