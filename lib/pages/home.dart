import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/widgets/buscar.dart';
import 'package:new_app/widgets/header_home.dart';
import 'package:new_app/widgets/stack/favoritos.dart';
import 'package:new_app/widgets/stack/info_app.dart';
import 'package:new_app/widgets/stack/notas.dart';
import 'package:new_app/widgets/stack/tareas.dart';

import '../styles/colors.dart';
import '../widgets/listtile_drawer.dart';
import '../widgets/stack/todos.dart';
import '../widgets/switch_buttons.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

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
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Scaffold(
          endDrawer: const Drawer(
            backgroundColor: amarilloGolden,
            // Agrega el contenido del drawer aquí
            child: ListTileDrawer(),
          ),
          body: Builder(builder: (context) {
            return Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: azulBackground),
              child: Column(
                children: [
                  HeaderHome(
                    nombre: nombre,
                    apellido: apellido,
                  ),
                  const SearchHome(),
                  const SizedBox(
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
                  const SizedBox(height: 20),
                  SwitchButtons(
                    todos: todos,
                    favoritos: favoritos,
                    tareas: tareas,
                    notas: notas,
                    cambiarFavoritos: cambiarFavoritos,
                    cambiarNotas: cambiarNotas,
                    cambiarTareas: cambiarTareas,
                    cambiarTodos: cambiarTodos,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.56,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Stack(
                      children: [
                        // Lista se Todos
                        if (todos)
                          TodosHome(
                            nombre: nombre,
                          ),
                        if (tareas) TareasHome(nombre: nombre),
                        if (favoritos) FavoritosHome(nombre: nombre),
                        if (notas) NotasHome(nombre: nombre),
                        if (!notas && !favoritos && !tareas && !todos)
                          const InfoApp(),
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

  void cambiarTodos() {
    setState(() {
      !todos ? todos = true : todos = false;
      favoritos = false;
      tareas = false;
      notas = false;
    });
  }

  void cambiarTareas() {
    setState(() {
      todos = false;
      favoritos = false;
      !tareas ? tareas = true : tareas = false;
      notas = false;
    });
  }

  void cambiarNotas() {
    setState(() {
      todos = false;
      favoritos = false;
      tareas = false;
      !notas ? notas = true : notas = false;
    });
  }

  void cambiarFavoritos() {
    setState(() {
      todos = false;
      !favoritos ? favoritos = true : favoritos = false;
      tareas = false;
      notas = false;
    });
  }
}
