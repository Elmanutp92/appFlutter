import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../styles/colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool obscureText = true;
  bool isLoading = false;

  bool containsUppercase(String value) {
    return RegExp(r'[A-Z]').hasMatch(value);
  }

  bool containsLowercase(String value) {
    return RegExp(r'[a-z]').hasMatch(value);
  }

  bool containsNumber(String value) {
    return RegExp(r'[0-9]').hasMatch(value);
  }

  bool containsSpecialCharacters(String value) {
    return RegExp(r'[^a-zA-Z0-9]').hasMatch(value);
  }

  String? userId = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
    }
  }

  // REGISTRO DE USUARIO
  register(emailAddress, password, context) async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      setState(() {
        isLoading = false;
      });
      if (credential.user != null) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Registro exitoso'),
                  content: Text('El usuario se ha registrado correctamente.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/datapage');
                        },
                        child: Text('Siguiente'))
                  ],
                ));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Contraseña debil'),
                  content:
                      Text('La contraseña debe tener al menos 6 caracteres.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Ok'))
                  ],
                ));
      } else if (e.code == 'email-already-in-use') {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Correo ya en uso'),
                  content: Text('El correo ya esta en uso.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Text('Ok'))
                  ],
                ));
      }
    } catch (e) {
      print(e);
    }
  }

// AGREGAR DATOS A LA BASE DE DATOS

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
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
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text(
                              '¡Registrate!',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: colorUno),
                            ),
                            const SizedBox(
                              height: 60,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa un correo';
                                }
                                final RegExp emailRegex = RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Ingresa un correo electrónico válido';
                                }
                                return null;
                              },
                              controller: emailController,
                              style: const TextStyle(color: colorUno),
                              cursorColor: colorUno,
                              decoration: const InputDecoration(
                                labelStyle: TextStyle(color: colorUno),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colorUno),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colorCinco),
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Correo',
                                hintText: 'Ingresa tu correo',
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa una contraseña';
                                }

                                // Validar longitud de 6 a 8 caracteres
                                if (value.length < 6 || value.length > 8) {
                                  return 'La contraseña debe tener entre 6 y 8 caracteres';
                                }

                                // Validar al menos una letra mayúscula
                                if (!containsUppercase(value)) {
                                  return 'La contraseña debe contener al menos una letra mayúscula';
                                }

                                // Validar al menos una letra minúscula
                                if (!containsLowercase(value)) {
                                  return 'La contraseña debe contener al menos una letra minúscula';
                                }

                                // Validar al menos un número
                                if (!containsNumber(value)) {
                                  return 'La contraseña debe contener al menos un número';
                                }

                                // Validar que no contenga caracteres especiales
                                if (containsSpecialCharacters(value)) {
                                  return 'La contraseña no debe contener caracteres especiales';
                                }

                                return null; // La validación pasó exitosamente
                              },
                              obscureText: obscureText,
                              controller: passwordController,
                              style: const TextStyle(color: colorUno),
                              cursorColor: colorUno,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  color: colorUno,
                                  icon: Icon(obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                ),
                                labelStyle: TextStyle(color: colorUno),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colorUno),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: colorCinco),
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Contraseña',
                                hintText: 'Ingresa tu contraseña',
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      const Size(double.infinity, 50)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          colorUno)),
                              child: const Text(
                                'Continuar',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await register(emailController.text,
                                      passwordController.text, context);
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/');
                                    },
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(
                                          color: colorUno, fontSize: 20),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    child: const Text(
                                      'Inicia sesión',
                                      style: TextStyle(
                                          color: colorUno, fontSize: 20),
                                    )),
                              ],
                            )
                          ],
                        ))
                  ],
                )),
            if (isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Procesando...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SpinKitCircle(
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
