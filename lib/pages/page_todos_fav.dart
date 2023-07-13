import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/colors.dart';

class PageTodosFav extends StatefulWidget {
  const PageTodosFav({super.key});

  @override
  State<PageTodosFav> createState() => _PageTodosFavState();
}

class _PageTodosFavState extends State<PageTodosFav> {
  bool isLoading = true;
  String nombre = '';
  String userId = '';
  String tareaId = '';
  String notaFavoritaId = '';

  List<Map<String, dynamic>> tareasFavoritas = [];

  List<Map<String, dynamic>> notasFavoritas = [];
  List<Map<String, dynamic>> apuntesFavoritos = [];

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
      // *********
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

      setState(() {
        apuntesFavoritos = [...notasFavoritas, ...tareasFavoritas];
        isLoading = false;
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
                if (apuntesFavoritos.isNotEmpty && !isLoading)
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: Center(
                              child: Text(
                            'Hola $nombre, Estos son tus apuntes Favoritos.',
                            style: GoogleFonts.poppins(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          )),
                        ),
                        Container(
                          //color: Colors.white,
                          height: MediaQuery.of(context).size.height * 0.43,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: apuntesFavoritos.length,
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
                                                  color: azulClaro,
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
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          apuntesFavoritos[
                                                              index]['titulo'],
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
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.yellow,
                                                          size: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.08,
                                                        )
                                                      ],
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
                                                        apuntesFavoritos[index]
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
                                        color: azulClaro,
                                        child: ListTile(
                                          trailing: apuntesFavoritos[index]
                                                          ['isFavorite'] ==
                                                      true &&
                                                  apuntesFavoritos[index]
                                                          ['clase'] ==
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
                                                          child: const Text(
                                                              'Nota')),
                                                      Icon(Icons.star,
                                                          color: amarilloGolden,
                                                          size: 40),
                                                    ],
                                                  ),
                                                )
                                              : apuntesFavoritos[index]
                                                              ['isFavorite'] ==
                                                          true &&
                                                      apuntesFavoritos[index]
                                                              ['clase'] ==
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
                                                                  'Tarea')),
                                                          Icon(Icons.star,
                                                              color:
                                                                  amarilloGolden,
                                                              size: 40),
                                                        ],
                                                      ),
                                                    )
                                                  : null,
                                          title: Flexible(
                                            child: Text(
                                              apuntesFavoritos[index]['titulo'],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          subtitle: Flexible(
                                            child: Text(
                                              apuntesFavoritos[index]
                                                  ['descripcion'],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
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
                if (apuntesFavoritos.isEmpty && !isLoading)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            'Hola $nombre, Actualmente No tienes Apuntes marcados como Favoritos.',
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
