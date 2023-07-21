import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lets_note/pages/imagen_profile.dart';
import 'package:lets_note/widgets/foto_circular.dart';
import 'package:lets_note/widgets/subir_imagen.dart';

class FotoPerfil extends StatefulWidget {
  final String nombre;
  final String apellido;

  const FotoPerfil({super.key, required this.nombre, required this.apellido});

  @override
  State<FotoPerfil> createState() => _FotoPerfilState();
}

class _FotoPerfilState extends State<FotoPerfil> {
  String userId = '';
  bool isLoading = false;
  File? imagenPerfil;
  String? perfilFoto;
  String? profilePhoto;
  bool? status = false;
  String imageUrl = '';
  String fotoFinal = '';

  //**************** */
  @override
  void initState() {
    super.initState();
    //fetchData();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
    }
  }

//********* */

  // agregar foto a base de datos
  Future<void> addFoto(String foto) async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection("users").doc(userId).update({
        "fotoPerfil": foto,
      });

      // Verificar si los datos se agregaron correctamente
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        profilePhoto = data['fotoPerfil'].toString();
        setState(() {
          isLoading = false;
        });
        // Los datos se agregaron correctamente
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Los datos se agregaron correctamente.'),
          ),
        );
      } else {
        // Los datos no se agregaron correctamente
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudieron agregar los datos.'),
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Ha ocurrido un error al registrar los datos: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok'),
            ),
          ],
        ),
      );
      print(e);
    }
  }

//************************ */
  Future<void> deleteFoto() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection("users").doc(userId).update({
        "fotoPerfil": '',
      });

      // Verificar si los datos se agregaron correctamente
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        profilePhoto = data['fotoPerfil'].toString();
        setState(() {
          isLoading = false;
        });
        // Los datos se agregaron correctamente
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Los datos se agregaron correctamente.'),
          ),
        );
      } else {
        // Los datos no se agregaron correctamente
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudieron agregar los datos.'),
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Ha ocurrido un error al registrar los datos: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok'),
            ),
          ],
        ),
      );
      print(e);
    }
  }

//************************* */
  //**************** */
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text('Cambiar foto de perfil'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.remove_red_eye_rounded),
                          title: const Text('Visualizar foto'),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                    content: FotoCircular(
                                        nombre: widget.nombre,
                                        apellido: widget.apellido)));
                          },
                        ),
                        ListTile(
                          leading: Icon(imagenPerfil == null
                              ? Icons.camera_alt
                              : Icons.upload),
                          title: Text(imagenPerfil == null
                              ? 'Tomar foto'
                              : 'Subir foto'),
                          onTap: imagenPerfil == null
                              ? () async {
                                  final XFile? fotoPerfil = await getCamera();
                                  setState(() {
                                    imagenPerfil = File(fotoPerfil!.path);
                                  });
                                }
                              : () async {
                                  Map<String, Object> response =
                                      await subirImagen(imagenPerfil!);
                                  final status = response['status'];
                                  final imageUrl = response['url'].toString();

                                  if (status == true && imageUrl.isNotEmpty) {
                                    await addFoto(
                                        imageUrl); // Pasar directamente la URL de la imagen a la función addFoto
                                    Navigator.pop(context);
                                  } else {
                                    // Manejar la situación en caso de que la subida de imagen falle
                                  }
                                },
                        ),
                        ListTile(
                          leading: const Icon(Icons.image),
                          title: const Text('Seleccionar foto'),
                          onTap: () async {
                            final XFile? FotoPerfil = await getImage();
                            setState(() {
                              imagenPerfil = File(FotoPerfil!.path);
                            });
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Borrar foto'),
                          onTap: () async {
                            deleteFoto();
                          },
                        ),
                      ],
                    ),
                  ));
        },
        child: FotoCircular(
          nombre: widget.nombre,
          apellido: widget.apellido,
        ));
  }
}
