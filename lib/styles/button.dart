import 'package:flutter/material.dart';

class ButtonHome extends StatelessWidget {
  final String btntxt;
  final VoidCallback onPressed;
  final Color color;
  const ButtonHome(
      {super.key,
      required this.color,
      required this.onPressed,
      required this.btntxt});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(
            Size(
              MediaQuery.of(context).size.width * 0.5,
              MediaQuery.of(context).size.height * 0.06,
            ),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: const BorderSide(color: Colors.white),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(color),
          overlayColor: MaterialStateProperty.all<Color>(
            Colors.white.withOpacity(0.1),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          btntxt,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
