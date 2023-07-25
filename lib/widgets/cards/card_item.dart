import 'dart:math';

import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lets_note/pages/edit_fav.dart';
import 'package:lets_note/pages/edit_tarea.dart';
import 'package:lets_note/styles/colors.dart';

import '../../pages/edit_nota.dart';

class CardItem extends StatefulWidget {
  final Function deleteItem;
  final String descripcion;
  final String titulo;
  final String itemId;
  final String clase;
  final bool isFavorite;
  final bool isTodos;
  final DateTime fechaCreacion;
  const CardItem({
    super.key,
    required this.deleteItem,
    required this.descripcion,
    required this.titulo,
    required this.itemId,
    required this.clase,
    required this.isFavorite,
    required this.isTodos,
    required this.fechaCreacion,
  });

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  // Reemplaza este valor con el alto de la pantalla

  @override
  Widget build(BuildContext context) {
    double dt = sqrt(pow(MediaQuery.of(context).size.width, 2) +
        pow(MediaQuery.of(context).size.height, 2));

    return Material(
      borderRadius:
          BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
      elevation: MediaQuery.of(context).size.width * 0.01,
      child: Stack(children: [
        if (!widget.isFavorite)
          Container(
            decoration: BoxDecoration(
              color: widget.clase == 'nota' && !widget.isFavorite
                  ? amarilloGolden
                  : widget.clase == 'tarea' && !widget.isFavorite
                      ? rosaClaro
                      : widget.isFavorite
                          ? azulClaro
                          : Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            //color: Colors.amber,
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                  // color: Colors.red,
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: MediaQuery.of(context).size.height * 0.15,
                          // color: Colors.blue,
                          child: Column(
                            children: [
                              Container(
                                //color: Colors.red,
                                width: MediaQuery.of(context).size.width * 0.75,

                                //color: Colors.red,
                                child: Center(
                                  child: Text(
                                    widget.titulo.toUpperCase(),
                                    style: GoogleFonts.poppins(
                                      fontSize: dt * 0.015,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                              Container(
                                //color: Colors.black12,
                                width: MediaQuery.of(context).size.width * 0.74,
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
                                //color: Colors.red,
                                child: SingleChildScrollView(
                                  child: Text(
                                    widget.descripcion[0].toUpperCase() +
                                        widget.descripcion.substring(1),
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.poppins(
                                      fontSize: dt * 0.012,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                              Container(
                                  //color: Colors.green,
                                  width:
                                      MediaQuery.of(context).size.width * 0.74,
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                  child: !widget.isTodos
                                      ? Text(
                                          'Ultima modificacion:   ${DateFormat('dd/MM/yyyy hh:mm a').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                              widget.fechaCreacion
                                                  .millisecondsSinceEpoch,
                                            ),
                                          )}',
                                          style: GoogleFonts.poppins(
                                            fontSize: dt * 0.01,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          overflow: TextOverflow.clip,
                                        )
                                      : null)
                            ],
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.12,
                        height: MediaQuery.of(context).size.height * 0.16,
                        // color: Colors.green,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.019,
                              // color: Colors.pink,
                              child: Center(
                                child: Text(
                                  widget.clase == 'nota' ? 'Nota' : 'Tarea',
                                  style: GoogleFonts.poppins(
                                    fontSize: dt * 0.013,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.12,
                              //color: Colors.blue,
                              child: !widget.isTodos
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            //color: Colors.red,
                                            child: IconButton(
                                              onPressed: () {
                                                widget.clase == 'nota'
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditNote(
                                                            notaId:
                                                                widget.itemId,
                                                            titulo:
                                                                widget.titulo,
                                                            descripcion: widget
                                                                .descripcion,
                                                          ),
                                                        ),
                                                      )
                                                    : Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditTarea(
                                                            tareaId:
                                                                widget.itemId,
                                                            titulo:
                                                                widget.titulo,
                                                            descripcion: widget
                                                                .descripcion,
                                                          ),
                                                        ),
                                                      );
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                size: dt * 0.02,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            //color: Colors.green,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            child: IconButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: const Text(
                                                              '¿Estas seguro?'),
                                                          content: const Text(
                                                              '¿Quieres eliminar esta nota?'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    'Cancelar')),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);

                                                                  widget.deleteItem(
                                                                      widget
                                                                          .itemId);
                                                                },
                                                                child: const Text(
                                                                    'Eliminar')),
                                                          ],
                                                        ));
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                size: dt * 0.02,
                                              ),
                                            ),
                                          ),
                                        ])
                                  : null,
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ),
        if (widget.isFavorite)
          Container(
            decoration: BoxDecoration(
              color: azulClaro,
              borderRadius: BorderRadius.circular(20),
            ),
            //color: Colors.amber,
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          //color: Colors.blue,
                          child: Column(
                            children: [
                              Container(
                                //color: Colors.red,
                                width: MediaQuery.of(context).size.width * 0.75,

                                //color: Colors.red,
                                child: Center(
                                  child: Text(
                                    widget.titulo.toUpperCase(),
                                    style: GoogleFonts.poppins(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                              Container(
                                // color: Colors.amber,
                                width: MediaQuery.of(context).size.width * 0.74,
                                height:
                                    MediaQuery.of(context).size.height * 0.09,
                                //color: Colors.red,
                                child: SingleChildScrollView(
                                  child: Text(
                                    widget.descripcion[0].toUpperCase() +
                                        widget.descripcion.substring(1),
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.poppins(
                                      fontSize: dt * 0.015,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                              Container(
                                  //color: Colors.green,
                                  width:
                                      MediaQuery.of(context).size.width * 0.74,
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                  child: !widget.isTodos
                                      ? Text(
                                          'Ultima modificacion:   ${DateFormat('dd/MM/yyyy hh:mm a').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                              widget.fechaCreacion
                                                  .millisecondsSinceEpoch,
                                            ),
                                          )}',
                                          style: GoogleFonts.poppins(
                                            fontSize: dt * 0.01,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          overflow: TextOverflow.clip,
                                        )
                                      : null)
                            ],
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.122,
                        height: MediaQuery.of(context).size.height * 0.16,
                        //color: Colors.green,
                        child: Column(
                          children: [
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.019,
                              //color: Colors.pink,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Center(
                                        child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.085,
                                      color: widget.clase == 'tarea'
                                          ? rosaClaro
                                          : amarilloGolden,
                                      child: Text(
                                        widget.clase == 'tarea'
                                            ? 'Tarea'
                                            : 'Nota',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: dt * 0.013,
                                        ),
                                      ),
                                    )),
                                    AnimatedEmoji(
                                      AnimatedEmojis.glowingStar,
                                      size: dt * 0.015,
                                    ),
                                  ]),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.12,
                              //color: Colors.black38,
                              child: !widget.isTodos
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04,
                                            //color: Colors.amber,
                                            child: IconButton(
                                              onPressed: () {
                                                widget.clase == 'nota' &&
                                                        !widget.isFavorite
                                                    ? Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditNote(
                                                            notaId:
                                                                widget.itemId,
                                                            titulo:
                                                                widget.titulo,
                                                            descripcion: widget
                                                                .descripcion,
                                                          ),
                                                        ),
                                                      )
                                                    : widget.clase == 'tarea' &&
                                                            !widget.isFavorite
                                                        ? Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      EditTarea(
                                                                tareaId: widget
                                                                    .itemId,
                                                                titulo: widget
                                                                    .titulo,
                                                                descripcion: widget
                                                                    .descripcion,
                                                              ),
                                                            ),
                                                          )
                                                        : Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      EditFav(
                                                                clase: widget
                                                                    .clase,
                                                                favoritoId:
                                                                    widget
                                                                        .itemId,
                                                                titulo: widget
                                                                    .titulo,
                                                                descripcion: widget
                                                                    .descripcion,
                                                              ),
                                                            ),
                                                          );
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                size: dt * 0.02,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04,
                                            // color: Colors.red,
                                            child: IconButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: const Text(
                                                              '¿Estas seguro?'),
                                                          content: const Text(
                                                              '¿Quieres eliminar esta nota?'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    'Cancelar')),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);

                                                                  widget.deleteItem(
                                                                      widget
                                                                          .itemId);
                                                                },
                                                                child: const Text(
                                                                    'Eliminar')),
                                                          ],
                                                        ));
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                size: dt * 0.02,
                                              ),
                                            ),
                                          ),
                                        ])
                                  : null,
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ),
      ]),
    );
  }
}
