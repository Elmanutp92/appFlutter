import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_note/widgets/foto_perfil.dart';

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
    return Container(
      //color: Colors.amber,
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FotoPerfil(nombre: nombre, apellido: apellido),
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
