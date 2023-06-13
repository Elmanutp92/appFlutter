import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

register(emailAddress, password, context) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    if (credential.user != null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Registro exitoso'),
                content: Text('El usuario se ha registrado correctamente.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      child: Text('Ok'))
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
                      onPressed: () => Navigator.pop(context),
                      child: Text('Ok'))
                ],
              ));
    }
  } catch (e) {
    print(e);
  }
}

logout(context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushNamed(context, '/');
}
