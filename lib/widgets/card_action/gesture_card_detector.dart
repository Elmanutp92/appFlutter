import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_note/pages/edit_tarea.dart';

import '../../pages/edit_nota.dart';
import '../../styles/colors.dart';
import '../cards/card_item.dart';

class GestureCardDetector extends StatefulWidget {
  final String clase;
  final String tiulo;
  final String descripcion;
  final String itemId;
  final Function deleteItem;
  final bool isFavorite;

  const GestureCardDetector(
      {super.key,
      required this.clase,
      required this.tiulo,
      required this.descripcion,
      required this.itemId,
      required this.deleteItem,
      required this.isFavorite});

  @override
  State<GestureCardDetector> createState() => _GestureCardDetectorState();
}

class _GestureCardDetectorState extends State<GestureCardDetector> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(19.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: widget.clase == 'nota' && !widget.isFavorite
                        ? amarilloGolden
                        : widget.clase == 'tarea' && !widget.isFavorite
                            ? rosaClaro
                            : widget.isFavorite
                                ? azulClaro
                                : Colors.red,
                    borderRadius: BorderRadius.circular(20)),
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.8,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      //color: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.tiulo.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.08,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.05,
                      // 20.0,
                    ),
                    Container(
                      //color: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: SingleChildScrollView(
                        child: Text(
                          widget.descripcion.toString().toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    !widget.isFavorite
                        ? IconButton(
                            onPressed: () {
                              widget.clase == 'nota'
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditNote(
                                          notaId: widget.itemId,
                                          titulo: widget.tiulo,
                                          descripcion: widget.descripcion,
                                        ),
                                      ),
                                    )
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditTarea(
                                          tareaId: widget.itemId,
                                          titulo: widget.tiulo,
                                          descripcion: widget.descripcion,
                                        ),
                                      ),
                                    );
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.black45,
                            ),
                          )
                        : AnimatedEmoji(
                            AnimatedEmojis.glowingStar,
                            size: MediaQuery.of(context).size.width * 0.08,
                          ),
                  ],
                ),
              ),
            ),
          );
        },
        child: CardItem(
          isFavorite: widget.isFavorite,
          clase: widget.clase,
          deleteItem: widget.deleteItem,
          descripcion: widget.descripcion,
          titulo: widget.tiulo,
          itemId: widget.itemId,
        ));
  }
}
