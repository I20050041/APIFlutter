import 'package:flutter/material.dart';
import 'package:prflutter/carrito.dart';
import 'mostrar_articulo.dart';
import 'mostrar_categoria.dart';
import 'mostrar_proveedor.dart';

class MenuScreen extends StatelessWidget {
  final List<Map<String, dynamic>> carrito = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarritoScreen(carrito: carrito),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MenuButton(
              icon: Icons.article,
              text: 'Artículo',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MostrarArticulo(carrito: carrito),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            MenuButton(
              icon: Icons.category,
              text: 'Categoría',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MostrarCategoria()),
                );
              },
            ),
            SizedBox(height: 16),
            MenuButton(
              icon: Icons.local_shipping,
              text: 'Proveedor',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MostrarProveedor()),
                );
              },
            ),
            SizedBox(height: 16),
            MenuButton(
              icon: Icons.shopping_cart,
              text: 'Carrito',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CarritoScreen(carrito: carrito)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const MenuButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              SizedBox(width: 16),
              Text(
                text,
                style: TextStyle(fontSize: 24, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
