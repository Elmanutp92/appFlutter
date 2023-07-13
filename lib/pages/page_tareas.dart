import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:google_fonts/google_fonts.dart';

import '../styles/colors.dart';
import 'edit_nota.dart';

class PageTareas extends StatefulWidget {
  const PageTareas({
    Key? key,
  }) : super(key: key);

  @override
  State<PageTareas> createState() => _PageTareasState();
}

class _PageTareasState extends State<PageTareas> {
  bool deleteEdit = false;
  bool isLoading = true;
  String nombre = '';
  String userId = '';
  String noteId = '';
  List<Map<String, dynamic>> notas = [];

  Future<void> deleteDataNote(String noteId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('notas')
          .doc(noteId)
          .delete();

      setState(() {
        deleteEdit;
      });

      // Verificar si la nota se eliminó correctamente
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('notas')
          .doc(noteId)
          .get();

      if (!snapshot.exists && !deleteEdit) {
        // La nota se eliminó correctamente
        // ignore: use_build_context_synchronously
        showDialog(
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

      QuerySnapshot snapshotNote = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('notas')
          .get();
      if (snapshotNote.docs.isNotEmpty) {
        setState(() {
          notas = snapshotNote.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['notaId'] =
                doc.id; // Agregar el ID de la nota al mapa de datos
            return data;
          }).toList();
        });
      }
    }
    setState(() {
      isLoading = false;
    });
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
        child: Column(
          children: [
            Stack(
              children: [
                if (isLoading) // Muestra el indicador de carga mientras isLoading es true
                  const Center(
                    child: Column(
                      children: [
                        Text('Espere un momento...'),
                        SpinKitCircle(
                          color: azulNavy,
                          size: 50.0,
                        ),
                      ],
                    ),
                  ),
                if (notas.isNotEmpty && !isLoading)
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: Center(
                              child: Text(
                            'Hola $nombre, Estas son tus notas.',
                            style: GoogleFonts.poppins(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          )),
                        ),
                        Container(
                          //color: Colors.white,
                          height: MediaQuery.of(context).size.height * 0.45,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: notas.length,
                            itemBuilder: (context, index) {
                              return Container(
                                //color: Colors.red,
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
                                                  color: amarilloGolden,
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
                                                mainAxisSize: MainAxisSize.min,
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
                                                      notas[index]['titulo'],
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
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.32,
                                                      child: Text(
                                                        notas[index]
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
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text('Cerrar')),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                          elevation: 6,
                                          color: amarilloGolden,
                                          child: ListTile(
                                            trailing: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditNote(
                                                            notaId: notas[index]
                                                                ['notaId'],
                                                            titulo: notas[index]
                                                                ['titulo'],
                                                            descripcion: notas[
                                                                    index]
                                                                ['descripcion'],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    icon:
                                                        const Icon(Icons.edit),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder:
                                                              (context) =>
                                                                  AlertDialog(
                                                                    title: const Text(
                                                                        '¿Estas seguro?'),
                                                                    content:
                                                                        const Text(
                                                                            '¿Quieres eliminar esta nota?'),
                                                                    actions: [
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Text('Cancelar')),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);

                                                                            deleteDataNote(notas[index]['notaId']);

                                                                            setState(() {
                                                                              notas.removeAt(index);
                                                                            });
                                                                          },
                                                                          child:
                                                                              const Text('Eliminar')),
                                                                    ],
                                                                  ));
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            title: Flexible(
                                              child: Text(
                                                notas[index]['titulo'],
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            subtitle: Flexible(
                                              child: Text(
                                                notas[index]['descripcion'],
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
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
                if (notas.isEmpty && !isLoading)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Hola $nombre, Actualmente No tienes notas.',
                            style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
              ],
            ),
            //SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ],
        ),
      ),
    );
  }
}
