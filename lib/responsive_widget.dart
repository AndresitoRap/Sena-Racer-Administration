import 'package:flutter/material.dart';

// Clase ResponsiveWidget que extiende StatelessWidget para crear un widget sensible al tamaño de la pantalla
class ResponsiveWidget extends StatelessWidget {
  // Widget para pantallas grandes
  final Widget largeScreen;
  // Widget opcional para pantallas medianas
  final Widget? mediumScreen;
  // Widget opcional para pantallas pequeñas
  final Widget? smallScreen;

  // Constructor de la clase ResponsiveWidget
  const ResponsiveWidget({
    Key? key,
    required this.largeScreen,
    this.mediumScreen,
    this.smallScreen,
  }) : super(key: key);

  // Método estático para verificar si la pantalla es pequeña (ancho menor a 900)
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 900;
  }

  // Método estático para verificar si la pantalla es grande (ancho mayor a 1200)
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  // Método build que construye el widget ResponsiveWidget
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Si el ancho máximo de las restricciones es mayor a 1200, se muestra el widget largeScreen
        if (constraints.maxWidth > 1200) {
          return largeScreen;
        }
        // Si hay un widget mediumScreen definido y el ancho máximo de las restricciones es menor o igual a 1200, se muestra el widget mediumScreen
        else if (mediumScreen != null && constraints.maxWidth <= 1200) {
          return mediumScreen!;
        }
        // Si hay un widget smallScreen definido y el ancho máximo de las restricciones es menor o igual a 900, se muestra el widget smallScreen
        else if (smallScreen != null && constraints.maxWidth <= 900) {
          return smallScreen!;
        }
        // Por defecto, se muestra el widget largeScreen
        else {
          return largeScreen;
        }
      },
    );
  }
}
