import 'package:flutter/material.dart';

import '../../styles/colors.dart';

class CardTodos extends StatefulWidget {
  final bool isFavorite;
  final String titulo;
  final String descripcion;
  final String clase;
  const CardTodos(
      {super.key,
      required this.isFavorite,
      required this.titulo,
      required this.descripcion,
      required this.clase});

  @override
  State<CardTodos> createState() => _CardTodosState();
}

class _CardTodosState extends State<CardTodos> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: widget.clase == 'nota' && !widget.isFavorite
              ? amarilloGolden
              : (widget.clase == 'tarea' && !widget.isFavorite
                  ? rosaClaro
                  : (widget.isFavorite == true ? azulClaro : Colors.red)),
          borderRadius: BorderRadius.circular(20),
        ),
        //color: Colors.amber,
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.88,
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: ListTile(
            trailing: widget.isFavorite == true && widget.clase == 'nota'
                ? Container(
                    //color: Colors.red,
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Column(
                      children: [
                        Container(
                          //color: Colors.black,
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: const Column(
                            children: [
                              Text('Nota'),
                              Icon(
                                Icons.star,
                                color: amarilloGolden,
                                size: 40,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : widget.isFavorite == true && widget.clase == 'tarea'
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: const Text('Tarea'),
                            ),
                            const Icon(
                              Icons.star,
                              color: amarilloGolden,
                              size: 40,
                            ),
                          ],
                        ),
                      )
                    : widget.clase == 'nota'
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: const Text('Nota'),
                          )
                        : widget.clase == 'tarea'
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: const Text('Tarea'),
                              )
                            : null,
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
