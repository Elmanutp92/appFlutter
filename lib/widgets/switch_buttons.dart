import 'package:flutter/material.dart';

import '../styles/colors.dart';

class SwitchButtons extends StatefulWidget {
  final bool favoritos;

  final bool tareas;

  final bool notas;
  final bool todos;
  final VoidCallback cambiarTodos;
  final VoidCallback cambiarFavoritos;
  final VoidCallback cambiarTareas;
  final VoidCallback cambiarNotas;
  const SwitchButtons({
    Key? key,
    required this.cambiarTodos,
    required this.todos,
    required this.favoritos,
    required this.tareas,
    required this.notas,
    required this.cambiarFavoritos,
    required this.cambiarTareas,
    required this.cambiarNotas,
  }) : super(key: key);

  @override
  State<SwitchButtons> createState() => _SwitchButtonsState();
}

class _SwitchButtonsState extends State<SwitchButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
            width: MediaQuery.of(context).size.width * 0.55,
            //color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: widget.todos
                        ? MaterialStateProperty.all<double>(0)
                        : MaterialStateProperty.all<double>(15),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Colors.white),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(azulClaro),
                    overlayColor: MaterialStateProperty.all<Color>(
                      Colors.white.withOpacity(0.1),
                    ),
                  ),
                  onPressed: widget.cambiarTodos,
                  child: const Text(
                    'Todos',
                    style: TextStyle(color: negro),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: widget.tareas
                        ? MaterialStateProperty.all<double>(0)
                        : MaterialStateProperty.all<double>(15),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(rosaClaro),
                    overlayColor: MaterialStateProperty.all<Color>(
                      Colors.white.withOpacity(0.1),
                    ),
                  ),
                  onPressed: widget.cambiarTareas,
                  child: const Text(
                    'Tareas',
                    style: TextStyle(color: negro),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: widget.notas
                        ? MaterialStateProperty.all<double>(0)
                        : MaterialStateProperty.all<double>(15),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(amarilloGolden),
                    overlayColor: MaterialStateProperty.all<Color>(
                      Colors.white.withOpacity(0.1),
                    ),
                  ),
                  onPressed: widget.cambiarNotas,
                  child: const Text(
                    'Notas',
                    style: TextStyle(color: negro),
                  ),
                ),
              ],
            )),
        ElevatedButton(
            style: ButtonStyle(
              elevation: widget.favoritos
                  ? MaterialStateProperty.all<double>(0)
                  : MaterialStateProperty.all<double>(15),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: const BorderSide(color: Colors.white),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(azulNavy),
              overlayColor: MaterialStateProperty.all<Color>(
                Colors.white.withOpacity(0.1),
              ),
            ),
            onPressed: widget.cambiarFavoritos,
            child: const Icon(Icons.person_2)),
      ],
    );
  }
}
