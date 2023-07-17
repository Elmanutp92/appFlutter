import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lets_note/pages/edit_tarea.dart';

class CardTareas extends StatefulWidget {
  final Function deleteTarea;
  final String descripcion;
  final String titulo;
  final String tareaId;
  final Color cardColor;
  const CardTareas({
    super.key,
    required this.deleteTarea,
    required this.descripcion,
    required this.titulo,
    required this.tareaId,
    required this.cardColor,
  });

  @override
  State<CardTareas> createState() => _CardTareasState();
}

class _CardTareasState extends State<CardTareas> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          color: widget.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        //color: Colors.amber,
        height: MediaQuery.of(context).size.height * 0.15,
        child: Card(
            color: Colors.transparent,
            elevation: 0,
            child: ListTile(
              trailing: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTarea(
                              tareaId: widget.tareaId,
                              titulo: widget.titulo,
                              descripcion: widget.descripcion,
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
                                  title: const Text('¿Estas seguro?'),
                                  content: const Text(
                                      '¿Quieres eliminar esta tarea?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancelar')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);

                                          widget.deleteTarea(widget.tareaId);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Tarea eliminada correctamente'),
                                            ),
                                          );
                                        },
                                        child: const Text('Eliminar')),
                                  ],
                                ));
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
              title: Flexible(
                child: Text(
                  widget.titulo,
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              subtitle: Expanded(
                child: Text(
                  widget.descripcion,
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )),
      ),
    );
  }
}
