import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';

class ListaVacia extends StatelessWidget {
  const ListaVacia({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('¡Ups, Parece que aquí no hay nada! \n ¡Buuuu!',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          AnimatedEmoji(
            AnimatedEmojis.ghost,
            size: MediaQuery.of(context).size.width * 0.5,
          ),
        ],
      ),
    );
  }
}
