import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

String userId = '';
String nameFile = '';

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

//***** */

Future<void> eliminarImagen(String userId, String imageUrl) async {
  try {
    final FirebaseStorage storage = FirebaseStorage.instance;

    // Convertir la URL en una referencia de Firebase Storage
    final Reference ref = storage.refFromURL(imageUrl);

    // Eliminar la imagen de Firebase Storage
    await ref.delete();

    // Actualizar la URL de la foto en la base de datos (opcional)
    await FirebaseFirestore.instance.collection("users").doc(userId).update({
      "fotoPerfil": '',
    });

    print('La imagen se ha eliminado correctamente.');
  } catch (e) {
    print('Error al eliminar la imagen: $e');
  }
}
