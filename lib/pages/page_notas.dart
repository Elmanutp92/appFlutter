import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:google_fonts/google_fonts.dart';

import '../styles/colors.dart';
import '../widgets/buscar.dart';
import '../widgets/card_action/gesture_card_detector.dart';
import '../widgets/lista_vacia.dart';
import '../widgets/no_found.dart';

class PageTareas extends StatefulWidget {
  const PageTareas({
    Key? key,
  }) : super(key: key);

  @override
  State<PageTareas> createState() => _PageTareasState();
}

class _PageTareasState extends State<PageTareas> {
  bool notasVacias = false;
  bool deleteEdit = false;
  bool isLoading = true;
  String nombre = '';
  String userId = '';
  String noteId = '';
  String searchTerm = '';
  bool buscando = false;
  List<Map<String, dynamic>> notas = [];
  List<Map<String, dynamic>> itemsFiltrados = [];

  Future<void> deleteDataNote(String noteId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('notas')
          .doc(noteId)
          .delete();

      setState(() {
        notas.removeWhere((notas) => notas['notaId'] == noteId);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              '¡Nota eliminada correctamente!',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
        Navigator.pushNamed(context, '/home');
      } else {
        // La nota no se eliminó correctamente
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

    fetchData();
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
      itemsFiltrados = notas;
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
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            //const SearchHome(),
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
                        SearchHome(filtrarItems: filtrarItems),
                        Container(
                          //color: Colors.white,
                          height: MediaQuery.of(context).size.height * 0.534,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: itemsFiltrados.length,
                            itemBuilder: (context, index) {
                              return Container(
                                //color: Colors.red,
                                child: Column(
                                  children: [
                                    GestureCardDetector(
                                      isTodos: false,
                                      fecha:
                                          DateTime.fromMillisecondsSinceEpoch(
                                        itemsFiltrados[index]['fechaCreacion']
                                            .millisecondsSinceEpoch,
                                      ),
                                      isFavorite: itemsFiltrados[index]
                                          ['isFavorite'],
                                      clase: itemsFiltrados[index]['clase'],
                                      tiulo: itemsFiltrados[index]['titulo'],
                                      descripcion: itemsFiltrados[index]
                                          ['descripcion'],
                                      itemId: itemsFiltrados[index]['notaId'],
                                      deleteItem: deleteDataNote,
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
                if (notas.isEmpty && !isLoading) const ListaVacia(),
                if (itemsFiltrados.isEmpty && !isLoading && buscando)
                  const NoFound(),
              ],
            ),
            //SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ],
        ),
      ),
    );
  }

  void filtrarItems(String query) {
    setState(() {
      searchTerm = query.toLowerCase(); // Convertir a minúsculas

      if (searchTerm.isEmpty) {
        buscando = false;
        itemsFiltrados = notas;
      } else {
        buscando = true;
        itemsFiltrados = notas.where((item) {
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
