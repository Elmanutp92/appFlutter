import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/colors.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool todos = true;
  bool favoritos = false;
  bool tareas = false;

  String? email;
  String userId = '';
  String nombre = '';
  String apellido = '';
  String telefono = '';

  Future<void> fetchData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
        email = user.email;
      });

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          nombre = userData['nombre'] ?? '';
          apellido = userData['apellido'] ?? '';
          telefono = userData['telefono'] ?? '';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        child: Scaffold(
          endDrawer: Drawer(
            backgroundColor: amarilloGolden,
            // Agrega el contenido del drawer aquí
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: amarilloGolden,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Menu',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                          ),
                        ),
                        EndDrawerButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ]),
                ),
                ListTile(
                  trailing: Icon(Icons.home),
                  title: Text(
                    'Pagina de Inicio',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  onTap: () {
                    // Acción para el item 1
                  },
                ),
                const Divider(),
                ListTile(
                  trailing: Icon(Icons.star),
                  title: Text(
                    'Favoritos',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  onTap: () {
                    // Acción para el item 2
                  },
                ),
                const Divider(),
                ListTile(
                  trailing: Icon(Icons.note),
                  title: Text(
                    'Notas',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  onTap: () {
                    // Acción para el item 2
                  },
                ),
                const Divider(),
                ListTile(
                  trailing: Icon(Icons.assignment),
                  title: Text(
                    'Tareas',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  onTap: () {
                    // Acción para el item 2
                  },
                ),
                const Divider(),
                ListTile(
                  trailing: Icon(Icons.delete),
                  title: Text(
                    'Papelera',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  onTap: () {
                    // Acción para el item 2
                  },
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Builder(builder: (context) {
              return Container(
                margin: EdgeInsets.only(top: 30),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: azulBackground),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    Navigator.pushNamed(context, '/profile'),
                                child: const CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                ' ${nombre != null && nombre.isNotEmpty ? 'Hola, ' + nombre : "Cargando..."}',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                            icon: Icon(
                              Icons.menu,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: negro,
                          ),
                          filled: true,
                          fillColor: blanco,
                          labelStyle: TextStyle(color: negro),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: negro),
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
                      height: 6,
                    ),
                    Container(
                      child: Text(
                        'Let\'s Note',
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(color: Colors.white),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(azulClaro),
                            overlayColor: MaterialStateProperty.all<Color>(
                              Colors.white.withOpacity(0.1),
                            ),
                          ),
                          onPressed: () {
                            // Acción del botón
                          },
                          child: const Text(
                            'Todos',
                            style: TextStyle(color: negro),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(color: Colors.white),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(azulNavy),
                            overlayColor: MaterialStateProperty.all<Color>(
                              Colors.white.withOpacity(0.1),
                            ),
                          ),
                          onPressed: () {
                            // Acción del botón
                          },
                          child: const Text(
                            'Favoritos',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(color: Colors.white),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(rosaClaro),
                            overlayColor: MaterialStateProperty.all<Color>(
                              Colors.white.withOpacity(0.1),
                            ),
                          ),
                          onPressed: () {
                            // Acción del botón
                          },
                          child: const Text(
                            'Tareas',
                            style: TextStyle(color: negro),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(color: Colors.white),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                amarilloGolden),
                            overlayColor: MaterialStateProperty.all<Color>(
                              Colors.white.withOpacity(0.1),
                            ),
                          ),
                          onPressed: () {
                            // Acción del botón
                          },
                          child: const Text(
                            'Notas',
                            style: TextStyle(color: negro),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
