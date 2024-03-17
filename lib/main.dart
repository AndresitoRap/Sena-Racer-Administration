import 'package:flutter/material.dart';
import 'package:sena_racer_admin/adminhistory.dart';
import 'package:sena_racer_admin/error_404.dart';
import 'package:sena_racer_admin/home.dart';
import 'package:sena_racer_admin/login.dart';

// Función principal para iniciar la aplicación Flutter
void main() {
  runApp(MyApp());
}

// Clase MyApp que extiende StatelessWidget para representar la aplicación Flutter
class MyApp extends StatelessWidget {
  // Constructor de la clase MyApp
  MyApp({Key? key});

  // Mapa de rutas para la navegación en la aplicación
  final routes = {
    "/": (context) =>
        const Login(), // Ruta para la pantalla de inicio de sesión
    "/administración": (context) => const Home(),
    "/administración/supervisión": (context) => const AdminandHistory()
  };

  @override
  Widget build(BuildContext context) {
    // Retorna un MaterialApp que es la raíz de la aplicación Flutter
    return MaterialApp(
      // Título de la aplicación
      title: 'Sena Racer Administración',
      // Elimina el banner de depuración en la parte superior derecha
      debugShowCheckedModeBanner: false,
      // Tema de la aplicación
      theme: ThemeData(
        // Fuente de la aplicación
        fontFamily: "Itim",
        // Habilitar Material3
        useMaterial3: true,
        // Densidad visual adaptativa
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Ruta inicial de la aplicación
      initialRoute: "/",
      // Mapa de rutas de la aplicación
      routes: routes,
      // Generación de ruta en caso de que se solicite una ruta no definida
      onGenerateRoute: ((settings) {
        return MaterialPageRoute(builder: (context) => const Error());
      }),
    );
  }
}
