import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/colors.dart';

class HeaderHome extends StatelessWidget {
  final VoidCallback cambiarPerfil;
  final bool perfil;
  final String nombre;
  final String apellido;
  const HeaderHome(
      {super.key,
      required this.nombre,
      required this.apellido,
      required this.cambiarPerfil,
      required this.perfil});

  @override
  Widget build(BuildContext context) {
    Color getRandomColor() {
      Random random = Random();
      return Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1.0,
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Text(
                    (nombre.isNotEmpty ? nombre[0].toUpperCase() : '?') +
                        (apellido.isNotEmpty ? apellido[0].toUpperCase() : '?'),
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.normal,
                    )),
              ),
              const SizedBox(width: 20),
              Text(
                ' ${nombre.isNotEmpty ? 'Hola, $nombre' : "Cargando..."}',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          ElevatedButton(
              style: ButtonStyle(
                elevation: perfil
                    ? MaterialStateProperty.all<double>(0)
                    : MaterialStateProperty.all<double>(15),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(azulNavy),
                overlayColor: MaterialStateProperty.all<Color>(
                  Colors.white.withOpacity(0.1),
                ),
              ),
              onPressed: cambiarPerfil,
              child: const Icon(Icons.person_2)),
        ],
      ),
    );
  }
}
