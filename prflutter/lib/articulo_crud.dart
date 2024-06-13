import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'mostrar_articulo.dart';

class ArticuloCRUD extends StatefulWidget {
  final Map<String, dynamic>? articulo;
  final List<Map<String, dynamic>> carrito;

  const ArticuloCRUD({Key? key, this.articulo, required this.carrito}) : super(key: key);

  @override
  _ArticuloCRUDState createState() => _ArticuloCRUDState();
}

class _ArticuloCRUDState extends State<ArticuloCRUD> {
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  late TextEditingController _stockController;
  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.articulo?['nombre'] ?? '');
    _descripcionController = TextEditingController(text: widget.articulo?['descripcion'] ?? '');
    _precioController = TextEditingController(text: widget.articulo?['precioUnitario']?.toString() ?? '');
    _stockController = TextEditingController(text: widget.articulo?['stock']?.toString() ?? '');
    _dio = createDio();
  }

  Dio createDio() {
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    return dio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.articulo == null ? 'Agregar Artículo' : 'Modificar Artículo'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: _precioController,
              decoration: InputDecoration(labelText: 'Precio Unitario'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _stockController,
              decoration: InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget.articulo == null) {
                  _agregarArticulo();
                } else {
                  _modificarArticulo(widget.articulo!['idArticulos']);
                }
              },
              child: Text(widget.articulo == null ? 'Agregar' : 'Modificar'),
            ),
          ],
        ),
      ),
    );
  }

  void _agregarArticulo() async {
    String nombre = _nombreController.text;
    String descripcion = _descripcionController.text;
    double precio = double.parse(_precioController.text);
    int cantidad = int.parse(_stockController.text);

    try {
      Response response = await _dio.post(
        'https://10.0.2.2:7107/api/Articulos',
        data: {
          'nombre': nombre,
          'descripcion': descripcion,
          'precioUnitario': precio,
          'stock': cantidad,
          'estatus': 1,
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Artículo añadido')),
        );
        // Navegar de vuelta a MostrarArticulo
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MostrarArticulo(carrito: widget.carrito),
          ),
              (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir el artículo')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  void _modificarArticulo(int id) async {
    String nombre = _nombreController.text;
    String descripcion = _descripcionController.text;
    double precio = double.parse(_precioController.text);
    int stock = int.parse(_stockController.text);

    try {
      Response response = await _dio.put(
        'https://10.0.2.2:7107/api/Articulos/$id',
        data: {
          'idArticulos': id,
          'nombre': nombre,
          'descripcion': descripcion,
          'precioUnitario': precio,
          'stock': stock,
          'estatus': 1,
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Artículo actualizado')),
        );
        // Navegar de vuelta a MostrarArticulo
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MostrarArticulo(carrito: widget.carrito),
          ),
              (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el artículo')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }
}



