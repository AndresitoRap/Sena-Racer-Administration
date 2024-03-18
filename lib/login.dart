import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sena_racer_admin/responsive_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserData {
  static String nameAdmin = '';
  static String identification = '';
  static String lastname = '';
  static String email = '';
  static String cellphone = '';
  static String password = '';
  static int id = 0;
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Color primaryColor = const Color.fromARGB(255, 43, 158, 20);
  bool obscureText = true;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void showPassword() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Future<void> _login() async {
    final String identification = _idController.text.trim();
    final String password = _passwordController.text.trim();

    if (identification.isNotEmpty && password.isNotEmpty) {
      try {
        var response = await http.get(
          Uri.parse('https://backend-strapi-senaracer.onrender.com/api/admins'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
        );

        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['data'].isNotEmpty) {
          var userData = jsonResponse['data'].firstWhere(
            (user) => user['attributes']['identification'] == identification,
            orElse: () => null,
          );

          if (userData != null) {
            String adminPassword = userData['attributes']['password'];
            UserData.id = userData['id'];
            UserData.identification = identification;
            UserData.nameAdmin = userData['attributes']['name'] ?? ' ';
            UserData.lastname = userData['attributes']['lastname'] ?? ' ';
            UserData.email = userData['attributes']['email'] ?? ' ';
            UserData.cellphone = userData['attributes']['cellphone'] ?? ' ';
            UserData.password = userData['attributes']['password'] ?? ' ';
            

            if (password == adminPassword) {
              // ignore: use_build_context_synchronously
              Navigator.pushNamed(context, '/administración');
            } else {
              _showErrorDialog(
                'Error de autenticación',
                'La contraseña proporcionada es incorrecta.',
              );
            }
          } else {
            _showErrorDialog(
              'Error de autenticación',
              'Usuario no encontrado.',
            );
          }
        } else {
          _showErrorDialog(
            'Error de autenticación',
            'No hay usuarios registrados.',
          );
        }
      } catch (e) {
        _showErrorDialog(
          'Error',
          'Ocurrió un error durante la autenticación: $e',
        );
      }
    } else {
      _showErrorDialog(
        'Campos Vacíos',
        'Por favor, complete todos los campos.',
      );
    }
  }

  void _showErrorDialog(String title, String message) {
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

  @override
  Widget build(BuildContext context) {
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
                ? const SizedBox()
                : Expanded(
                    child: Container(
                      color: primaryColor,
                      height: height,
                      child: Center(
                        child: Image.asset("img/BSena_Racer.png"),
                      ),
                    ),
                  ),
            Expanded(
              child: Container(
                color: Colors.white,
                height: height,
                margin: EdgeInsets.symmetric(horizontal: height * 0.080),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.145,
                    ),
                    Row(
                      children: [
                        const Text(
                          "¿Listo para ",
                          style: TextStyle(fontSize: 25),
                        ),
                        Text(
                          "Administrar?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "Solo podrán administrar las\rpersonas autorizadas.",
                      ),
                    ),
                    SizedBox(
                      height: height * 0.064,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text("Número de identificación"),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: height * 0.001),
                      width: width,
                      child: TextField(
                        controller: _idController,
                        onSubmitted: (_) => _login(),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person,
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
                    SizedBox(height: height * 0.050),
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text("Contraseña"),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: height * 0.001),
                      width: width,
                      child: TextField(
                        controller: _passwordController,
                        onSubmitted: (_) => _login(),
                        obscureText: obscureText,
                        decoration: InputDecoration(
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
                    SizedBox(height: height * 0.050),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      onPressed: _login,
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                        child: Text(
                          "Ingresar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 23,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
