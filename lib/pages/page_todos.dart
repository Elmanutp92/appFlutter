import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_note/pages/create_note.dart';

import '../styles/colors.dart';
import '../widgets/card_action/gesture_card_detector.dart';
import 'create_tarea.dart';

class PageTodos extends StatefulWidget {
  const PageTodos({Key? key}) : super(key: key);

  @override
  State<PageTodos> createState() => _PageTodosState();
}

class _PageTodosState extends State<PageTodos> {
  String nombre = '';
  String userId = '';
  String tareaId = '';
  String favoritoId = '';
  String notaId = '';

  List<Map<String, dynamic>> favoritos = [];
  List<Map<String, dynamic>> notas = [];
  List<Map<String, dynamic>> tareas = [];

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
      QuerySnapshot snapshotFavoritos = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('favoritos')
          .get();
      if (snapshotFavoritos.docs.isNotEmpty) {
        setState(() {
          favoritos = snapshotFavoritos.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['favoritoId'] =
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
            data['notaId'] =
                doc.id; // Agregar el ID de la nota al mapa de datos
            return data;
          }).toList();
        });
      }
      // obtener las tareas favoritas

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
        todos = [...tareas, ...notas, ...favoritos];
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
                          //color: Colors.red,
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
                          color: Colors.transparent,
                          height: MediaQuery.of(context).size.height * 0.534,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: todos.length,
                            itemBuilder: (context, index) {
                              var noId = 'nohayid';
                              return Container(
                                // height: MediaQuery.of(context).size.height * 0.6,
                                //color: Colors.amber,
                                child: Column(
                                  children: [
                                    GestureCardDetector(
                                        clase: todos[index]['clase'],
                                        tiulo: todos[index]['titulo'],
                                        descripcion: todos[index]
                                            ['descripcion'],
                                        itemId: noId,
                                        deleteItem: deleteItem,
                                        isFavorite: todos[index]['isFavorite']),
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
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: azulClaro.withOpacity(0.6),
          ),
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.height * 0.06,
          child: FloatingActionButton(
            backgroundColor: azulNavy,
            elevation: 0,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: azulClaro
                          .withOpacity(0.5), // Ajusta el valor de opacidad aquí
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              minimumSize: MaterialStateProperty.all<Size>(
                                Size(
                                  MediaQuery.of(context).size.width * 0.25,
                                  MediaQuery.of(context).size.height * 0.05,
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  amarilloGolden),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CreateNote(),
                                ),
                              );
                            },
                            child: Text(
                              'Nota',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06,
                              ),
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              minimumSize: MaterialStateProperty.all<Size>(
                                Size(
                                  MediaQuery.of(context).size.width * 0.25,
                                  MediaQuery.of(context).size.height * 0.05,
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(rosaClaro),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CreateTarea(),
                                ),
                              );
                            },
                            child: Text(
                              'Tarea',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  deleteItem() {}
}
