import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FotoCircular extends StatefulWidget {
  final String nombre;
  final String apellido;
  final Function? onPressed;

  const FotoCircular({
    super.key,
    required this.nombre,
    required this.apellido,
    this.onPressed,
  });

  @override
  State<FotoCircular> createState() => _FotoCircularState();
}

class _FotoCircularState extends State<FotoCircular> {
  String foto = '';
  String userId = '';

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      fetchData();
    }
  }

  Future<void> fetchData() async {
    if (userId.isNotEmpty) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          foto = userData['fotoPerfil'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey[300],
        child: foto.isEmpty
            ? InkWell(
                onDoubleTap: () {
                  fetchData();
                },
                child: Text(
                    (widget.nombre.isNotEmpty
                            ? widget.nombre[0].toUpperCase()
                            : '?') +
                        (widget.apellido.isNotEmpty
                            ? widget.apellido[0].toUpperCase()
                            : '?'),
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.normal,
                    )),
              )
            : InkWell(
                onDoubleTap: () {
                  fetchData();
                },
                child: Image.network(foto,
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.5,
                    fit: BoxFit.cover),
              ));
  }
}
