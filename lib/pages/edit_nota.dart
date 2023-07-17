import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/colors.dart';

class EditNote extends StatefulWidget {
  final String notaId;
  final String titulo;
  final String descripcion;
  const EditNote({
    super.key,
    required this.notaId,
    required this.titulo,
    required this.descripcion,
  });

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  bool isFavorite = false;
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
    print('NotaId: ${widget.notaId} ');
    tituloController.text = widget.titulo;
    descripcionController.text = widget.descripcion;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      email = user.email!;
    }
  }

// agregar nota
  Future<void> editDataNote(
      String titulo, String descripcion, String notaId) async {
    setState(() {
      isLoading = true;
    });
    final dataNote = {
      'titulo': titulo,
      'descripcion': descripcion,
      'noteId': notaId,
      'clase': 'nota',
      'isFavorite': false,
    };

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('notas')
          .doc(notaId)
          .set(dataNote);

      setState(() {
        isLoading = false;
      });

      // Verificar si los datos se agregaron correctamente

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('notas')
          .doc(notaId)
          .get();

      if (snapshot.exists) {
        // Los datos se agregaron correctamente
        Navigator.pushNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              '¡Nota editada correctamente!',
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
              '!No pudimos eliminar tu nota, intentalo más tarde!',
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
  Future<void> deleteDataNote(String notaId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('notas')
          .doc(notaId)
          .delete();

      // Verificar si la nota se eliminó correctamente
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('notas')
          .doc(notaId)
          .get();

      //if (snapshot.exists ) {
      // La nota se eliminó correctamente
      // ignore: use_build_context_synchronously
      /* showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Éxito'),
            content: const Text('La nota se eliminó correctamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  //widget.crearNota();

                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        );*/
      // }
      if (snapshot.exists) {
        // La nota no se eliminó correctamente
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Ha ocurrido un error al eliminar la nota'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              ),
            ],
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
  Future<void> addDataNoteFavorite(String titulo, String descripcion) async {
    setState(() {
      isLoading = true;
    });
    final dataNoteFavorite = {
      'titulo': titulo,
      'descripcion': descripcion,
      'clase': 'nota',
      'isFavorite': true,
    };

    try {
      DocumentReference noteRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('favoritos')
          .add(dataNoteFavorite);

      setState(() {
        isLoading = false;
      });

      String favoritoId = noteRef.id;

      // Verificar si los datos se agregaron correctamente
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('favoritos')
          .doc(favoritoId)
          .get();

      if (snapshot.exists) {
        // Los datos se agregaron correctamente
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Éxito'),
            content: const Text('Nota registrada correctamente en FAVORITOS'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/home'),
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      } else {
        // Los datos no se agregaron correctamente
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Ha ocurrido un error al registrar la nota en FAVORITOS'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              ),
            ],
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
                              color: amarilloGolden,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: MediaQuery.of(context).size.height * 0.02,
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: const Text('Nota',
                                textAlign: TextAlign.center,
                                style: TextStyle(
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
                                    icon: Icon(Icons.star,
                                        color: !isFavorite
                                            ? Colors.grey
                                            : amarilloGolden,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.07)),
                                IconButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        !isFavorite
                                            ? editDataNote(
                                                tituloController.text,
                                                descripcionController.text,
                                                widget.notaId)
                                            : (
                                                addDataNoteFavorite(
                                                    tituloController.text,
                                                    descripcionController.text),
                                                deleteDataNote(widget.notaId)
                                              );
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
