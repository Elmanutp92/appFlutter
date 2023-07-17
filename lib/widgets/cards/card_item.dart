import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  const CardItem({
    super.key,
    required this.deleteItem,
    required this.descripcion,
    required this.titulo,
    required this.itemId,
    required this.clase,
    required this.isFavorite,
  });

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 8,
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
                                // color: Colors.red,
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
                                //color: Colors.amber,
                                width: MediaQuery.of(context).size.width * 0.74,
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                //color: Colors.red,
                                child: SingleChildScrollView(
                                  child: Text(
                                    widget.descripcion[0].toUpperCase() +
                                        widget.descripcion.substring(1),
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.poppins(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.13,
                        height: MediaQuery.of(context).size.height * 0.15,
                        //color: Colors.green,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.019,
                              //color: Colors.pink,
                              child: Center(
                                child: Text(
                                  widget.clase == 'nota' ? 'Nota' : 'Tarea',
                                  style: GoogleFonts.poppins(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.12,
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.001),
                              //color: Colors.black38,
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        widget.clase == 'nota'
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditNote(
                                                    notaId: widget.itemId,
                                                    titulo: widget.titulo,
                                                    descripcion:
                                                        widget.descripcion,
                                                  ),
                                                ),
                                              )
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditTarea(
                                                    tareaId: widget.itemId,
                                                    titulo: widget.titulo,
                                                    descripcion:
                                                        widget.descripcion,
                                                  ),
                                                ),
                                              );
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
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
                                                              widget.itemId);
                                                        },
                                                        child: const Text(
                                                            'Eliminar')),
                                                  ],
                                                ));
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ]),
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
                                // color: Colors.red,
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
                                //color: Colors.amber,
                                width: MediaQuery.of(context).size.width * 0.74,
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                //color: Colors.red,
                                child: SingleChildScrollView(
                                  child: Text(
                                    widget.descripcion[0].toUpperCase() +
                                        widget.descripcion.substring(1),
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.poppins(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.13,
                        height: MediaQuery.of(context).size.height * 0.15,
                        //color: Colors.green,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.019,
                              //color: Colors.pink,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      widget.clase == 'nota' ? 'Nota' : 'Tarea',
                                      style: GoogleFonts.poppins(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      ),
                                    ),
                                    AnimatedEmoji(
                                      AnimatedEmojis.glowingStar,
                                      size: MediaQuery.of(context).size.width *
                                          0.05,
                                    ),
                                  ]),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.12,
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.001),
                              //color: Colors.black38,
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        widget.clase == 'nota'
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditNote(
                                                    notaId: widget.itemId,
                                                    titulo: widget.titulo,
                                                    descripcion:
                                                        widget.descripcion,
                                                  ),
                                                ),
                                              )
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditTarea(
                                                    tareaId: widget.itemId,
                                                    titulo: widget.titulo,
                                                    descripcion:
                                                        widget.descripcion,
                                                  ),
                                                ),
                                              );
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
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
                                                              widget.itemId);
                                                        },
                                                        child: const Text(
                                                            'Eliminar')),
                                                  ],
                                                ));
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ]),
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
