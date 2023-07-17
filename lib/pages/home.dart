import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_note/pages/page_tareas.dart';
import 'package:lets_note/pages/page_notas.dart';
import 'package:lets_note/pages/page_todos.dart';
import 'package:lets_note/pages/page_todos_fav.dart';
import 'package:lets_note/pages/profile.dart';

import '../styles/colors.dart';
import '../widgets/buscar.dart';
import '../widgets/header_home.dart';

import '../widgets/stack/info_app.dart';
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
  bool isButtonEnabled = true;
  bool todos = true;
  bool perfil = false;
  bool tareas = false;
  bool notas = false;
  bool favoritos = false;

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
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Builder(builder: (context) {
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: azulBackground),
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05),
                  child: Column(
                    children: [
                      HeaderHome(
                        perfil: perfil,
                        cambiarPerfil: cambiarPerfil,
                        nombre: nombre,
                        apellido: apellido,
                      ),
                      //const SearchHome(),

                      Container(
                        // color: Colors.red,
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.06,
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

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      SwitchButtons(
                        isButtonEnabled: isButtonEnabled,
                        todos: todos,
                        favoritos: favoritos,
                        tareas: tareas,
                        notas: notas,
                        cambiarNotas: cambiarNotas,
                        cambiarTareas: cambiarTareas,
                        cambiarTodos: cambiarTodos,
                        cambiarFavoritos: cambiarFavoritos,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        //color: Colors.amber,
                        height: MediaQuery.of(context).size.height * 0.6858,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            // Lista se Todos
                            if (favoritos) const PageTodosFav(),
                            if (tareas) const PageTareaPink(),
                            if (perfil) const ProfilePage(),
                            if (notas) const PageTareas(),
                            if (todos) const PageTodos(),

                            // NotasHome(nombre: nombre),
                            if (!notas &&
                                !perfil &&
                                !tareas &&
                                !todos &&
                                !favoritos)
                              const InfoApp(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void cambiarTodos() {
    if (mounted) {
      setState(() {
        isButtonEnabled = false;
        todos = !todos;
        perfil = false;
        tareas = false;
        notas = false;
        favoritos = false;
        isButtonEnabledState();
      });
    }
  }

//***      */
  void cambiarTareas() {
    if (mounted) {
      setState(() {
        isButtonEnabled = false;
        todos = false;
        perfil = false;
        tareas = !tareas;
        notas = false;
        favoritos = false;
        isButtonEnabledState();
      });
    }
  }

//***      */
  void cambiarNotas() {
    if (mounted) {
      setState(() {
        isButtonEnabled = false;
        todos = false;
        perfil = false;
        tareas = false;
        notas = !notas;
        favoritos = false;
        isButtonEnabledState();
      });
    }
  }
//***      */

  void cambiarPerfil() {
    if (mounted) {
      setState(() {
        isButtonEnabled = false;

        todos = false;
        perfil = !perfil;
        tareas = false;
        notas = false;
        favoritos = false;
        isButtonEnabledState();
      });
    }
  }

  //***      */
  void cambiarFavoritos() {
    if (mounted) {
      setState(() {
        isButtonEnabled = false;

        todos = false;
        perfil = false;
        tareas = false;
        notas = false;
        favoritos = !favoritos;
        isButtonEnabledState();
      });
    }
  }

  void isButtonEnabledState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isButtonEnabled = true;
        });
      }
    });
  }
}
