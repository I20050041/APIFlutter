import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'categoria_crud.dart';
import 'menu_screen.dart'; // Importar la pantalla del menú
import 'dart:io';
import 'package:dio/adapter.dart';

class MostrarCategoria extends StatefulWidget {
  const MostrarCategoria({Key? key}) : super(key: key);

  @override
  _MostrarCategoriaState createState() => _MostrarCategoriaState();
}

class _MostrarCategoriaState extends State<MostrarCategoria> {
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
        title: Text('Mostrar Categorías'),
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
                future: obtenerTodasLasCategorias(),
                builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final categorias = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: categorias.length,
                      itemBuilder: (context, index) {
                        final categoria = categorias[index];
                        return Card(
                          child: ListTile(
                            title: Text("Nombre: ${categoria['nombre']}"),
                            subtitle: Text("Descripción: ${categoria['descripcion']}"),
                            // Botones de editar y eliminar
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CategoriaCRUD(categoria: categoria),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    mostrarConfirmacionEliminar(categoria['idCategoria']);
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
                  MaterialPageRoute(builder: (context) => CategoriaCRUD()),
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

  Future<List<Map<String, dynamic>>> obtenerTodasLasCategorias() async {
    try {
      Response response = await _dio.get(
        'https://10.0.2.2:7107/api/Categoria',
      );

      if (response.statusCode == 200) {
        List<dynamic> categorias = response.data;
        return List<Map<String, dynamic>>.from(
            categorias.where((categoria) => categoria['estatus'] == 1)
        );
      } else {
        throw Exception('Error al obtener las categorías');
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

  void deleteCategoria(int id) async {
    try {
      Response response = await _dio.put(
        'https://10.0.2.2:7107/api/Categoria/inactivar/$id',
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Categoría eliminada')),
        );
        // Recargar la lista de categorías después de la eliminación
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar la categoría')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  void mostrarConfirmacionEliminar(int id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
      return AlertDialog(
          title: Text("Eliminar categoría"),
        content: Text("¿Estás seguro de que deseas eliminar esta categoría?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              deleteCategoria(id);
              Navigator.of(context).pop();
            },
            child: Text("Eliminar"),
          ),
        ],
      );
        },
    );
  }
}


