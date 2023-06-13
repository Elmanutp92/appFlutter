import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../styles/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool obscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  //  ingresas
  login(emailAddress, password, context) async {
    isLoading = true;
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      setState(() {
        isLoading = false;
      });
      if (credential.user != null) {
        Navigator.pushNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Usuario no encontrado'),
                  content: Text('El usuario no se encuentra registrado.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Ok'))
                  ],
                ));
      } else if (e.code == 'wrong-password') {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Contraseña incorrecta'),
                  content: Text('La contraseña es incorrecta.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Ok'))
                  ],
                ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
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
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: colorUno),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu correo';
                              } else if (!value.contains('@')) {
                                return 'Por favor ingresa un correo valido';
                              }
                              return null;
                            },
                            controller: emailController,
                            style: TextStyle(color: colorUno),
                            cursorColor: colorUno,
                            decoration: const InputDecoration(
                              labelStyle: TextStyle(color: colorUno),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorUno),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorCinco),
                              ),
                              labelText: 'Correo',
                              hintText: 'Ingresa tu correo',
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu contraseña';
                              } else if (value.length < 6) {
                                return 'Por favor ingresa una contraseña de al menos 6 caracteres';
                              }
                              return null;
                            },
                            controller: passwordController,
                            style: TextStyle(color: colorUno),
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
                              labelText: 'Contraseña',
                              hintText: 'Ingresa tu contraseña',
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(double.infinity, 50)),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(colorUno),
                            ),
                            child: const Text('Entrar',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                login(
                                  emailController.text,
                                  passwordController.text,
                                  context,
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/');
                              },
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(color: colorUno, fontSize: 20),
                              ))
                        ],
                      ))
                ],
              )),
          isLoading
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Ingresando...',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        SpinKitCircle(
                          color: Colors.white,
                          size: 50.0,
                        ),
                      ],
                    ),
                  ),
                )
              : Container()
        ]),
      ),
    );
  }
}
