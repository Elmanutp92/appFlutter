import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_note/pages/create_note.dart';
import 'package:lets_note/widgets/buscar.dart';

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
  String searchTerm = '';
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
    final mw = MediaQuery.of(context).size.width;

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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            onChanged:
                                // Filtrar la lista de notas en base al valor de búsqueda
                                filtrarItems,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.search,
                                color: negro,
                              ),
                              filled: true,
                              fillColor: blanco,
                              labelStyle: TextStyle(color: negro),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: negro),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelText: 'Buscar',
                              hintText: 'Ejemplo: "Mercado"',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
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
                                        tiulo: itemsFiltrados[index]['titulo'],
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
                if (todos.isEmpty && !isLoading)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                            '¡Ups, Parece que aquí no hay nada! \n ¡Buuuu!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20)),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),
                        AnimatedEmoji(
                          AnimatedEmojis.ghost,
                          size: MediaQuery.of(context).size.width * 0.5,
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

  void filtrarItems(String query) {
    setState(() {
      searchTerm = query;
      if (searchTerm.isEmpty) {
        itemsFiltrados = todos;
      } else {
        itemsFiltrados = todos.where((item) {
          final titulo = item['titulo'].toString();
          final descripcion = item['descripcion'].toString();
          return titulo.contains(searchTerm.toLowerCase()) ||
              descripcion.contains(searchTerm.toLowerCase());
        }).toList();
      }
    });
  }
}
