import 'package:image_picker/image_picker.dart';

Future getImage() async {
  final ImagePicker image = ImagePicker();
  final XFile? imagen = await image.pickImage(source: ImageSource.gallery);
  return imagen;
}

Future getCamera() async {
  final ImagePicker image = ImagePicker();
  final XFile? imagen = await image.pickImage(source: ImageSource.camera);
  return imagen;
}
