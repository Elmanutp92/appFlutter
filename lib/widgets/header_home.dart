import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_note/widgets/foto_circular.dart';

import '../styles/colors.dart';

class HeaderHome extends StatelessWidget {
  final String foto;
  final VoidCallback cambiarPerfil;
  final bool perfil;
  final String nombre;
  final String apellido;
  const HeaderHome(
      {super.key,
      required this.nombre,
      required this.apellido,
      required this.cambiarPerfil,
      required this.perfil,
      required this.foto});

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
              FotoCircular(nombre: nombre, apellido: apellido, foto: foto),
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
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              icon: Icon(
                Icons.person,
                color: azulNavy,
                size: MediaQuery.of(context).size.width * 0.07,
              )),
        ],
      ),
    );
  }
}
