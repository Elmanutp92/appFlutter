import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/colors.dart';

class EditFav extends StatefulWidget {
  final String clase;
  final String favoritoId;
  final String titulo;
  final String descripcion;
  const EditFav({
    super.key,
    required this.favoritoId,
    required this.titulo,
    required this.descripcion,
    required this.clase,
  });

  @override
  State<EditFav> createState() => _EditFavState();
}

class _EditFavState extends State<EditFav> {
  bool isFavorite = true;
  bool isLoading = false;
  TextEditingController tituloController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    tituloController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  String nombre = '';
  String userId = '';
  String email = '';
  String favoritoId = '';

  @override
  void initState() {
    super.initState();

    //********************** */
    print('Titulo: ${widget.titulo} ');
    print('Descripción: ${widget.descripcion} ');
    print('NotaId: ${widget.favoritoId} ');
    tituloController.text = widget.titulo;
    descripcionController.text = widget.descripcion;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      email = user.email!;
    }
  }

// agregar nota
  Future<void> editDataFav(
      String titulo, String descripcion, String favoritoId) async {
    setState(() {
      isLoading = true;
    });
    final dataNote = {
      'titulo': titulo,
      'descripcion': descripcion,
      'clase': widget.clase == 'nota' ? 'nota' : 'tarea',
      'favoritoId': favoritoId,
      'isFavorite': true,
      'fechaCreacion': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('favoritos')
          .doc(favoritoId)
          .set(dataNote);

      setState(() {
        isLoading = false;
      });

      // Verificar si los datos se agregaron correctamente

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('favoritos')
          .doc(favoritoId)
          .get();

      if (snapshot.exists) {
        // Los datos se agregaron correctamente
        Navigator.pushNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              '¡Item editado correctamente!',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      } else {
        // Los datos no se agregaron correctamente
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              '!intentalo más tarde!',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
        Navigator.pushNamed(context, '/home');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Ha ocurrido un error al editar la nota: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
      print(e);
    }
  }

//************   */
  Future<void> deleteDataFav(String favoritoId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('favoritos')
          .doc(favoritoId)
          .delete();

      // Verificar si la nota se eliminó correctamente
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('favoritos')
          .doc(favoritoId)
          .get();

      /*if (!snapshot.exists) {
        // La nota se eliminó correctamente
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              '¡Item eliminado correctamente!',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }*/
      if (snapshot.exists) {
        // La nota no se eliminó correctamente
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              '¡No pudimos eliminar este item de tu lista de favoritos, intentalo mas tarde!',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Ha ocurrido un error al eliminar la nota: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
      print(e);
    }
  }

  // Agregar nota favorita
  Future<void> addDataNote(String titulo, String descripcion) async {
    setState(() {
      isLoading = true;
    });
    final dataNote = {
      'titulo': titulo,
      'descripcion': descripcion,
      'clase': 'nota',
      'isFavorite': false,
      'fechaCreacion': FieldValue.serverTimestamp(),
    };

    try {
      DocumentReference noteRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('notas')
          .add(dataNote);

      setState(() {
        isLoading = false;
      });

      String notaId = noteRef.id;

      // Verificar si los datos se agregaron correctamente
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('notas')
          .doc(notaId)
          .get();

      if (snapshot.exists) {
        deleteDataFav(widget.favoritoId);
        // Los datos se agregaron correctamente
        Navigator.pushNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              '¡Item editado correctamente!',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      } else {
        // Los datos no se agregaron correctamente
        Navigator.pushNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              '¡No pudimos hacer esto, intentalo mas tarde!',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(
              'Ha ocurrido un error al registrar la nota en FAVORITOS: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
      print(e);
    }
  }

  //************   */
  Future<void> addDataTarea(String titulo, String descripcion) async {
    setState(() {
      isLoading = true;
    });
    final dataTarea = {
      'titulo': titulo,
      'descripcion': descripcion,
      'clase': 'tarea',
      'isFavorite': false,
      'fechaCreacion': FieldValue.serverTimestamp(),
    };

    try {
      DocumentReference noteRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('tareas')
          .add(dataTarea);

      setState(() {
        isLoading = false;
      });

      String tareaId = noteRef.id;

      // Verificar si los datos se agregaron correctamente
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('tareas')
          .doc(tareaId)
          .get();

      if (snapshot.exists) {
        deleteDataFav(widget.favoritoId);

        // Los datos se agregaron correctamente
        Navigator.pushNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              '¡Item editado correctamente!',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      } else {
        // Los datos no se agregaron correctamente
        Navigator.pushNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              '¡No pudimos hacer esto, intentalo mas tarde!',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(
              'Ha ocurrido un error al registrar la nota en FAVORITOS: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
      print(e);
    }
  }
  //************* */

  Future<void> fetchData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Builder(builder: (context) {
        return Scaffold(
          body: Builder(builder: (context) {
            return Stack(children: [
              SingleChildScrollView(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: azulBackground,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: widget.clase == 'nota'
                                  ? amarilloGolden
                                  : rosaClaro,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: MediaQuery.of(context).size.height * 0.02,
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: Text(
                                widget.clase == 'Nota' ? 'Nota' : 'Tarea',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.01),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.07,
                            //color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/home');
                                    },
                                    icon: Icon(
                                      Icons.cancel_sharp,
                                      color: Colors.red,
                                      size: MediaQuery.of(context).size.width *
                                          0.1,
                                    )),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      !isFavorite
                                          ? isFavorite = true
                                          : isFavorite = false;
                                    });
                                  },
                                  icon: !isFavorite
                                      ? Icon(Icons.star,
                                          color: Colors.grey,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.07)
                                      : AnimatedEmoji(
                                          AnimatedEmojis.glowingStar,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.07,
                                        ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        isFavorite
                                            ? editDataFav(
                                                tituloController.text,
                                                descripcionController.text,
                                                widget.favoritoId)
                                            : widget.clase == 'nota' &&
                                                    !isFavorite
                                                ? addDataNote(
                                                    tituloController.text,
                                                    descripcionController.text)
                                                : widget.clase == 'tarea' &&
                                                        !isFavorite
                                                    ? addDataTarea(
                                                        tituloController.text,
                                                        descripcionController
                                                            .text)
                                                    : null;
                                      }
                                    },
                                    icon: Icon(
                                      Icons.check,
                                      color: Colors.blue,
                                      size: MediaQuery.of(context).size.width *
                                          0.1,
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    //color: Colors.white,
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingresa un titulo';
                                        }
                                        if (value.length > 15) {
                                          return 'El titulo debe tener maximo 15 caracteres';
                                        }
                                        return null;
                                      },
                                      controller: tituloController,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2),
                                      cursorColor: Colors.black,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2),
                                        hintText: 'Titulo',
                                        hintStyle: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    // color: Colors.white,
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    height: MediaQuery.of(context).size.height,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor ingresa una descripción';
                                        }
                                        return null;
                                      },
                                      controller: descripcionController,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                      cursorColor: Colors.black,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                        hintText: 'Descripción',
                                        hintStyle: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 60,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ))
                        ],
                      ),
                    )),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Guardando nota...',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
            ]);
          }),
        );
      }),
    );
  }
}
