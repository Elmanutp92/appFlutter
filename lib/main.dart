import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_app/firebase_options.dart';
import 'package:new_app/pages/create_note.dart';
import 'package:new_app/pages/data_page.dart';
import 'package:new_app/pages/home.dart';
import 'package:new_app/pages/login.dart';
import 'package:new_app/pages/page_tareas.dart';
import 'package:new_app/pages/profile.dart';
import 'package:new_app/pages/register_page.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
    initialRoute: '/',
    routes: {
      '/login': (context) => const LoginPage(),
      '/home': (context) => const Home(),
      '/register': (context) => const RegisterPage(),
      '/datapage': (context) => const DataPage(),
      '/profile': (context) => const ProfilePage(),
      '/tareas': (context) => const PageTareas(),
      '/createNote': (context) => const CreateNote(),
    },
  ));
}
