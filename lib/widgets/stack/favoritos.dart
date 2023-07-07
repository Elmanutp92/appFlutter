import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../styles/colors.dart';

class FavoritosHome extends StatelessWidget {
  final String nombre;
  const FavoritosHome({super.key, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      Text(
        'Hola, $nombre, este es un ejemplo tu lista FAVORITOS',
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
        child: const Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Soy uan de tus Tareas FAVORITAS'),
            Icon(Icons.star, color: Colors.yellow)
          ],
        )),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        color: amarilloGolden,
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Soy una de tus Notas FAVORITAS'),
            Icon(Icons.star, color: Colors.yellow)
          ],
        ),
      )
    ]));
  }
}
