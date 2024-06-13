import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'menu_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final Dio _dio = createDio();

  void _register() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty) {
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        _showMessage('Correo no válido');
        return;
      }

      if (password != confirmPassword) {
        _showMessage('Las contraseñas no coinciden');
        return;
      }

      if (await _isEmailAlreadyRegistered(email)) {
        _showMessage('El correo ya está registrado, por favor elige otro');
        return;
      }

      try {
        Response response = await _dio.post(
          'https://10.0.2.2:7107/api/Usuario',
          data: {
            'nombre': name,
            'correo': email,
            'contrasena': password,
            'estatus': 1, // Assuming the user status is active by default
          },
        );

        if (response.statusCode == 200) {
          _showMessage('Registro exitoso');
          Navigator.pop(context); // Go back to the login screen
        } else {
          _showMessage('Error en el registro');
        }
      } catch (e) {
        print('Error: $e');
        _showMessage('Error en el registro');
      }
    }
  }

  Future<bool> _isEmailAlreadyRegistered(String email) async {
    try {
      Response response = await _dio.get('https://10.0.2.2:7107/api/Usuario');

      if (response.statusCode == 200) {
        List usuarios = response.data;

        for (var usuario in usuarios) {
          if (usuario['correo'] == email) {
            return true;
          }
        }
      }
    } catch (e) {
      print('Error: $e');
    }

    return false;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50),
              Text(
                'Registrarse',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Registrarse'),
              ),
            ],
          ),
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
