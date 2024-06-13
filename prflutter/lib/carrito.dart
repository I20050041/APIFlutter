import 'package:flutter/material.dart';

class CarritoScreen extends StatefulWidget {
  final List<Map<String, dynamic>> carrito;

  const CarritoScreen({Key? key, required this.carrito}) : super(key: key);

  @override
  _CarritoScreenState createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  late List<Map<String, dynamic>> _carrito;

  @override
  void initState() {
    super.initState();
    _carrito = List.from(widget.carrito); // Copia de la lista original
  }

  void _eliminarDelCarrito(int index) {
    setState(() {
      _carrito.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double total = _carrito.fold(0, (sum, item) => sum + item['precioUnitario']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _carrito.length,
                itemBuilder: (context, index) {
                  final articulo = _carrito[index];
                  return Card(
                    child: ListTile(
                      title: Text(articulo['nombre']),
                      subtitle: Text('Precio: \$${articulo['precioUnitario']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_shopping_cart),
                        onPressed: () => _eliminarDelCarrito(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
