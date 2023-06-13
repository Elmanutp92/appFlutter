import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../styles/colors.dart';

class PageTareas extends StatefulWidget {
  const PageTareas({Key? key}) : super(key: key);

  @override
  State<PageTareas> createState() => _PageTareasState();
}

class _PageTareasState extends State<PageTareas> {
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

      // Verificar si la nota se eliminó correctamente
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection('notas')
          .doc(noteId)
          .get();

      if (!snapshot.exists) {
        // La nota se eliminó correctamente
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Éxito'),
            content: const Text('La nota se eliminó correctamente.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/tareas'),
                child: const Text('Ok'),
              ),
            ],
          ),
        );
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
        width: double.infinity,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorCuatro,
              colorCinco,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Bienvenido, $nombre. ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: colorUno,
                ),
              ),
              const SizedBox(height: 50),
              if (notas.isNotEmpty)
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 400,
                    ),
                    child: ListView.builder(
                      itemCount: notas.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorUno,
                                colorCinco,
                                colorUno,
                                colorCinco,
                                colorUno,
                                colorUno,
                                colorCinco,
                                colorUno,
                                colorCinco,
                                colorUno,
                              ],
                            ),
                          ),
                          margin: const EdgeInsets.only(bottom: 20),
                          height: 100,
                          child: Card(
                            elevation: 15,
                            color: colorTres,
                            child: ListTile(
                              trailing: IconButton(
                                onPressed: () {
                                  deleteDataNote(notas[index]['notaId']);
                                },
                                icon: const Icon(Icons.delete),
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
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              if (notas.isEmpty)
                Column(
                  children: [
                    const Text('Actualmente No tienes notas',
                        style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 20),
                    Icon(Icons.error, size: 100, color: colorTres)
                  ],
                ),
              const SizedBox(height: 5),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(200, 50)),
                  backgroundColor: MaterialStateProperty.all(colorUno),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/createNote');
                },
                child: const Text(
                  'Crear Nota',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: colorCuatro,
        elevation: 6,
        backgroundColor: colorUno,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
