import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/auth.dart';
import '../styles/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? email = '';
  String userId = '';
  String dataUser = '';
  String nombre = '';
  String apellido = '';
  String telefono = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      email = user.email;
    }

    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      setState(() {
        nombre = userData['nombre'] ?? '';
        apellido = userData['apellido'] ?? '';
        email = email;
        telefono = userData['telefono'] ?? '';
      });
    } else {
      const CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Perfil de Usuario',
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: azulClaro),
              ),
              const SizedBox(height: 56),
              const Text('Nombres',
                  style: TextStyle(fontSize: 18, color: azulClaro)),
              const SizedBox(height: 8),
              Card(
                elevation: 13,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: azulClaro,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  width: 400,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      ' $nombre',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Apellidos',
                  style: TextStyle(fontSize: 18, color: azulClaro)),
              const SizedBox(height: 8),
              Card(
                elevation: 13,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: azulClaro,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  width: 400,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      ' $apellido',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Telefono',
                  style: TextStyle(fontSize: 18, color: azulClaro)),
              const SizedBox(height: 8),
              Card(
                elevation: 13,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: azulClaro,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  width: 400,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      ' $telefono',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Correo Electronico',
                  style: TextStyle(fontSize: 18, color: azulClaro)),
              const SizedBox(height: 8),
              Card(
                elevation: 13,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: azulClaro,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  width: 400,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      ' $email',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 56),
              ElevatedButton(
                  style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(400, 50)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(azulClaro),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    logout(context);
                  },
                  child: const Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ))
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          fixedColor: azulClaro,
          elevation: 6,
          backgroundColor: azulClaro,
          currentIndex: 2,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushNamed(context, '/home');
            } else if (index == 1) {
              Navigator.pushNamed(context, '/tareas');
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notas'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ]),
    );
  }
}
