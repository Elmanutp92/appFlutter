import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../styles/colors.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

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
            content: const Text('La nota se agregó correctamente.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/tareas'),
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
      child: Scaffold(
        body: Stack(children: [
          Container(
              decoration: const BoxDecoration(),
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Crear nota',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: azulClaro),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa un titulo';
                              }
                              return null;
                            },
                            controller: tituloController,
                            style: TextStyle(color: azulClaro),
                            cursorColor: azulClaro,
                            decoration: const InputDecoration(
                              labelStyle: TextStyle(color: azulClaro),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: azulClaro),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: azulClaro),
                              ),
                              labelText: 'titulo',
                              hintText: 'Ingresa el titulo de la nota',
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu contraseña';
                              }
                              return null;
                            },
                            controller: descripcionController,
                            style: TextStyle(color: azulClaro),
                            cursorColor: azulClaro,
                            decoration: const InputDecoration(
                              labelStyle: TextStyle(color: azulClaro),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: azulClaro),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: azulClaro),
                              ),
                              labelText: 'Descripción',
                              hintText: 'Ingresa la descripción de la nota',
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(double.infinity, 50)),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(azulClaro),
                            ),
                            child: const Text('Guardar nota',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                addDataNote(tituloController.text,
                                    descripcionController.text);
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/home');
                              },
                              child: const Text(
                                'Cancelar',
                                style:
                                    TextStyle(color: azulClaro, fontSize: 20),
                              ))
                        ],
                      ))
                ],
              )),
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
        ]),
      ),
    );
  }
}
