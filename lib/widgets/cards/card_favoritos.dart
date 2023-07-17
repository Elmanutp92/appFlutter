import 'package:flutter/material.dart';

import '../../styles/colors.dart';

class CardFavoritos extends StatefulWidget {
  final Function deleteDataFav;
  final String favoritoId;
  final Color cardColor;
  final bool isFavorite;
  final String titulo;
  final String descripcion;
  final String clase;
  const CardFavoritos({
    super.key,
    required this.cardColor,
    required this.isFavorite,
    required this.titulo,
    required this.descripcion,
    required this.clase,
    required this.deleteDataFav,
    required this.favoritoId,
  });

  @override
  State<CardFavoritos> createState() => _CardFavoritosState();
}

class _CardFavoritosState extends State<CardFavoritos> {
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
              height: MediaQuery.of(context).size.height * 0.2,
              child: Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Column(
                        children: [
                          Text(widget.clase == 'tarea' ? 'Tarea' : 'Nota'),
                          const Icon(Icons.star,
                              color: amarilloGolden, size: 40),
                        ],
                      )),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('¿Estas seguro?'),
                                content: Text(widget.clase == 'tarea'
                                    ? '¿Quieres eliminar esta Tarea?'
                                    : '¿Quieres eliminar esta Nota?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancelar')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);

                                        widget.deleteDataFav(widget.favoritoId);

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
                overflow: TextOverflow.ellipsis,
              ),
            ),
            subtitle: Flexible(
              child: Text(
                widget.descripcion,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
