import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_note/widgets/card_action/gesture_card_detector.dart';

import '../styles/colors.dart';

class PageTodosFav extends StatefulWidget {
  const PageTodosFav({super.key});

  @override
  State<PageTodosFav> createState() => _PageTodosFavState();
}

class _PageTodosFavState extends State<PageTodosFav> {
  String favoritoId = '';
  bool isLoading = true;
  String nombre = '';
  String userId = '';

  List<Map<String, dynamic>> favoritos = [];

// ******
  Future<void> deleteDataFav(String favoritoId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('favoritos')
          .doc(favoritoId)
          .delete();

      setState(() {
        favoritos
            .removeWhere((favoritos) => favoritos['favoritoId'] == favoritoId);
      });

      // Verificar si la nota se eliminó correctamente
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('favoritos')
          .doc(favoritoId)
          .get();

      if (!snapshot.exists) {
        // La nota se eliminó correctamente
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Éxito'),
            content:
                const Text('Tu elemmento Favorito se eliminó correctamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  //widget.crearNota();
                  setState(() {
                    fetchData();
                  });

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
            content: const Text(
                'Ha ocurrido un error al eliminar tu elemento Favorito.'),
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
          content:
              Text('Ha ocurrido un error al eliminar tu elemento Favorito: $e'),
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

//**** */
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

      // *********
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

      setState(() {
        isLoading = false;
      });
    }
  }

//***** */
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
        height: MediaQuery.of(context).size.height * 0.7,
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
                if (favoritos.isNotEmpty && !isLoading)
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: Center(
                              child: Text(
                            'Hola $nombre, Estos son tus apuntes favoritos.',
                            style: GoogleFonts.poppins(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          )),
                        ),
                        Container(
                          //color: Colors.white,
                          height: MediaQuery.of(context).size.height * 0.534,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: favoritos.length,
                            itemBuilder: (context, index) {
                              return Container(
                                //color: Colors.red,
                                child: Column(
                                  children: [
                                    GestureCardDetector(
                                        fecha:
                                            DateTime.fromMillisecondsSinceEpoch(
                                          favoritos[index]['fechaCreacion']
                                              .millisecondsSinceEpoch,
                                        ),
                                        isTodos: false,
                                        clase: favoritos[index]['clase'],
                                        tiulo: favoritos[index]['titulo'],
                                        descripcion: favoritos[index]
                                            ['descripcion'],
                                        itemId: favoritos[index]['favoritoId'],
                                        deleteItem: deleteDataFav,
                                        isFavorite: favoritos[index]
                                            ['isFavorite']),
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
                if (favoritos.isEmpty && !isLoading)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                            '¡Ups, Parece que aquí no hay nada! \n ¡Buuuu!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20)),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15),
                        AnimatedEmoji(
                          AnimatedEmojis.ghost,
                          size: MediaQuery.of(context).size.width * 0.5,
                        ),
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
