import 'package:flutter/material.dart';

// Clase Error que extiende StatelessWidget para representar una pantalla de error
class Error extends StatelessWidget {
  // Constructor de la clase Error
  const Error({Key? key}) : super(key: key);

  // Método build para construir la interfaz de usuario de la pantalla de error
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono de error
            const Icon(
              Icons.error_outline,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 20), // Espacio entre elementos
            // Título de error
            const Text(
              "¡Oops!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10), // Espacio entre elementos
            // Mensaje de error
            const Text(
              "Algo salió mal.",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30), // Espacio entre elementos
            // Botón para volver atrás
            InkWell(
              onTap: () {
                Navigator.pop(context); // Cierra la pantalla actual
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 10), // Espaciado interno del contenedor
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      20), // Borde redondeado del contenedor
                  color: const Color.fromARGB(
                      255, 43, 158, 20), // Color de fondo del contenedor
                ),
                child: const Text(
                  "Volver", // Texto del botón
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white), // Estilo del texto del botón
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
