import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'mostrar_categoria.dart';

class CategoriaCRUD extends StatefulWidget {
  final Map<String, dynamic>? categoria;

  const CategoriaCRUD({Key? key, this.categoria}) : super(key: key);

  @override
  _CategoriaCRUDState createState() => _CategoriaCRUDState();
}

class _CategoriaCRUDState extends State<CategoriaCRUD> {
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.categoria?['nombre'] ?? '');
    _descripcionController = TextEditingController(text: widget.categoria?['descripcion'] ?? '');
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
        title: Text(widget.categoria == null ? 'Agregar Categoría' : 'Modificar Categoría'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget.categoria == null) {
                  _agregarCategoria();
                } else {
                  _modificarCategoria(widget.categoria!['idCategoria']);
                }
              },
              child: Text(widget.categoria == null ? 'Agregar' : 'Modificar'),
            ),
          ],
        ),
      ),
    );
  }

  void _agregarCategoria() async {
    String nombre = _nombreController.text;
    String descripcion = _descripcionController.text;

    try {
      Response response = await _dio.post(
        'https://10.0.2.2:7107/api/Categoria',
        data: {
          'nombre': nombre,
          'descripcion': descripcion,
          'estatus': 1,
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Categoría añadida')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MostrarCategoria()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir la categoría')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }


  void _modificarCategoria(int id) async {
    String nombre = _nombreController.text;
    String descripcion = _descripcionController.text;

    try {
      Response response = await _dio.put(
        'https://10.0.2.2:7107/api/Categoria/$id',
        data: {
          'idCategoria': id,
          'nombre': nombre,
          'descripcion': descripcion,
          'estatus': 1,
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Categoría actualizada')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MostrarCategoria()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la categoría')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }
}
