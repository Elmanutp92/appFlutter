import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../widgets/listtile_drawer.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({
    super.key,
  });

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
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
  String noteId = '';

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      email = user.email!;
    }
  }

// agregar nota
  Future<void> addDataNote(String titulo, String descripcion) async {
    setState(() {
      isLoading = true;
    });
    final dataNote = {
      'titulo': titulo,
      'descripcion': descripcion,
      'noteId': noteId
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

      String noteId = noteRef.id;

      // Verificar si los datos se agregaron correctamente
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('notas')
          .doc(noteId)
          .get();

      if (snapshot.exists) {
        // Los datos se agregaron correctamente
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Éxito'),
            content: const Text('Nota registrada correctamente'),
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
            content: const Text('Ha ocurrido un error al registrar la nota'),
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
          content: Text('Ha ocurrido un error al registrar la nota: $e'),
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
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Builder(builder: (context) {
          return Scaffold(
            endDrawer: const Drawer(
              backgroundColor: amarilloGolden,
              // Agrega el contenido del drawer aquí
              child: ListTileDrawer(),
            ),
            body: Builder(builder: (context) {
              return Stack(children: [
                SingleChildScrollView(
                  child: Container(
                      color: azulBackground,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.05),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.07,
                            //color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              addDataNote(tituloController.text,
                                                  descripcionController.text);
                                            }
                                          },
                                          icon: Icon(
                                            Icons.check,
                                            color: Colors.blue,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                          )),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/home');
                                          },
                                          icon: Icon(
                                            Icons.cancel_sharp,
                                            color: Colors.red,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                          )),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.menu),
                                  onPressed: () {
                                    Scaffold.of(context).openEndDrawer();
                                  },
                                ),
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
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
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
      ),
    );
  }
}
