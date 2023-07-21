import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lets_note/widgets/card_action/gesture_card_detector.dart';

import '../styles/colors.dart';
import '../widgets/buscar.dart';
import '../widgets/lista_vacia.dart';
import '../widgets/no_found.dart';

class PageTareaPink extends StatefulWidget {
  const PageTareaPink({
    Key? key,
  }) : super(key: key);

  @override
  State<PageTareaPink> createState() => _PageTareaPinkState();
}

class _PageTareaPinkState extends State<PageTareaPink> {
  bool isLoading = true;
  String nombre = '';
  String userId = '';
  String tareaId = '';
  String searchTerm = '';
  bool buscando = false;
  List<Map<String, dynamic>> tareas = [];
  List<Map<String, dynamic>> itemsFiltrados = [];

  Future<void> deleteDataTarea(String tareaId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('tareas')
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
        Navigator.pushNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              '¡Tarea eliminada correctamente!',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
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
    setState(() {
      fetchData();
    });
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
    setState(() {
      isLoading = false;
      itemsFiltrados = tareas;
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: SingleChildScrollView(
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
                if (tareas.isNotEmpty && !isLoading)
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
                                      fecha:
                                          DateTime.fromMillisecondsSinceEpoch(
                                        itemsFiltrados[index]['fechaCreacion']
                                            .millisecondsSinceEpoch,
                                      ),
                                      isTodos: false,
                                      isFavorite: itemsFiltrados[index]
                                          ['isFavorite'],
                                      clase: itemsFiltrados[index]['clase'],
                                      tiulo: itemsFiltrados[index]['titulo'],
                                      descripcion: itemsFiltrados[index]
                                          ['descripcion'],
                                      itemId: itemsFiltrados[index]['tareaId'],
                                      deleteItem: deleteDataTarea,
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
                if (tareas.isEmpty && !isLoading) const ListaVacia(),
                if (itemsFiltrados.isEmpty && !isLoading && buscando)
                  const NoFound(),
              ],
            ),
            //SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
        itemsFiltrados = tareas;
      } else {
        buscando = true;
        itemsFiltrados = tareas.where((item) {
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
