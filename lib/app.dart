import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/styles/colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: Scaffold(
            body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: azulBackground),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.5),
                                width: MediaQuery.of(context).size.width * 0.5,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                color: rosaClaroDegrade,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.5),
                                width: MediaQuery.of(context).size.width * 0.5,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                color: amarillogoldenDegrade,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.6,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.1,
                              left: MediaQuery.of(context).size.width * 0.05),
                          child: Image.asset(
                            'assets/letsLogo.png',
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: AutoSizeText(
                        '¿Tienes cosas por recordar?',

                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: MediaQuery.of(context).size.width * 0.07,
                        ),
                        maxLines: 1, // Limita el texto a una línea
                        stepGranularity:
                            0.1, // Ajusta la precisión del escalado
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: AutoSizeText(
                        'Podrás organizar, planear y hacer anotaciones rápidas',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width * 0.07,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          amarilloGolden,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(MediaQuery.of(context).size.width * 0.8,
                              MediaQuery.of(context).size.height * 0.09),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'Let\'s Note',
                        style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width * 0.1,
                            fontWeight: FontWeight.bold,
                            color: negro),
                      ),
                    ),
                  ]),
            ),
          ),
        )),
      ),
    );
  }
}
