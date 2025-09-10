import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_container_screen.dart';
import '../services/auth_service.dart'; // Asegúrate de que la ruta a tu servicio sea correcta

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers para leer el texto de los campos
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Instancia de nuestro servicio de autenticación
  final AuthService _authService = AuthService();

  // Variable para manejar el estado de carga
  bool _isLoading = false;

  /// Método para manejar el proceso de login
  Future<void> _login() async {
    // Si ya está cargando, no hacer nada
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Llama al servicio para intentar iniciar sesión
    final token = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    // Es importante verificar si el widget sigue "montado" antes de navegar
    if (!mounted) return;

    if (token != null) {
      // Éxito: Guardar el token y navegar a la pantalla principal
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeContainerScreen()),
      );
    } else {
      // Error: Mostrar un mensaje al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Email o contraseña incorrectos.'),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    // Limpiar los controllers cuando el widget se destruye para liberar memoria
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo
          Image.asset(
            'assets/images/background_login.jpg', // Cambia por tu imagen de login
            fit: BoxFit.cover,
            // Añadir un filtro de color para oscurecer la imagen si es muy clara
            color: Colors.black.withOpacity(0.4),
            colorBlendMode: BlendMode.darken,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bienvenido a',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  const Text(
                    'Putnik',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Campo de Email
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Campo de Contraseña
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Botón de Iniciar Sesión o Indicador de Carga
                  SizedBox(
                    width: double.infinity,
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: _login, // Llama a la función de login
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 15),
                  // Botón de Crear Cuenta
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implementar navegación a la pantalla de registro
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Crear cuenta',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
