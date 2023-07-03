import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

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
    setState(() {
      isLoading = true;
    });
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      setState(() {});
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
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(children: [
            if (!isLoading)
              Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: azulBackground),
                  child: SingleChildScrollView(
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
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.5),
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    color: rosaClaroDegrade,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.5),
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
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
                                  left:
                                      MediaQuery.of(context).size.width * 0.18),
                              child: Image.asset(
                                'assets/letsLogo.png',
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Text(
                          '¡Ingresa!',
                          style: GoogleFonts.poppins(
                              fontSize: MediaQuery.of(context).size.width * 0.1,
                              fontWeight: FontWeight.bold,
                              color: negro),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingresa tu correo';
                                      } else if (!value.contains('@')) {
                                        return 'Por favor ingresa un correo valido';
                                      }
                                      return null;
                                    },
                                    controller: emailController,
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
                                        labelText: 'Correo electrónico',
                                        hintText:
                                            'Ingresa tu Correo electrónico',
                                        border: InputBorder.none),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor ingresa tu contraseña';
                                      }
                                      return null;
                                    },
                                    obscureText: obscureText,
                                    controller: passwordController,
                                    style: TextStyle(color: negro),
                                    cursorColor: negro,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          color: negro,
                                          icon: Icon(obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              obscureText = !obscureText;
                                            });
                                          },
                                        ),
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
                                        labelText: 'Correo electrónico',
                                        hintText:
                                            'Ingresa tu Correo electrónico',
                                        border: InputBorder.none),
                                  ),
                                ),
                                const SizedBox(
                                  height: 60,
                                ),
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
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                      Size(
                                          MediaQuery.of(context).size.width *
                                              0.8,
                                          MediaQuery.of(context).size.height *
                                              0.09),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      login(
                                        emailController.text,
                                        passwordController.text,
                                        context,
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Continuar',
                                    style: GoogleFonts.poppins(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        fontWeight: FontWeight.w500,
                                        color: negro),
                                  ),
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
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 20),
                                    ))
                              ],
                            ))
                      ],
                    ),
                  )),
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
    );
  }
}
