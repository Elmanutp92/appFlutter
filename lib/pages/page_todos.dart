import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lets_note/widgets/buscar.dart';
import 'package:lets_note/widgets/lista_vacia.dart';
import 'package:lets_note/widgets/no_found.dart';

import '../styles/colors.dart';
import '../widgets/boton_crear.dart';
import '../widgets/card_action/gesture_card_detector.dart';

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
  String searchTerm = '';
  bool buscando = false;
  DateTime fecha = DateTime.now();

  List<Map<String, dynamic>> favoritos = [];
  List<Map<String, dynamic>> notas = [];
  List<Map<String, dynamic>> tareas = [];

  List<Map<String, dynamic>> todos = [];
  List<Map<String, dynamic>> itemsFiltrados = [];

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
      // obtener los favoritas
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
        todos = [...favoritos, ...notas, ...tareas];
        itemsFiltrados = todos;
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
    final mh = MediaQuery.of(context).size.height;
    // final mw = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
          color: azulBackground,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
                          SearchHome(filtrarItems: filtrarItems),
                          SizedBox(
                            height: mh * 0.005,
                          ),
                          Container(
                            //color: Colors.amber,
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              itemCount: itemsFiltrados.length,
                              itemBuilder: (context, index) {
                                var noId = 'nohayid';

                                return Container(
                                  // height: MediaQuery.of(context).size.height * 0.6,
                                  //color: Colors.amber,
                                  child: Column(
                                    children: [
                                      GestureCardDetector(
                                          fecha: fecha,
                                          isTodos: true,
                                          clase: itemsFiltrados[index]['clase'],
                                          tiulo: itemsFiltrados[index]
                                              ['titulo'],
                                          descripcion: itemsFiltrados[index]
                                              ['descripcion'],
                                          itemId: noId,
                                          deleteItem: deleteItem,
                                          isFavorite: itemsFiltrados[index]
                                              ['isFavorite']),
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
                  if (todos.isEmpty && !isLoading) const ListaVacia(),
                  if (itemsFiltrados.isEmpty && !isLoading && buscando)
                    const NoFound(),
                ],
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: const BotonCrear());
  }

  deleteItem() {}

  void filtrarItems(String query) {
    setState(() {
      searchTerm = query.toLowerCase(); // Convertir a minúsculas

      if (searchTerm.isEmpty) {
        buscando = false;

        itemsFiltrados = todos;
      } else {
        buscando = true;
        itemsFiltrados = todos.where((item) {
          final titulo =
              item['titulo'].toString().toLowerCase(); // Convertir a minúsculas
          final descripcion = item['descripcion']
              .toString()
              .toLowerCase(); // Convertir a minúsculas

          return titulo.contains(searchTerm) ||
              descripcion.contains(searchTerm);
        }).toList();
      }
    });
  }
}
