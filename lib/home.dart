import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sena_racer_admin/addrunner.dart';
import 'package:sena_racer_admin/models/buttons_icons.dart';
import 'package:sena_racer_admin/models/searchbar.dart';
import 'package:sena_racer_admin/perfil.dart';
import 'package:sena_racer_admin/ranking.dart';
import 'package:sena_racer_admin/responsive_widget.dart';
import 'package:sena_racer_admin/runners.dart';
import 'package:http/http.dart' as http;

// Clase Home que extiende StatefulWidget para representar la pantalla principal de la aplicación
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

// Clase _HomeState que extiende State<Home> para manejar el estado de la pantalla principal
class _HomeState extends State<Home> {
  final primaryColor = const Color.fromARGB(255, 43, 158, 20);
  int currentpage = 0; // Índice de la página actual

  final TextEditingController identificationController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _addAdmin(BuildContext context) async {
    final url = Uri.parse('https://backend-strapi-senaracer.onrender.com/api/admins');

    final response = await http.post(
      url,
      body: json.encode({
        'data': {
          'identification': identificationController.text,
          'password': passwordController.text,
          'name': nameController.text,
          'lastname': lastnameController.text,
          'email': emailController.text,
          'cellphone': cellphoneController.text,
        },
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      _showDialogadmin(
          "Felicidades", "El administrador ha sido correctamente añadido");
    } else if (response.statusCode == 400) {
      _showDialogadmin("Error 400",
          "No se ha podido añadir por la respueta del servidor: ${response.body}");
    } else {
      _showDialogadmin("Error desconocido",
          "Error al añadirlo, más información: ${response.body}");
    }
  }

  void _showDialogadmin(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showAddAdmin() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        Text(
                          "Añadir Administrador",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: identificationController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: "Identificación",
                      floatingLabelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor),
                      hintText: "1234567890",
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )),
                    ),
                  ),
                  const SizedBox(height: 3),
                  TextField(
                    controller: nameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]+')),
                    ],
                    decoration: InputDecoration(
                      labelText: "Nombre(s)",
                      floatingLabelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor),
                      hintText: "Andy",
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  TextField(
                    controller: lastnameController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]+')),
                    ],
                    decoration: InputDecoration(
                      labelText: "Apellidos",
                      floatingLabelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor),
                      hintText: "Cuevas",
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  TextField(
                    controller: cellphoneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: "Celular",
                      floatingLabelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor),
                      hintText: "3001234567",
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Correo",
                      floatingLabelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor),
                      hintText: "andy@misena.edu.co",
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      floatingLabelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor),
                      hintText: "1234567890abc",
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: FittedBox(
                          child: Text(
                            "Verifica bien los datos del nuevo administrador",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: OutlinedButton(
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 255, 255, 255)),
                            side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(color: primaryColor),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(primaryColor)),
                        onPressed: () {
                          if (identificationController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty &&
                              nameController.text.isNotEmpty &&
                              lastnameController.text.isNotEmpty &&
                              emailController.text.isNotEmpty &&
                              cellphoneController.text.isNotEmpty) {
                            _addAdmin(context);
                          } else {
                            // Muestra una alerta o realiza alguna acción indicando que los campos están incompletos
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Campos incompletos'),
                                  content: const Text(
                                      'Por favor, completa todos los campos antes de continuar.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Cierra el diálogo
                                      },
                                      child: const Text('Aceptar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text("Crear"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Método para construir el contenido principal de la pantalla
    Widget body() {
      switch (currentpage) {
        case 0:
          return const Ranking(); // Página de clasificación
        case 1:
          return Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.groups,
                    color: primaryColor,
                    size: 50,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "Corredores", // Título de la página de corredores
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate:
                              SearchBarDelegate()); // Mostrar barra de búsqueda
                    },
                    icon: Icon(
                      Icons.search,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const RunnersPage(), // Página de corredores
            ],
          );
        case 2:
          return const AddRunners();
        case 3:
          return const Perfil();
        default:
          return const Center(
            child: Text(
              'Ah ocurrido un error', // Mensaje de error
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
              ),
            ),
          );
      }
    }

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ResponsiveWidget.isSmallScreen(context)
                ? Row(
                    children: [
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                "img/BSena_Racer.png", // Imagen del logo
                                width: 80,
                                height: 80,
                              ),
                              ...List.generate(
                                buttonIcons.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentpage =
                                          index; // Cambiar la página actual
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        currentpage == index
                                            ? buttonIcons[index].selected
                                            : buttonIcons[index].unselected,
                                        size: 35,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Image.asset(
                                    "img/BSena_Racer.png", // Imagen del logo
                                    width: 80,
                                    height: 80,
                                  ),
                                  Text(
                                    "SENA RACER", // Texto del título
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                ],
                              ),
                              ...List.generate(
                                buttonIcons.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentpage =
                                          index; // Cambiar la página actual
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            currentpage == index
                                                ? buttonIcons[index].selected
                                                : buttonIcons[index].unselected,
                                            color: Colors.black,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                              bottom: 15,
                                              top: 15,
                                            ),
                                            child: Text(
                                              buttonIcons[index].name,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: 2, // Ancho de la línea vertical
                color: Colors.black, // Color de la línea vertical
              ),
            ),
            SizedBox(
              // Agregar un Expanded alrededor de body() para ocupar el espacio restante
              child: body(),
            ),
          ],
        ),
      ),
    );
  }
}
