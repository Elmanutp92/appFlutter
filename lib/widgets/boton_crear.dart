import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pages/create_note.dart';
import '../pages/create_tarea.dart';
import '../styles/colors.dart';

class BotonCrear extends StatelessWidget {
  const BotonCrear({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(100),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: azulClaro.withOpacity(0.6),
        ),
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.06,
        child: FloatingActionButton(
          backgroundColor: azulNavy,
          elevation: 0,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: azulClaro
                        .withOpacity(0.5), // Ajusta el valor de opacidad aquí
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            minimumSize: MaterialStateProperty.all<Size>(
                              Size(
                                MediaQuery.of(context).size.width * 0.25,
                                MediaQuery.of(context).size.height * 0.05,
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(rosaClaro),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreateTarea(),
                              ),
                            );
                          },
                          child: Text(
                            'Tarea',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                            ),
                          )),
                      ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            minimumSize: MaterialStateProperty.all<Size>(
                              Size(
                                MediaQuery.of(context).size.width * 0.25,
                                MediaQuery.of(context).size.height * 0.05,
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                amarilloGolden),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreateNote(),
                              ),
                            );
                          },
                          child: Text(
                            'Nota',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
