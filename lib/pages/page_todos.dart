import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/button.dart';
import '../styles/colors.dart';

class PageTodos extends StatefulWidget {
  const PageTodos({super.key});

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

      QuerySnapshot snapshotTF = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('notasFavoritas')
          .get();
      if (snapshotTF.docs.isNotEmpty) {
        setState(() {
          notasFavoritas = snapshotTF.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['notaFavoritaId'] =
                doc.id; // Agregar el ID de la nota al mapa de datos
            return data;
          }).toList();
        });
      }
      print(notasFavoritas.length);
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
                if (notasFavoritas.isNotEmpty)
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: Center(
                              child: Text(
                            'Hola $nombre, Estas son tus notas Favoritas.',
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
                            itemCount: notasFavoritas.length,
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
                                                  color: Colors.white,
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
                                                      notasFavoritas[index]
                                                          ['titulo'],
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
                                                        notasFavoritas[index]
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
                                        color: Colors.white,
                                        child: ListTile(
                                          trailing: Icon(Icons.star,
                                              color: amarilloGolden, size: 40),
                                          title: Flexible(
                                            child: Text(
                                              notasFavoritas[index]['titulo'],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          subtitle: Flexible(
                                            child: Text(
                                              notasFavoritas[index]
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
                if (notasFavoritas.isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Hola $nombre, Actualmente No tienes notas.',
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(height: 20),
                        const Icon(Icons.error, size: 100, color: azulClaro),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
              ],
            ),
            //SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            ButtonHome(
                color: amarilloGolden,
                onPressed: () {
                  Navigator.pushNamed(context, '/createNota');
                },
                btntxt: 'Crear Nota')
          ],
        ),
      ),
    );
  }
}
