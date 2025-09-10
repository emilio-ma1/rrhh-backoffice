import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <--- 1. Importa SharedPreferences
import '../providers/theme_provider.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Sección de perfil de usuario
          const Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/user_avatar.png'),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nombre_Usuario',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('Cargo del empleado'),
                ],
              ),
            ],
          ),
          const Divider(height: 40),

          // Sección de tema
          Text(
            'Tema de la aplicación',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Tema del Sistema'),
            value: ThemeMode.system,
            groupValue: themeProvider.themeMode,
            onChanged: (value) => themeProvider.setTheme(value!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Tema Claro'),
            value: ThemeMode.light,
            groupValue: themeProvider.themeMode,
            onChanged: (value) => themeProvider.setTheme(value!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Tema Oscuro'),
            value: ThemeMode.dark,
            groupValue: themeProvider.themeMode,
            onChanged: (value) => themeProvider.setTheme(value!),
          ),

          const Divider(height: 40),

          // Botón de Cerrar Sesión
          ElevatedButton(
            // 2. Convierte la función a 'async' para poder usar 'await'
            onPressed: () async {
              // 3. Obtiene la instancia de SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              // 4. Borra el token guardado
              await prefs.remove('authToken');

              // 5. Navega a la pantalla de login y elimina todas las rutas anteriores
              // Es importante verificar si el widget sigue montado antes de navegar
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'CERRAR SESIÓN',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Acerca de nosotros'),
            onTap: () {
              // Lógica futura para mostrar información
            },
          ),
        ],
      ),
    );
  }
}
