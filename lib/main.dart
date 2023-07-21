import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lets_note/firebase_options.dart';
import 'package:lets_note/pages/create_note.dart';
import 'package:lets_note/pages/create_tarea.dart';
import 'package:lets_note/pages/data_page.dart';

import 'package:lets_note/pages/home.dart';
import 'package:lets_note/pages/login.dart';
import 'package:lets_note/pages/profile.dart';
import 'package:lets_note/pages/register_page.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const MyApp(),
    initialRoute: '/',
    routes: {
      '/login': (context) => const LoginPage(),
      '/home': (context) => const Home(),
      '/register': (context) => const RegisterPage(),
      '/datapage': (context) => const DataPage(),
      '/profile': (context) => const ProfilePage(),
      '/createNota': (context) => const CreateNote(),
      '/createTarea': (context) => const CreateTarea(),
    },
  ));
}
