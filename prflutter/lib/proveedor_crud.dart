import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'mostrar_proveedor.dart'; // Importa la clase MostrarProveedor
import 'dart:io';
import 'package:dio/adapter.dart';

class ProveedorCRUD extends StatefulWidget {
  final Map<String, dynamic>? proveedor;

  const ProveedorCRUD({Key? key, this.proveedor}) : super(key: key);

  @override
  _ProveedorCRUDState createState() => _ProveedorCRUDState();
}

class _ProveedorCRUDState extends State<ProveedorCRUD> {
  late TextEditingController _nombreController;
  late TextEditingController _razonSocialController;
  late TextEditingController _direccionController;
  late TextEditingController _telefonoController;
  late TextEditingController _rfcController;
  late TextEditingController _correoController;
  late Dio _dio;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.proveedor?['nombre'] ?? '');
    _razonSocialController = TextEditingController(text: widget.proveedor?['razonSocial'] ?? '');
    _direccionController = TextEditingController(text: widget.proveedor?['direccion'] ?? '');
    _telefonoController = TextEditingController(text: widget.proveedor?['telefono'] ?? '');
    _rfcController = TextEditingController(text: widget.proveedor?['rfc'] ?? '');
    _correoController = TextEditingController(text: widget.proveedor?['correo'] ?? '');
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
        title: Text(widget.proveedor == null ? 'Agregar Proveedor' : 'Modificar Proveedor'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView( // Envuelve el cuerpo en SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _razonSocialController,
                decoration: InputDecoration(labelText: 'Razón Social'),
              ),
              TextField(
                controller: _direccionController,
                decoration: InputDecoration(labelText: 'Dirección'),
              ),
              TextField(
                controller: _telefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
              ),
              TextField(
                controller: _rfcController,
                decoration: InputDecoration(labelText: 'RFC'),
              ),
              TextField(
                controller: _correoController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (widget.proveedor == null) {
                    _agregarProveedor();
                  } else {
                    _modificarProveedor(widget.proveedor!['idProveedor']);
                  }
                },
                child: Text(widget.proveedor == null ? 'Agregar' : 'Modificar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _agregarProveedor() async {
    String nombre = _nombreController.text;
    String razonSocial = _razonSocialController.text;
    String direccion = _direccionController.text;
    String telefono = _telefonoController.text;
    String rfc = _rfcController.text;
    String correo = _correoController.text;

    try {
      Response response = await _dio.post(
        'https://10.0.2.2:7107/api/Proveedor',
        data: {
          'nombre': nombre,
          'razonSocial': razonSocial,
          'direccion': direccion,
          'telefono': telefono,
          'rfc': rfc,
          'correo': correo,
          'estatus': 1,
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Proveedor añadido')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MostrarProveedor()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al añadir el proveedor')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  void _modificarProveedor(int id) async {
    String nombre = _nombreController.text;
    String razonSocial = _razonSocialController.text;
    String direccion = _direccionController.text;
    String telefono = _telefonoController.text;
    String rfc = _rfcController.text;
    String correo = _correoController.text;

    try {
      Response response = await _dio.put(
        'https://10.0.2.2:7107/api/Proveedor/$id',
        data: {
          'idProveedor': id,
          'nombre': nombre,
          'razonSocial': razonSocial,
          'direccion': direccion,
          'telefono': telefono,
          'rfc': rfc,
          'correo': correo,
          'estatus': 1,
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Proveedor actualizado')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MostrarProveedor()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el proveedor')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }
}


