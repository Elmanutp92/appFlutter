import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/pages/page_tarea_pink.dart';

import 'package:new_app/pages/page_tareas.dart';
import 'package:new_app/pages/page_todos.dart';
import 'package:new_app/pages/profile.dart';

import 'package:new_app/widgets/buscar.dart';
import 'package:new_app/widgets/header_home.dart';
import 'package:new_app/widgets/stack/info_app.dart';

import '../styles/colors.dart';
import '../widgets/listtile_drawer.dart';

import '../widgets/switch_buttons.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool crearTarea = false;
  bool crearNota = false;
  // *******************************
  bool todos = false;
  bool perfil = false;
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
            return SingleChildScrollView(
              child: Container(
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
                      favoritos: perfil,
                      tareas: tareas,
                      notas: notas,
                      cambiarFavoritos: cambiarPerfil,
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
                    Container(
                      height: MediaQuery.of(context).size.height * 0.55,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Stack(
                        children: [
                          // Lista se Todos
                          if (todos) const PageTodos(),
                          if (tareas) const PageTareaPink(),
                          if (perfil) const ProfilePage(),
                          if (notas) const PageTareas(),

                          // NotasHome(nombre: nombre),
                          if (!notas &&
                              !perfil &&
                              !tareas &&
                              !todos &&
                              !crearNota)
                            const InfoApp(),
                        ],
                      ),
                    ),
                    /* Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02,
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Stack(
                        children: [
                          if (tareas)
                            ButtonHome(
                                btntxt: 'Crear Tarea',
                                color: rosaClaro,
                                onPressed: cambiarTareas),
                          if (notas)
                            ButtonHome(
                              btntxt: 'Crear Nota',
                              color: amarilloGolden,
                              onPressed: () {
                                setState(() {
                                  crearNota = true;
                                  crearTarea = false;
                                });
                              },
                            )
                        ],
                      ),
                    ),*/
                  ],
                ),
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
      perfil = false;
      tareas = false;
      notas = false;
    });
  }

  void cambiarTareas() {
    setState(() {
      crearNota = false;
      todos = false;
      perfil = false;
      !tareas ? tareas = true : tareas = false;
      notas = false;
    });
  }

  void cambiarNotas() {
    setState(() {
      crearTarea = false;
      todos = false;
      perfil = false;
      tareas = false;
      !notas ? notas = true : notas = false;
    });
  }

  void cambiarPerfil() {
    setState(() {
      todos = false;
      !perfil ? perfil = true : perfil = false;
      tareas = false;
      notas = false;
    });
  }

  void crearNotaSet() {
    setState(() {
      !crearNota ? crearNota = true : crearNota = false;
    });
  }

  void pageTareas() {
    setState(() {
      !notas ? notas = true : notas = false;
    });
  }
}
