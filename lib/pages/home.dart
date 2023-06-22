import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../styles/colors.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: const BoxDecoration(),
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 46, top: 0),
                        margin: const EdgeInsets.only(
                          top: 0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 16),
                            Text(
                              'Hola, $nombre',
                              style: TextStyle(
                                  fontSize: 38,
                                  color: azulClaro,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            const SizedBox(
                              width: 300,
                              child: Text(
                                'Bienvenido a tu aplicación de gestión de tareas',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: azulClaro,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 66),
                            InkWell(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/tareas'),
                              child: Card(
                                elevation: 15,
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: azulClaro),
                                  width: 300,
                                  height: 200,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.note,
                                          color: azulClaro, size: 130),
                                      SizedBox(width: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 26),
                            InkWell(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/profile'),
                              child: Card(
                                elevation: 15,
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: azulClaro),
                                  width: 300,
                                  height: 200,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person,
                                          color: azulClaro, size: 130),
                                      SizedBox(width: 20),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
              fixedColor: azulClaro,
              elevation: 6,
              backgroundColor: azulClaro,
              currentIndex: 0,
              onTap: (index) {
                if (index == 1) {
                  Navigator.pushNamed(context, '/tareas');
                } else if (index == 2) {
                  Navigator.pushNamed(context, '/profile');
                }
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Inicio'),
                BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notas'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Perfil'),
              ]),
        ),
      ),
    );
  }
}
