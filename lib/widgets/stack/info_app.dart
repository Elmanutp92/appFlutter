import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../styles/colors.dart';

class InfoApp extends StatelessWidget {
  const InfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: Column(
        children: [
          const Text('Informacion sobre la app'),
          SizedBox(height: 50),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Card(
              child: Column(
                children: [
                  const Text('Diseño UI/UX'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Dina Ruiz',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400, fontSize: 50),
                      ),
                      SizedBox(width: 30),
                      Icon(Icons.art_track, color: rosaClaro, size: 50),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Card(
              child: Column(
                children: [
                  const Text('Desarrollo Flutter/Dart'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Manuel Teran',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400, fontSize: 50),
                      ),
                      SizedBox(width: 30),
                      Icon(Icons.code, color: Colors.red, size: 50),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Text('Made with ❤️ by Dina Ruiz & Manuel Teran')
        ],
      ),
    ));
  }
}
