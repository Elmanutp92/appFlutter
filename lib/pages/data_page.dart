import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

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
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              if (!isLoading)
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: azulBackground),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  color: rosaClaroDegrade,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  color: amarillogoldenDegrade,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            //color: blanco,
                            width: MediaQuery.of(context).size.width * 0.65,
                            height: MediaQuery.of(context).size.height * 0.3,
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.2,
                                left: MediaQuery.of(context).size.width * 0.18),
                            child: Image.asset(
                              'assets/letsLogo.png',
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.99,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Text(
                          '¡Queremos conocerte!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: negro),
                        ),
                      ),
                      SizedBox(height: 50),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingrese sus nombres';
                                  }
                                  return null;
                                },
                                controller: nameController,
                                style: TextStyle(color: negro),
                                cursorColor: negro,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: blanco,
                                    labelStyle: TextStyle(color: negro),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: negro),
                                      borderRadius: BorderRadius.circular(
                                          20), // Redondear el borde cuando está enfocado
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(
                                          20), // Redondear el borde cuando está habilitado
                                    ),
                                    labelText: 'Nombre',
                                    hintText: 'Ingresa tu Nombre completo',
                                    border: InputBorder.none),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingrese sus apellidos ';
                                  }
                                  return null;
                                },
                                controller: apellidoController,
                                style: TextStyle(color: negro),
                                cursorColor: negro,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: blanco,
                                    labelStyle: TextStyle(color: negro),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: negro),
                                      borderRadius: BorderRadius.circular(
                                          20), // Redondear el borde cuando está enfocado
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(
                                          20), // Redondear el borde cuando está habilitado
                                    ),
                                    labelText: 'Apellido',
                                    hintText: 'Ingresa tus Apellidos',
                                    border: InputBorder.none),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
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
                                style: TextStyle(color: negro),
                                cursorColor: azulClaro,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: blanco,
                                    labelStyle: TextStyle(color: negro),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: negro),
                                      borderRadius: BorderRadius.circular(
                                          20), // Redondear el borde cuando está enfocado
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(
                                          20), // Redondear el borde cuando está habilitado
                                    ),
                                    labelText: 'Móvil/ Celular',
                                    hintText: 'Ingresa tu Móvil/ Celular',
                                    border: InputBorder.none),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.12),
                            ElevatedButton(
                              style: ButtonStyle(
                                elevation:
                                    MaterialStateProperty.all<double>(6.0),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  amarilloGolden,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all<Size>(
                                  Size(
                                      MediaQuery.of(context).size.width * 0.8,
                                      MediaQuery.of(context).size.height *
                                          0.09),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  addData(
                                    nameController.text,
                                    apellidoController.text,
                                    telefonoController.text,
                                  );
                                  setState(() {
                                    isLoading = true;
                                  });
                                }
                              },
                              child: Text(
                                'Continuar',
                                style: GoogleFonts.poppins(
                                    fontSize:
                                        MediaQuery.of(context).size.width * 0.1,
                                    fontWeight: FontWeight.w500,
                                    color: negro),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (isLoading)
                Container(
                  height: MediaQuery.of(context).size.height,
                  color: azulBackground, // Cambia el color de fondo aquí
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Procesando...',
                        style: TextStyle(
                          color: azulNavy,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SpinKitCircle(
                        color: azulNavy,
                        size: 50.0,
                      ),
                    ],
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }
}
