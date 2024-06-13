import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'articulo_crud.dart'; // Importar la clase ArticuloCRUD
import 'carrito.dart';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'menu_screen.dart'; // Importar la clase MenuScreen

class MostrarArticulo extends StatefulWidget {
  final List<Map<String, dynamic>> carrito;

  const MostrarArticulo({Key? key, required this.carrito}) : super(key: key);

  @override
  _MostrarArticuloState createState() => _MostrarArticuloState();
}

class _MostrarArticuloState extends State<MostrarArticulo> {
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
        title: Text('Mostrar Artículos'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarritoScreen(carrito: widget.carrito),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.menu), // Icono para el botón de menú
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MenuScreen(), // Navegar a la pantalla de menú
                ),
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
                future: obtenerTodosLosArticulos(),
                builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final articulos = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: articulos.length,
                      itemBuilder: (context, index) {
                        final articulo = articulos[index];
                        return Card(
                          child: ListTile(
                            title: Text(articulo['nombre']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Descripción: ${articulo['descripcion']}"),
                                Text("Precio: ${articulo['precioUnitario']}"),
                                Text("Stock: ${articulo['stock']}"),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    final updatedArticulo = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ArticuloCRUD(
                                          articulo: articulo,
                                          carrito: widget.carrito,
                                        ),
                                      ),
                                    );
                                    if (updatedArticulo != null) {
                                      setState(() {
                                        final index = widget.carrito.indexWhere((item) => item['idArticulos'] == updatedArticulo['idArticulos']);
                                        if (index != -1) {
                                          widget.carrito[index] = updatedArticulo;
                                        }
                                      });
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(context, articulo['idArticulos']);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.add_shopping_cart),
                                  onPressed: () {
                                    setState(() {
                                      widget.carrito.add(articulo);
                                    });
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
              onPressed: () async {
                final newArticulo = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticuloCRUD(
                      carrito: widget.carrito,
                    ),
                  ),
                );
                if (newArticulo != null) {
                  setState(() {
                    widget.carrito.add(newArticulo);
                  });
                }
              },
              child: Text('Insertar'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> obtenerTodosLosArticulos() async {
    try {
      Response response = await _dio.get(
        'https://10.0.2.2:7107/api/Articulos',
      );

      if (response.statusCode == 200) {
        List<dynamic> articulos = response.data;
        return List<Map<String, dynamic>>.from(
            articulos.where((articulo) => articulo['estatus'] == 1)
        );
      } else {
        throw Exception('Error al obtener los artículos');
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

  void deleteArticulo(int id) async {
    try {
      Response response = await _dio.put(
        'https://10.0.2.2:7107/api/Articulos/inactivar/$id',
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Artículo eliminado')),
        );
        // Recargar la lista de artículos después de la eliminación
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el artículo')),
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
                Text('¿Está seguro de que desea eliminar este artículo?'),
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
                deleteArticulo(id); // Llama al método de eliminación
              },
            ),
          ],
        );
      },
    );
  }
}

