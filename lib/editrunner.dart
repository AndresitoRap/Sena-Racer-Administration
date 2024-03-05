import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sena_racer_admin/models/runners.dart';

class EditRunner extends StatefulWidget {
  final Runner runner; // Propiedad para contener el corredor a editar
  const EditRunner({Key? key, required this.runner}) : super(key: key);

  @override
  State<EditRunner> createState() => _EditRunnerState();
}

class _EditRunnerState extends State<EditRunner> {
  final Color primaryColor = const Color.fromARGB(255, 43, 158, 20);
  bool obscureText = true; // Booleano para ocultar o mostrar la contraseña

  // Método para mostrar u ocultar la contraseña
  void showPassword() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: widget.runner.name);
    TextEditingController identificationContoller =
        TextEditingController(text: widget.runner.identification.toString());

    return Scaffold(
      body: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 151, 255, 92),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.group,
                      color: Colors.white,
                      size: 100,
                    ),
                    const Row(
                      children: [
                        Text(
                          "Nombre Aprendiz",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextField(
                        controller: nameController,
                        onChanged: (val) {
                          nameController.value =
                              nameController.value.copyWith(text: val);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            Icons.person,
                          ),
                          hintText: "Andrés",
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const Row(
                      children: [
                        Text(
                          "Número de identificación",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextField(
                        controller: identificationContoller,
                        onChanged: (val) {
                          identificationContoller.value =
                              identificationContoller.value.copyWith(text: val);
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            Icons.badge,
                          ),
                          hintText: "1234567890",
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const Row(
                      children: [
                        Text(
                          "Contraseña",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TextField(
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: IconButton(
                              color: Colors.grey,
                              onPressed: showPassword,
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          hintText: "0987654321abc",
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    InkWell(
                      onTap: () {}, // Método para iniciar sesión
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryColor,
                        ),
                        child: const Text(
                          "Ingresar", // Texto del botón de inicio de sesión
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 23,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
