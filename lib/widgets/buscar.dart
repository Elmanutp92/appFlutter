import 'package:flutter/material.dart';

import '../styles/colors.dart';

class SearchHome extends StatelessWidget {
  const SearchHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: negro,
          ),
          filled: true,
          fillColor: blanco,
          labelStyle: TextStyle(color: negro),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: negro),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: 'Buscar',
          hintText: 'Ejemplo: "Mercado"',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
