import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../styles/colors.dart';

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  bool isLoading = false;
  bool containsOnlyNumbers(String value) {
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? userEmail;
  String? userId;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      userEmail = user.email;
    } else {
      userEmail = 'No hay usuario logueado';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    apellidoController.dispose();
    telefonoController.dispose();
    super.dispose();
  }

  Future<void> addData(String name, String apellido, String? telefono) async {
    setState(() {
      isLoading = true;
    });
    final dataUser = {
      'nombre': name,
      'apellido': apellido,
      'telefono': telefono,
    };

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .set(dataUser);

      // Verificar si los datos se agregaron correctamente
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      if (snapshot.exists) {
        setState(() {
          isLoading = false;
        });
        // Los datos se agregaron correctamente
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Éxito'),
            content: Text('Los datos se agregaron correctamente.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: Text('Ok'),
              ),
            ],
          ),
        );
      } else {
        // Los datos no se agregaron correctamente
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('No se pudieron agregar los datos.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Ha ocurrido un error al registrar los datos: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok'),
            ),
          ],
        ),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Stack(children: [
          Container(
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
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Queremos conocerte un poco más',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: colorUno),
                ),
                SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese sus nombres';
                          }
                          return null;
                        },
                        controller: nameController,
                        style: TextStyle(color: colorUno),
                        cursorColor: colorUno,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: colorUno),
                          labelStyle: TextStyle(color: colorUno),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: colorUno),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: colorCinco),
                          ),
                          labelText: 'Nombres',
                          hintText: 'Ingresa tu nombre completo',
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese sus apellidos ';
                          }
                          return null;
                        },
                        controller: apellidoController,
                        style: TextStyle(color: colorUno),
                        cursorColor: colorUno,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: colorUno),
                          labelStyle: TextStyle(color: colorUno),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: colorUno),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: colorCinco),
                          ),
                          labelText: 'Apellidos',
                          hintText: 'Ingresa sus apellidos completos',
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese un número de teléfono';
                          }
                          if (value.length != 10) {
                            return 'Ingrese un número de teléfono válido';
                          }
                          if (!containsOnlyNumbers(value)) {
                            return 'Ingrese un número de teléfono válido';
                          }
                          return null;
                        },
                        controller: telefonoController,
                        style: TextStyle(color: colorUno),
                        cursorColor: colorUno,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: colorUno),
                          labelStyle: TextStyle(color: colorUno),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: colorUno),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: colorCinco),
                          ),
                          labelText: 'Telefono',
                          hintText: 'Ingresa tu telefono',
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                            const Size(double.infinity, 50),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(colorUno),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            addData(
                              nameController.text,
                              apellidoController.text,
                              telefonoController.text,
                            );
                          }
                        },
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Guardando datos...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 30),
                    SpinKitCircle(
                      color: Colors.white,
                      size: 50.0,
                    ),
                  ],
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
