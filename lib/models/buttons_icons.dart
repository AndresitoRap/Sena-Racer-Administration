import 'package:flutter/material.dart';

// Definición de la clase ButtonIcons
class ButtonIcons {
  final IconData unselected; // Icono no seleccionado
  final IconData selected; // Icono seleccionado
  final String name; // Nombre del botón

  // Constructor de la clase ButtonIcons
  ButtonIcons({
    required this.selected, // Icono seleccionado requerido al crear una instancia
    required this.unselected, // Icono no seleccionado requerido al crear una instancia
    required this.name, // Nombre del botón requerido al crear una instancia
  });
}

// Lista de objetos ButtonIcons
List<ButtonIcons> buttonIcons = [
  ButtonIcons(
    selected: Icons.analytics, // Icono seleccionado: analytics
    unselected:
        Icons.analytics_outlined, // Icono no seleccionado: analytics_outlined
    name: "Estadísticas", // Nombre del botón: Estadísticas
  ),
  ButtonIcons(
    selected: Icons.person_search, // Icono seleccionado: person_add_alt_1
    unselected: Icons
        .person_search_outlined, // Icono no seleccionado: person_add_alt_1_outlined
    name: "Corredores", // Nombre del botón: Corredores
  ),
  ButtonIcons(
    selected: Icons.person_add, // Icono seleccionado: person_add_alt_1
    unselected: Icons
        .person_add_alt_outlined, // Icono no seleccionado: person_add_alt_1_outlined
    name: "Administrar", // Nombre del botón: Corredores
  ),
  ButtonIcons(
    selected: Icons.account_circle, // Icono seleccionado: person_add_alt_1
    unselected: Icons
        .account_circle_outlined, // Icono no seleccionado: person_add_alt_1_outlined
    name: "Cuenta", // Nombre del botón: Corredores
  ),
];
