import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'proveedor_crud.dart'; // Importar la clase ProveedorCRUD
import 'dart:io';
import 'package:dio/adapter.dart';
import 'menu_screen.dart'; // Importar la pantalla del menú

class MostrarProveedor extends StatefulWidget {
  const MostrarProveedor({Key? key}) : super(key: key);

  @override
  _MostrarProveedorState createState() => _MostrarProveedorState();
}

class _MostrarProveedorState extends State<MostrarProveedor> {
  late Dio _dio;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _dio = createDio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mostrar Proveedores'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: obtenerTodosLosProveedores(),
                builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final proveedores = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: proveedores.length,
                      itemBuilder: (context, index) {
                        final proveedor = proveedores[index];
                        return Card(
                          child: ListTile(
                            title: Text(proveedor['nombre']),
                            subtitle: Text("Dirección: ${proveedor['direccion']}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProveedorCRUD(proveedor: proveedor),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(context, proveedor['idProveedor']);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProveedorCRUD()),
                );
              },
              child: Text('Insertar'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> obtenerTodosLosProveedores() async {
    try {
      Response response = await _dio.get(
        'https://10.0.2.2:7107/api/Proveedor',
      );

      if (response.statusCode == 200) {
        List<dynamic> proveedores = response.data;
        return List<Map<String, dynamic>>.from(
            proveedores.where((proveedor) => proveedor['estatus'] == 1)
        );
      } else {
        throw Exception('Error al obtener los proveedores');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Dio createDio() {
    var dio = Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    return dio;
  }

  void deleteProveedor(int id) async {
    try {
      Response response = await _dio.put(
        'https://10.0.2.2:7107/api/Proveedor/inactivar/$id',
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Proveedor eliminado')),
        );
        // Recargar la lista de proveedores después de la eliminación
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el proveedor')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe presionar un botón del diálogo
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Está seguro de que desea eliminar este proveedor?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                deleteProveedor(id); // Llama al método de eliminación
              },
            ),
          ],
        );
      },
    );
  }
}

