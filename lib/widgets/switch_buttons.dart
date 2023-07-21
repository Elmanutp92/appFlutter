import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../styles/colors.dart';

class SwitchButtons extends StatefulWidget {
  final bool isButtonEnabled;
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
    required this.isButtonEnabled,
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
            width: MediaQuery.of(context).size.width * 0.99,
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
                    backgroundColor: MaterialStateProperty.all<Color>(azulNavy),
                    overlayColor: MaterialStateProperty.all<Color>(
                      Colors.white.withOpacity(0.1),
                    ),
                  ),
                  onPressed:
                      widget.isButtonEnabled ? widget.cambiarTodos : null,
                  child: widget.isButtonEnabled
                      ? const Text(
                          'Todos',
                          style: TextStyle(color: Colors.white),
                        )
                      : SpinKitRipple(
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width * 0.05,
                        ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    elevation: widget.favoritos
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
                  onPressed:
                      widget.isButtonEnabled ? widget.cambiarFavoritos : null,
                  child: widget.isButtonEnabled
                      ? const Text(
                          'Favoritos',
                          style: TextStyle(color: negro),
                        )
                      : SpinKitRipple(
                          color: azulNavy,
                          size: MediaQuery.of(context).size.width * 0.05,
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
                  onPressed:
                      widget.isButtonEnabled ? widget.cambiarTareas : null,
                  child: widget.isButtonEnabled
                      ? const Text(
                          'Tareas',
                          style: TextStyle(color: negro),
                        )
                      : SpinKitRipple(
                          color: azulNavy,
                          size: MediaQuery.of(context).size.width * 0.05,
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
                  onPressed:
                      widget.isButtonEnabled ? widget.cambiarNotas : null,
                  child: widget.isButtonEnabled
                      ? const Text(
                          'Notas',
                          style: TextStyle(color: negro),
                        )
                      : SpinKitRipple(
                          color: azulNavy,
                          size: MediaQuery.of(context).size.width * 0.05,
                        ),
                ),
              ],
            )),
      ],
    );
  }
}
