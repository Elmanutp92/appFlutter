import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderHome extends StatelessWidget {
  final String nombre;
  final String apellido;
  const HeaderHome({super.key, required this.nombre, required this.apellido});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/profile'),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
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
          IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
