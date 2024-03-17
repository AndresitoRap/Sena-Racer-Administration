import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sena_racer_admin/login.dart';
import 'package:http/http.dart' as http;
import 'package:sena_racer_admin/models/admins.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final primaryColor = const Color.fromARGB(255, 43, 158, 20);

  List<Admin> admin = [];

  final TextEditingController identificationController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _addAdmin(BuildContext context) async {
    final url =
        Uri.parse('https://backend-strapi-senaracer.onrender.com/api/admins');

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

  Future<void> changePassword(
      {required UserData userData, required String password}) async {
    @override
    const String url =
        "https://backend-strapi-senaracer.onrender.com/api/admins/";

    final Map<String, String> dataHeader = {
      "Acces-Control-Allow-Methods": "[GET, POST, PUT, DETELE, HEAD, OPTIONS]",
      "Content-Type": "application/json; charset=UTF-8",
    };
    final Map<String, dynamic> dataBody = {'password': password};

    final response = await http.put(
      Uri.parse(
        url + UserData.id.toString(),
      ),
      headers: dataHeader,
      body: json.encode(
        {"data": dataBody},
      ),
    );
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      _showDialogadmin('Se ha modificado la contraseña',
          'Se ha cambiado la contraseña de su usuario');
    } else if (response.statusCode == 400) {
      _showDialogadmin('Error', 'Error número ${response.statusCode}');
    } else {
      _showDialogadmin('Error Desconocido', 'Error: ${response.reasonPhrase}');
    }
  }

  void showPasswordDialog() {
    final TextEditingController passwordCurrent = TextEditingController();
    final TextEditingController newpassword = TextEditingController();
    final TextEditingController newpasswordconfirmation =
        TextEditingController();
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
                      const Text(
                        "Cambiar contraseña",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordCurrent,
                    onChanged: (val) {
                      passwordCurrent.value =
                          passwordCurrent.value.copyWith(text: val);
                    },
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      floatingLabelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor),
                      hintText: "1234567890abc",
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
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: newpassword,
                    onChanged: (val) {
                      newpassword.value = newpassword.value.copyWith(text: val);
                    },
                    decoration: InputDecoration(
                      labelText: "Nueva contraseña",
                      floatingLabelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor),
                      hintText: "1234567890abc",
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
                  const SizedBox(height: 4),
                  TextField(
                    controller: newpasswordconfirmation,
                    onChanged: (val) {
                      newpasswordconfirmation.value =
                          newpasswordconfirmation.value.copyWith(text: val);
                    },
                    decoration: InputDecoration(
                      labelText: "Confirmar contraseña",
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
                ],
              ),
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
              onPressed: () {
                if (passwordCurrent.text.isEmpty ||
                    newpassword.text.isEmpty ||
                    newpasswordconfirmation.text.isEmpty) {
                  _showDialogadmin("Campos Vacios",
                      "Debes llenar todos los campos para continuar");
                } else {
                  if (passwordCurrent.text == UserData.password) {
                    if (newpassword.text == newpasswordconfirmation.text) {
                      changePassword(
                        userData: UserData(),
                        password: newpasswordconfirmation.text,
                      );
                    } else {
                      _showDialogadmin("Error", "Contraseñan no coinciden");
                    }
                  } else {
                    _showDialogadmin(
                      "Contraseña incorrecta",
                      "La contraseña que proporcionaste no es la que esta actualmente",
                    );
                  }
                }
              },
              child: const Text('Cambiar'),
            ),
            const SizedBox(width: 5),
            OutlinedButton(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Volver'),
            ),
          ],
        );
      },
    );
  }

  Future<void> editAdminDates({
    required UserData userData,
    required String name,
    required String lastname,
    required String email,
    required int cellphone,
  }) async {
    @override
    const String url =
        "https://backend-strapi-senaracer.onrender.com/api/admins/";

    final Map<String, String> dataHeader = {
      "Acces-Control-Allow-Methods": "[GET, POST, PUT, DETELE, HEAD, OPTIONS]",
      "Content-Type": "application/json; charset=UTF-8",
    };
    final Map<String, dynamic> dataBody = {
      'name': name,
      'lastname': lastname,
      'email': email,
      'cellphone': cellphone,
    };

    final response = await http.put(
        Uri.parse(
          url + UserData.id.toString(),
        ),
        headers: dataHeader,
        body: json.encode({"data": dataBody}));

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      _showDialogadmin('Se han modificado los datos',
          'La operación se realizo con exito, se han cambiado los datos');
    } else if (response.statusCode == 400) {
      _showDialogadmin('Error', 'Error número ${response.statusCode}');
    } else {
      _showDialogadmin('Error Desconocido', 'Error: ${response.reasonPhrase}');
    }
  }

  Future<void> _logout(BuildContext context) async {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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

  void showEdit() {
    final TextEditingController nameAdmin =
        TextEditingController(text: UserData.nameAdmin);
    final TextEditingController lastnameAdmin =
        TextEditingController(text: UserData.lastname);
    final TextEditingController emailAdmin =
        TextEditingController(text: UserData.email);
    final TextEditingController cellphoneAdmin =
        TextEditingController(text: UserData.cellphone.toString());

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
                          "Editar datos",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameAdmin,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]+')),
                    ],
                    onChanged: (val) {
                      nameAdmin.value = nameAdmin.value.copyWith(text: val);
                    },
                    decoration: InputDecoration(
                      labelText: "Nombre(s)",
                      floatingLabelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor),
                      hintText: "Andy",
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
                    controller: lastnameAdmin,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]+')),
                    ],
                    onChanged: (val) {
                      lastnameAdmin.value =
                          lastnameAdmin.value.copyWith(text: val);
                    },
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
                    controller: emailAdmin,
                    onChanged: (val) {
                      emailAdmin.value = emailAdmin.value.copyWith(text: val);
                    },
                    decoration: InputDecoration(
                      labelText: "Correo",
                      floatingLabelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor),
                      hintText: "afcuevas@misena.edu.co",
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
                  TextField(
                    controller: cellphoneAdmin,
                    onChanged: (val) {
                      cellphoneAdmin.value =
                          cellphoneAdmin.value.copyWith(text: val);
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: "Celular",
                      floatingLabelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: primaryColor),
                      hintText: "300 300 3000",
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
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: FittedBox(
                          child: Text(
                            "Los datos se visualizaran una vez cerrado sesión y vuelto a iniciar",
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
                          if (nameAdmin.text.isEmpty ||
                              lastnameAdmin.text.isEmpty ||
                              emailAdmin.text.isEmpty ||
                              cellphoneAdmin.text.isEmpty) {
                            _showDialogadmin('Error',
                                'Debe llenar todos los campos para continuar');
                            return; // Detener la ejecución de la función si hay campos vacíos
                          } else {
                            editAdminDates(
                                userData: UserData(),
                                name: nameAdmin.text,
                                lastname: lastnameAdmin.text,
                                email: emailAdmin.text,
                                cellphone: int.parse(cellphoneAdmin.text));
                          }
                          Navigator.of(context).pop;
                        },
                        child: const Text("Actualizar"),
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
    String maskPassword(String password) {
      return '*' * password.length;
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width - 300,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Flexible(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "Bienvenido Administrador ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        UserData.nameAdmin.toUpperCase() != 'null'
                            ? UserData.nameAdmin.toUpperCase()
                            : "",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  const Flexible(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "C.C. - ",
                        style: TextStyle(fontSize: 27),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        UserData.identification,
                        style: TextStyle(fontSize: 27, color: primaryColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          return primaryColor; // primaryColor debe ser de tipo Color
                        },
                      ),
                    ),
                    onPressed: () {
                      showEdit();
                    },
                    child: const Text("Actualizar datos"),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          return primaryColor; // primaryColor debe ser de tipo Color
                        },
                      ),
                    ),
                    onPressed: () {
                      showPasswordDialog();
                    },
                    child: const Text("Cambiar contraseña"),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          return primaryColor; // primaryColor debe ser de tipo Color
                        },
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/administración/supervisión');
                    },
                    child: const Text("Supervisión"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                height: 1,
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: const Color.fromARGB(255, 238, 255, 235),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor,
                      offset: const Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "Número de identificación: ${UserData.identification}",
                                  style: const TextStyle(fontSize: 20),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: Container(
                          height: 2,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(136, 110, 110, 110),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "Nombre(s): ${UserData.nameAdmin != 'null' ? UserData.nameAdmin : ""}",
                                  style: const TextStyle(fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: Container(
                          height: 2,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(136, 110, 110, 110),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "Apellidos: ${UserData.lastname != 'null' ? UserData.lastname : ""}",
                                  style: const TextStyle(fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: Container(
                          height: 2,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(136, 110, 110, 110),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "Correo: ${UserData.email != 'null' ? UserData.email : ""}",
                                  style: const TextStyle(fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: Container(
                          height: 2,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(136, 110, 110, 110),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "Celular: ${UserData.cellphone != 'null' ? UserData.cellphone : ""}",
                                  style: const TextStyle(fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: Container(
                          height: 2,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(136, 110, 110, 110),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  "Contraseña: ${maskPassword(UserData.password)}",
                                  style: const TextStyle(fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: 1,
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          return primaryColor; // primaryColor debe ser de tipo Color
                        },
                      ),
                    ),
                    onPressed: () {
                      showAddAdmin();
                    },
                    child: const Text('Añadir Administrador'),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          return primaryColor; // primaryColor debe ser de tipo Color
                        },
                      ),
                    ),
                    onPressed: () {
                      _logout(context);
                    },
                    child: const Text("Cerrar Sesión"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
