import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_note/widgets/foto_circular.dart';
import 'package:lets_note/widgets/foto_circular_profile.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: azulNavy,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Perfil'),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                icon: const Icon(Icons.home)),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: azulBackgroundGradient,
          //color: azulBackground,
        ),
        child: Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.05,
          ),
          child: Center(
            child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.29,
                    child: Column(
                      children: [
                        Container(
                            //color: Colors.red,
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.28,
                            child: FotoCircularProfile(
                                nombre: nombre, apellido: apellido)),
                      ],
                    )),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 6,
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: azulNavy,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        width: MediaQuery.of(context).size.width * 0.79,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.025),
                          child: Text(
                            nombre.isNotEmpty ? nombre : 'Cargando...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Card(
                      elevation: 6,
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: azulNavy,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        width: MediaQuery.of(context).size.width * 0.79,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.025),
                          child: Text(
                            apellido.isNotEmpty ? apellido : 'Cargando...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Card(
                      elevation: 6,
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: azulNavy,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        width: MediaQuery.of(context).size.width * 0.79,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.025),
                          child: Text(
                            telefono.isNotEmpty ? telefono : 'Cargando...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Card(
                      elevation: 6,
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: azulNavy,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        width: MediaQuery.of(context).size.width * 0.79,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.025),
                          child: Text(
                            email!.isNotEmpty ? email! : 'Cargando...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                    ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(Size(
                              MediaQuery.of(context).size.width * 0.79,
                              MediaQuery.of(context).size.height * 0.04)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
