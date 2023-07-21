import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';

class NoFound extends StatelessWidget {
  const NoFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('¡Ups, Parece que lo que buscas no esta aqui!',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            AnimatedEmoji(
              AnimatedEmojis.xEyes,
              size: MediaQuery.of(context).size.width * 0.3,
            ),
          ],
        ),
      ),
    );
  }
}
