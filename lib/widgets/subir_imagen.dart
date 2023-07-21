import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

String userId = '';

Future<Map<String, Object>> subirImagen(File imagen) async {
  final FirebaseStorage storage = FirebaseStorage.instance;

  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    userId = user.uid;
  }

  print(imagen.path);
  final String nameFile = imagen.path.split('/').last;

  final Reference ref =
      storage.ref().child('imagenes').child(userId).child(nameFile);
  final UploadTask uploadTask = ref.putFile(imagen);
  print('uploadTask: $uploadTask');

  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  print('snapshot: $snapshot');

  final String urlImagen = await snapshot.ref.getDownloadURL();
  print('urlImagen: $urlImagen');

  final imageUrl = await ref.getDownloadURL();
  print('imageUrl: $imageUrl');

  if (snapshot.state == TaskState.success) {
    return {
      'status': true,
      'url': imageUrl,
    };
  } else {
    return {
      'status': false,
      'url': '',
    };
  }
}
