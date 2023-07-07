import 'package:flutter/material.dart';

import '../styles/colors.dart';

class ListTileDrawer extends StatelessWidget {
  const ListTileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: amarilloGolden,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              'Menu',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            EndDrawerButton(
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ]),
        ),
        ListTile(
          trailing: Icon(Icons.home),
          title: Text(
            'Pagina de Inicio',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          onTap: () {
            // Acción para el item 1
          },
        ),
        const Divider(),
        ListTile(
          trailing: Icon(Icons.star),
          title: Text(
            'Favoritos',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          onTap: () {
            // Acción para el item 2
          },
        ),
        const Divider(),
        ListTile(
          trailing: Icon(Icons.note),
          title: Text(
            'Notas',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          onTap: () {
            // Acción para el item 2
          },
        ),
        const Divider(),
        ListTile(
          trailing: Icon(Icons.assignment),
          title: Text(
            'Tareas',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          onTap: () {
            // Acción para el item 2
          },
        ),
        const Divider(),
        ListTile(
          trailing: Icon(Icons.delete),
          title: Text(
            'Papelera',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          onTap: () {
            // Acción para el item 2
          },
        ),
      ],
    );
  }
}
