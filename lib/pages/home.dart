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
  bool notas = false;

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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
          body: Builder(builder: (context) {
            return Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: azulBackground),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.95,
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
                              ' ${nombre.isNotEmpty ? 'Hola, ' + nombre : "Cargando..."}',
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
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'Let\'s Note',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize:
                              5, // Utiliza un valor relativo como referencia
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          elevation: todos
                              ? MaterialStateProperty.all<double>(0)
                              : MaterialStateProperty.all<double>(15),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                          setState(() {
                            !todos ? todos = true : todos = false;
                            favoritos = false;
                            tareas = false;
                            notas = false;
                          });
                          // Acción del botón
                        },
                        child: const Text(
                          'Todos',
                          style: TextStyle(color: negro),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          elevation: favoritos
                              ? MaterialStateProperty.all<double>(0)
                              : MaterialStateProperty.all<double>(15),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                          setState(() {
                            todos = false;
                            !favoritos ? favoritos = true : favoritos = false;
                            tareas = false;
                            notas = false;
                          });
                          // Acción del botón
                        },
                        child: const Text(
                          'Favoritos',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          elevation: tareas
                              ? MaterialStateProperty.all<double>(0)
                              : MaterialStateProperty.all<double>(15),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                          setState(() {
                            todos = false;
                            favoritos = false;
                            !tareas ? tareas = true : tareas = false;
                            notas = false;
                          });
                          // Acción del botón
                        },
                        child: const Text(
                          'Tareas',
                          style: TextStyle(color: negro),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          elevation: notas
                              ? MaterialStateProperty.all<double>(0)
                              : MaterialStateProperty.all<double>(15),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: const BorderSide(color: Colors.white),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(amarilloGolden),
                          overlayColor: MaterialStateProperty.all<Color>(
                            Colors.white.withOpacity(0.1),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            todos = false;
                            favoritos = false;
                            tareas = false;
                            !notas ? notas = true : notas = false;
                          });
                          // Acción del botón
                        },
                        child: const Text(
                          'Notas',
                          style: TextStyle(color: negro),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.56,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Stack(
                      children: [
                        // Lista se Todos
                        if (todos)
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  'Hola, $nombre, este es un ejemplo tu lista TODOS',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  color: rosaClaro,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: const Text('Soy una Tarea'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: amarilloGolden,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: const Text('Soy una Nota'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: rosaClaro,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: const Text('Soy una Tarea'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: amarilloGolden,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: const Text('Soy una Nota'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: rosaClaro,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: const Text('Soy una Tarea'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: amarilloGolden,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: const Text('Soy una Nota'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: rosaClaro,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: const Text('Soy una Tarea'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: amarilloGolden,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: const Text('Soy una Nota'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (tareas)
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  'Hola, $nombre, este es un ejemplo tu lista TAREAS',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  color: rosaClaro,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: const Text('Soy una Tarea'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: rosaClaro,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: const Text('Soy una Tarea'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: rosaClaro,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: const Text('Soy una Tarea'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: rosaClaro,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: const Text('Soy una Tarea'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        if (favoritos)
                          SingleChildScrollView(
                              child: Column(children: [
                            Text(
                              'Hola, $nombre, este es un ejemplo tu lista FAVORITOS',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: rosaClaro,
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: const Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Soy uan de tus Tareas FAVORITAS'),
                                  Icon(Icons.star, color: Colors.yellow)
                                ],
                              )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              color: amarilloGolden,
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Soy una de tus Notas FAVORITAS'),
                                  Icon(Icons.star, color: Colors.yellow)
                                ],
                              ),
                            )
                          ])),
                        if (notas)
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  'Hola, $nombre, este es un ejemplo tu lista NOTAS',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  color: amarilloGolden,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: const Text('Soy una Nota'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: amarilloGolden,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: const Text('Soy una Nota'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: amarilloGolden,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: const Text('Soy una Nota'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: amarilloGolden,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Center(
                                    child: const Text('Soy una Nota'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        if (!notas && !favoritos && !tareas && !todos)
                          Center(
                              child: Container(
                            child: Column(
                              children: [
                                const Text('Informacion sobre la app'),
                                SizedBox(height: 50),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: Card(
                                    child: Column(
                                      children: [
                                        const Text('Diseño UI/UX'),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'Dina Ruiz',
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 50),
                                            ),
                                            SizedBox(width: 30),
                                            Icon(Icons.art_track,
                                                color: rosaClaro, size: 50),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: Card(
                                    child: Column(
                                      children: [
                                        const Text('Desarrollo Flutter/Dart'),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'Manuel Teran',
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 50),
                                            ),
                                            SizedBox(width: 30),
                                            Icon(Icons.code,
                                                color: Colors.red, size: 50),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Text(
                                    'Made with ❤️ by Dina Ruiz & Manuel Teran')
                              ],
                            ),
                          ))
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
