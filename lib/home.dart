import 'package:flutter/material.dart';
import 'package:sena_racer_admin/addrunner.dart';
import 'package:sena_racer_admin/models/buttons_icons.dart';
import 'package:sena_racer_admin/models/searchbar.dart';
import 'package:sena_racer_admin/perfil.dart';
import 'package:sena_racer_admin/ranking.dart';
import 'package:sena_racer_admin/responsive_widget.dart';
import 'package:sena_racer_admin/runners.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
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
              ),
              const RunnersPage(), // Página de corredores
            ],
          );
        case 2:
          return const SizedBox(
            child: AddRunners(),
          );
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
                                      currentpage = index;
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
            Expanded(
              child: body(),
            ),
          ],
        ),
      ),
    );
  }
}
