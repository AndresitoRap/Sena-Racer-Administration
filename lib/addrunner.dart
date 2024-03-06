import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sena_racer_admin/responsive_widget.dart';
import 'package:file_picker/file_picker.dart';

class AddRunners extends StatefulWidget {
  final int? id;
  const AddRunners({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  State<AddRunners> createState() => _AddRunnersState();
}

class _AddRunnersState extends State<AddRunners> {
  int successfulCount = 0;
  int failedCount = 0;
  List<List<dynamic>> _data =
      []; // Lista para almacenar los datos del archivo CSV

  // Método para cargar el archivo CSV seleccionado por el usuario
  void _loadCSV() {
    FilePicker.platform.pickFiles(
      // Utiliza la plataforma de FilePicker para seleccionar archivos
      type: FileType.custom, // Tipo de archivo personalizado
      allowedExtensions: [
        'csv'
      ], // Extensiones permitidas (solo CSV en este caso)
    ).then((result) {
      // Maneja el resultado de la selección del archivo
      if (result != null) {
        // Si se seleccionó un archivo
        final filePath =
            result.files.single.bytes; // Obtiene la ruta del archivo
        final csvData =
            utf8.decode(filePath!); // Decodifica los datos del archivo CSV
        List<List<dynamic>> listData = const CsvToListConverter()
            .convert(csvData); // Convierte los datos CSV a una lista de listas
        setState(() {
          _data =
              listData; // Actualiza los datos del estado con los datos del archivo CSV
        });
      }
    }).catchError((error) {});
  }

  Future<void> _uploadCSVtoStrapi() async {
    const String url = "https://backend-strapi-senaracer.onrender.com/api/runners/";

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from closing on tap outside
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Cargando..."),
          content: CircularProgressIndicator(),
        );
      },
    );

    for (var runnerData in _data) {
      final Map<String, String> dataBody = {
        "name": runnerData[0].toString(),
        "lastname": runnerData[1].toString(),
        "identification": runnerData[2].toString(),
        "password": runnerData[3].toString(),
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'data': dataBody}),
      );

      if (response.statusCode == 200) {
        successfulCount++;
      } else {
        failedCount++;
      }
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context); // Close the loading dialog

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Resultado"),
          content: Text(
            "Se subieron $successfulCount corredores exitosamente.\nNo se pudieron subir $failedCount corredores.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  final primaryColor = const Color.fromARGB(255, 43, 158, 20);

  late final TextEditingController nameRunner;
  late final TextEditingController lastnameRunner;
  late final TextEditingController identificationRunner;
  late final TextEditingController passwordRunner;

  @override
  void initState() {
    super.initState();
    nameRunner = TextEditingController();
    lastnameRunner = TextEditingController();
    identificationRunner = TextEditingController();
    passwordRunner = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    nameRunner.dispose();
    lastnameRunner.dispose();
    identificationRunner.dispose();
    passwordRunner.dispose();
  }

  Future<void> addRunner() async {
    const String url = "https://backend-strapi-senaracer.onrender.com/api/runners/";

    final Map<String, String> dataBody = {
      "name": nameRunner.text,
      "lastname": lastnameRunner.text,
      "identification": identificationRunner.text,
      "password": passwordRunner.text,
    };

    final Map<String, String> dataHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: dataHeader,
      body: json.encode({'data': dataBody}),
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Resultado"),
            content: const Text("El corredor se ha añadido correctamente."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Clear text fields after successful save
                  nameRunner.clear();
                  lastnameRunner.clear();
                  identificationRunner.clear();
                  passwordRunner.clear();
                },
                child: const Text("Aceptar"),
              ),
            ],
          );
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Error al añadir el corredor."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Aceptar"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 300,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  ResponsiveWidget.isSmallScreen(context)
                      ? const SizedBox()
                      : Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width - 600,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: -60,
                                  top: 30,
                                  child: Image.asset(
                                    "img/Sena_Cellphone.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  left: 10,
                                  top: 80,
                                  child: Image.asset(
                                    "img/Sena_Cellphone2.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color.fromARGB(255, 49, 49, 49),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              "Sena Racer",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Registra a nuevos usuarios para la carrera",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Container(
                                height: 1,
                                color: const Color.fromARGB(255, 49, 49, 49),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextField(
                                controller: nameRunner,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z\s]+')),
                                ],
                                onChanged: (val) {
                                  nameRunner.value =
                                      nameRunner.value.copyWith(text: val);
                                },
                                decoration: InputDecoration(
                                  labelText: "Nombre(s)",
                                  floatingLabelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
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
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextField(
                                controller: lastnameRunner,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z\s]+')),
                                ],
                                onChanged: (val) {
                                  lastnameRunner.value =
                                      lastnameRunner.value.copyWith(text: val);
                                },
                                decoration: InputDecoration(
                                  labelText: "Apellidos",
                                  floatingLabelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
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
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextField(
                                controller: identificationRunner,
                                onChanged: (val) {
                                  identificationRunner.value =
                                      identificationRunner.value
                                          .copyWith(text: val);
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  labelText: "Identificación",
                                  floatingLabelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                  hintText: "1234567890",
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
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextField(
                                controller: passwordRunner,
                                onChanged: (val) {
                                  passwordRunner.value =
                                      passwordRunner.value.copyWith(text: val);
                                },
                                decoration: InputDecoration(
                                  labelText: "Contraseña",
                                  floatingLabelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                  hintText: "afcuevas@misena.edu.co",
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
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: OutlinedButton(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                          side: MaterialStateProperty.all<
                                              BorderSide>(
                                            BorderSide(color: primaryColor),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            primaryColor,
                                          ),
                                        ),
                                        onPressed: addRunner,
                                        child: const Text("Añadir"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 300,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black,
                            height: 1,
                          ),
                        ),
                        Text(
                          "¿Deseas registrar más de un corredor?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontSize: 30,
                          ),
                        ),
                        const Text(
                            "Para poder hacerlo deberas subir tú archivo tipo .CSV con los formatos requeridos: -nombre(s), -apellidos, -identificación(1234567890'), -contraseña(abc@abc.com)"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 300,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: TextButton(
                                  onPressed: _loadCSV,
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blue),
                                  child: const Text("Subir Archivo"),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 300,
                                height: MediaQuery.of(context).size.height,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columns: const [
                                        DataColumn(label: Text('N°')),
                                        DataColumn(label: Text('Nombre(s)')),
                                        DataColumn(label: Text('Apellidos')),
                                        DataColumn(
                                            label: Text('Identificación')),
                                        DataColumn(label: Text('Contraseña')),
                                      ],
                                      rows: _data.asMap().entries.map((entry) {
                                        final int index = entry.key;
                                        final List<dynamic> data = entry.value;
                                        return DataRow(
                                          cells: [
                                            DataCell(
                                                Text((index + 1).toString())),
                                            DataCell(Text(data[0].toString())),
                                            DataCell(Text(data[1].toString())),
                                            DataCell(Text(data[2].toString())),
                                            DataCell(Text(data[3].toString())),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Actualmente va a subir ${_data.length} registros a la base de datos.\n¿Está seguro? Esta acción ya no tiene marcha atrás.",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _uploadCSVtoStrapi,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 185, 40, 30),
                      ),
                      child: const Text("Estoy seguro"),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
