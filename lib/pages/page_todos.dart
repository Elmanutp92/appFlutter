import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/colors.dart';

class PageTodos extends StatefulWidget {
  const PageTodos({Key? key}) : super(key: key);

  @override
  State<PageTodos> createState() => _PageTodosState();
}

class _PageTodosState extends State<PageTodos> {
  String nombre = '';
  String userId = '';
  String tareaId = '';
  String notaFavoritaId = '';
  List<Map<String, dynamic>> tareas = [];
  List<Map<String, dynamic>> tareasFavoritas = [];
  List<Map<String, dynamic>> notas = [];
  List<Map<String, dynamic>> notasFavoritas = [];
  List<Map<String, dynamic>> todos = [];
  bool isLoading = true;

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
      // obtener las notas favoritas
      QuerySnapshot snapshotNF = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('notasFavoritas')
          .get();
      if (snapshotNF.docs.isNotEmpty) {
        setState(() {
          notasFavoritas = snapshotNF.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['notaFavoritaId'] =
                doc.id; // Agregar el ID de la nota al mapa de datos
            return data;
          }).toList();
        });
      }
      // obtener las notas
      QuerySnapshot snapshotNotas = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('notas')
          .get();
      if (snapshotNotas.docs.isNotEmpty) {
        setState(() {
          notas = snapshotNotas.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['notaFavoritaId'] =
                doc.id; // Agregar el ID de la nota al mapa de datos
            return data;
          }).toList();
        });
      }
      // obtener las tareas favoritas
      QuerySnapshot snapshotTF = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('tareasFavoritas')
          .get();
      if (snapshotTF.docs.isNotEmpty) {
        setState(() {
          tareasFavoritas = snapshotTF.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['tareaFavoritaId'] =
                doc.id; // Agregar el ID de la nota al mapa de datos
            return data;
          }).toList();
        });
      }
      // obtener las tareas
      QuerySnapshot snapshotTareas = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('tareas')
          .get();
      if (snapshotTareas.docs.isNotEmpty) {
        setState(() {
          tareas = snapshotTareas.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['tareaId'] =
                doc.id; // Agregar el ID de la nota al mapa de datos
            return data;
          }).toList();
        });
      }
      setState(() {
        todos = [...tareas, ...tareasFavoritas, ...notas, ...notasFavoritas];
        isLoading = false; // Finalizó la carga, establece isLoading en false
      });
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
                if (todos.isNotEmpty && !isLoading)
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: Center(
                            child: Text(
                              'Hola $nombre, Estos son todos tus apuntes.',
                              style: GoogleFonts.poppins(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.43,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: todos.length,
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
                                                color: todos[index]
                                                        ['isFavorite']
                                                    ? azulClaro
                                                    : todos[index]['clase'] ==
                                                            'nota'
                                                        ? amarilloGolden
                                                        : todos[index]
                                                                    ['clase'] ==
                                                                'tarea'
                                                            ? rosaClaro
                                                            : Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
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
                                                    child: todos[index][
                                                                'isFavorite'] ==
                                                            true
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Text(
                                                                todos[index]
                                                                    ['titulo'],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.08,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .yellow,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.08,
                                                              )
                                                            ],
                                                          )
                                                        : Text(
                                                            todos[index]
                                                                ['titulo'],
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.08,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
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
                                                        todos[index]
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
                                                    child: const Text('Cerrar'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 6,
                                        color: todos[index]['isFavorite']
                                            ? azulClaro
                                            : todos[index]['clase'] == 'nota'
                                                ? amarilloGolden
                                                : todos[index]['clase'] ==
                                                        'tarea'
                                                    ? rosaClaro
                                                    : Colors.red,
                                        child: ListTile(
                                          trailing: todos[index]
                                                      ['isFavorite'] &&
                                                  todos[index]['clase'] ==
                                                      'nota'
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.1,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                        child:
                                                            const Text('Nota'),
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color: amarilloGolden,
                                                        size: 40,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : todos[index]['isFavorite'] &&
                                                      todos[index]['clase'] ==
                                                          'tarea'
                                                  ? Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.2,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.1,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.1,
                                                            child: const Text(
                                                                'Tarea'),
                                                          ),
                                                          Icon(
                                                            Icons.star,
                                                            color:
                                                                amarilloGolden,
                                                            size: 40,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : todos[index]['clase'] ==
                                                          'nota'
                                                      ? Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.1,
                                                          child: const Text(
                                                              'Nota'),
                                                        )
                                                      : todos[index]['clase'] ==
                                                              'tarea'
                                                          ? Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.1,
                                                              child: const Text(
                                                                  'Tarea'),
                                                            )
                                                          : null,
                                          title: Flexible(
                                            child: Text(
                                              todos[index]['titulo'] ?? '',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          subtitle: Flexible(
                                            child: Text(
                                              todos[index]['descripcion'] ?? '',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                if (todos.isEmpty && !isLoading)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Hola $nombre, Actualmente no tienes ningún item en ninguna de tus listas.',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Spacer(),
            SpeedDial(
              direction: SpeedDialDirection.up,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0,
              overlayColor: Colors.black.withOpacity(0.5),
              overlayOpacity: 0.5,
              icon: Icons.add,
              activeIcon: Icons.close,
              children: [
                SpeedDialChild(
                  child: Icon(
                    Icons.task,
                    color: rosaClaro,
                    size: MediaQuery.of(context).size.width * 0.1,
                  ),
                  backgroundColor: Colors.transparent,
                  label: 'Crear Tarea',
                  labelStyle: TextStyle(fontSize: 20),
                  onTap: () {
                    Navigator.pushNamed(context, '/createTarea');
                  },
                ),
                SpeedDialChild(
                  child: Icon(
                    Icons.note,
                    color: amarilloGolden,
                    size: MediaQuery.of(context).size.width * 0.1,
                  ),
                  backgroundColor: Colors.transparent,
                  label: 'Crear Nota',
                  labelStyle: TextStyle(fontSize: 20),
                  onTap: () {
                    Navigator.pushNamed(context, '/createNota');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
