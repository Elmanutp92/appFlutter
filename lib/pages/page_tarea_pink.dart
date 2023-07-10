import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/styles/button.dart';

import '../styles/colors.dart';

class PageTareaPink extends StatefulWidget {
  const PageTareaPink({
    Key? key,
  }) : super(key: key);

  @override
  State<PageTareaPink> createState() => _PageTareaPinkState();
}

class _PageTareaPinkState extends State<PageTareaPink> {
  String nombre = '';
  String userId = '';
  String tareaId = '';
  List<Map<String, dynamic>> tareas = [];

  Future<void> deleteDataNote(String tareaId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('notas')
          .doc(tareaId)
          .delete();

      // Verificar si la nota se eliminó correctamente
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('tareas')
          .doc(tareaId)
          .get();
      //widget.pageTareas();

      if (!snapshot.exists) {
        // La nota se eliminó correctamente
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Éxito'),
            content: const Text('La tarea se eliminó correctamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  //widget.crearNota();
                  //widget.pageTareas();

                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      } else {
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

  // obtener datos

  Future<void> fetchData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          nombre = userData['nombre'] ?? '';
        });
      }

      QuerySnapshot snapshotTarea = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('tareas')
          .get();
      if (snapshotTarea.docs.isNotEmpty) {
        setState(() {
          tareas = snapshotTarea.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['tareaId'] =
                doc.id; // Agregar el ID de la nota al mapa de datos
            return data;
          }).toList();
        });
      }
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: azulBackground,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.6,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  if (tareas.isNotEmpty)
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            child: Center(
                                child: Text(
                              'Hola $nombre, Estas son tus tareas.',
                              style: GoogleFonts.poppins(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05),
                            )),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              itemCount: tareas.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(19.0),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: rosaClaro,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.5,
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      //color: Colors.white,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.06,
                                                      child: Text(
                                                        tareas[index]['titulo'],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      // 20.0,
                                                    ),
                                                    SingleChildScrollView(
                                                      child: Container(
                                                        //color: Colors.white,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.32,
                                                        child: Text(
                                                          tareas[index]
                                                              ['descripcion'],
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                                      azulNavy),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Cerrar')),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          elevation: 6,
                                          color: rosaClaro,
                                          child: ListTile(
                                            trailing: IconButton(
                                              onPressed: () {
                                                deleteDataNote(
                                                    tareas[index]['notaId']);
                                              },
                                              icon: const Icon(Icons.delete),
                                            ),
                                            title: Flexible(
                                              child: Text(
                                                tareas[index]['titulo'],
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            subtitle: Flexible(
                                              child: Text(
                                                tareas[index]['descripcion'],
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (tareas.isEmpty)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Hola $nombre, Actualmente No tienes tareas.',
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 20),
                          const Icon(Icons.error, size: 100, color: azulClaro),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                ],
              ),
              //SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              ButtonHome(
                  color: rosaClaro,
                  onPressed: () {
                    Navigator.pushNamed(context, '/createTarea');
                  },
                  btntxt: 'Crear Tarea')
            ],
          ),
        ),
      ),
    );
  }
}
