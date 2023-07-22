import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FotoCircular extends StatefulWidget {
  final String foto;
  final String nombre;
  final String apellido;
  final Function? onPressed;

  const FotoCircular({
    super.key,
    required this.nombre,
    required this.apellido,
    this.onPressed,
    required this.foto,
  });

  @override
  State<FotoCircular> createState() => _FotoCircularState();
}

class _FotoCircularState extends State<FotoCircular> {
  String userId = '';

  bool isLoading = false;
  File? imagenPerfil;
  String? perfilFoto;
  String? profilePhoto;
  bool? status = false;
  String imageUrl = '';
  String fotoFinal = '';

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  //*********** */

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors
                            .transparent, // Ajusta el valor de opacidad aquí
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: CircleAvatar(
                          radius: 30,
                          backgroundColor: widget.foto.isEmpty
                              ? Colors.grey
                              : Colors.transparent,
                          child: widget.foto.isEmpty
                              ? Text(
                                  (widget.nombre.isNotEmpty
                                          ? widget.nombre[0].toUpperCase()
                                          : '?') +
                                      (widget.apellido.isNotEmpty
                                          ? widget.apellido[0].toUpperCase()
                                          : '?'),
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    fontWeight: FontWeight.normal,
                                  ))
                              : ClipOval(
                                  child: Image.network(widget.foto,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      fit: BoxFit.cover),
                                )))));
        },
        child: CircleAvatar(
            radius: 30,
            backgroundColor:
                widget.foto.isEmpty ? Colors.grey : Colors.transparent,
            child: widget.foto.isEmpty
                ? Text(
                    (widget.nombre.isNotEmpty
                            ? widget.nombre[0].toUpperCase()
                            : '?') +
                        (widget.apellido.isNotEmpty
                            ? widget.apellido[0].toUpperCase()
                            : '?'),
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.normal,
                    ))
                : ClipOval(
                    child: Image.network(widget.foto,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        fit: BoxFit.cover),
                  )));
  }
}
