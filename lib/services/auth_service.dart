import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Reemplaza esta URL con la URL de tu API desplegada en Render
  final String _baseUrl = 'https://putnik-python-api.onrender.com';

  // --- Método para Iniciar Sesión ---
  Future<String?> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return body['token'] as String?;
      } else {
        // El login falló (credenciales incorrectas, etc.)
        print('Error en el login: ${response.body}');
        return null;
      }
    } catch (e) {
      // Error de conexión (sin internet, etc.)
      print('Error de conexión: $e');
      return null;
    }
  }

  // --- Método para Registrar un Usuario ---
  Future<bool> register(String rut, String email, String password) async {
    final url = Uri.parse('$_baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'rut': rut, 'email': email, 'password': password}),
      );

      // 201 Created significa que el usuario se creó exitosamente
      return response.statusCode == 201;
    } catch (e) {
      print('Error de conexión al registrar: $e');
      return false;
    }
  }
}
