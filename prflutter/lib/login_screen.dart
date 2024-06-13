import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'menu_screen.dart';
import 'dart:io';
import 'package:dio/adapter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final Dio _dio = createDio();
  final _storage = const FlutterSecureStorage();

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        Response response = await _dio.get(
          'https://10.0.2.2:7107/api/Usuario/autenticar',
          queryParameters: {
            'correo': email,
            'contrasena': password,
          },
        );

        if (response.statusCode == 200) {
          // Autenticación exitosa
          // asumiendo que la respuesta contiene un token
          await _storage.write(key: 'token', value: response.data['token']);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  MenuScreen()),
          );
        } else {
          _showMessage('Credenciales inválidas');
        }
      } catch (e) {
        print('Error: $e');
        _showMessage('Error de conexión');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
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
