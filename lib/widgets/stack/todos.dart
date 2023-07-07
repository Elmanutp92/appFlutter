import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../styles/colors.dart';

class TodosHome extends StatelessWidget {
  final String nombre;
  const TodosHome({super.key, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Hola, $nombre, este es un ejemplo tu lista TODOS',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.width * 0.035,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: rosaClaro,
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(
              child: const Text('Soy una Tarea'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: amarilloGolden,
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(
              child: const Text('Soy una Nota'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: rosaClaro,
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(
              child: const Text('Soy una Tarea'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: amarilloGolden,
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(
              child: const Text('Soy una Nota'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: rosaClaro,
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(
              child: const Text('Soy una Tarea'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: amarilloGolden,
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(
              child: const Text('Soy una Nota'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: rosaClaro,
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(
              child: const Text('Soy una Tarea'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: amarilloGolden,
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Center(
              child: const Text('Soy una Nota'),
            ),
          ),
        ],
      ),
    );
  }
}
