import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_note/styles/colors.dart';
import 'package:lets_note/widgets/subir_imagen.dart';

import '../pages/imagen_profile.dart';

class FotoCircularProfile extends StatefulWidget {
  final String nombre;
  final String apellido;
  final Function? onPressed;

  const FotoCircularProfile({
    super.key,
    required this.nombre,
    required this.apellido,
    this.onPressed,
  });

  @override
  State<FotoCircularProfile> createState() => _FotoCircularProfileState();
}

class _FotoCircularProfileState extends State<FotoCircularProfile> {
  String foto = '';
  String userId = '';

  bool isLoading = false;
  File? imagenPerfil;
  String? perfilFoto;
  String? profilePhoto;
  bool? status = false;
  String imageUrl = '';
  String fotoFinal = '';

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      fetchData();
    }
  }

  //*********** */
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
  //*********** */

  Future<void> fetchData() async {
    if (userId.isNotEmpty) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          foto = userData['fotoPerfil'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String actualPage = ModalRoute.of(context)!.settings.name ?? '';
    return InkWell(
        onTap: () {
          !isLoading
              ? showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text('Cambiar foto de perfil'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('Tomar foto'),
                                onTap: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final XFile? fotoPerfil = await getCamera();
                                  fotoPerfil == null
                                      ? print('No se tomó foto')
                                      : setState(() {
                                          imagenPerfil = File(fotoPerfil.path);
                                        });
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
                                  setState(() {
                                    isLoading = false;
                                  });
                                }),
                            ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text('Seleccionar foto'),
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                final XFile? fotoPerfil = await getImage();
                                fotoPerfil == null
                                    ? print('No se seleccionó foto')
                                    : setState(() {
                                        imagenPerfil = File(fotoPerfil.path);
                                      });
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
                                setState(() {
                                  isLoading = false;
                                });
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text('Borrar foto'),
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                Navigator.pop(context);
                                await eliminarImagen(userId, foto);

                                setState(() {
                                  isLoading = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ))
              : const CircularProgressIndicator();
        },
        child: Container(
          //color: Colors.amber,
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.22,
                child: CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        foto.isEmpty ? Colors.grey : Colors.transparent,
                    child: foto.isEmpty
                        ? Text(
                            (widget.nombre.isNotEmpty
                                    ? widget.nombre[0].toUpperCase()
                                    : '?') +
                                (widget.apellido.isNotEmpty
                                    ? widget.apellido[0].toUpperCase()
                                    : '?'),
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.normal,
                            ))
                        : ClipOval(
                            child: Image.network(foto,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                fit: BoxFit.cover),
                          )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              IconButton(
                  onPressed: () {
                    fetchData();
                  },
                  icon: Icon(
                    Icons.refresh,
                    color: azulNavy,
                    size: MediaQuery.of(context).size.width * 0.08,
                  ))
            ],
          ),
        ));
  }
}
