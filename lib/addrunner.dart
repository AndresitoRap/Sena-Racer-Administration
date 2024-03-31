import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sena_racer_admin/login.dart';
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
  final primaryColor = const Color.fromARGB(255, 43, 158, 20);
  int successfulCount = 0;
  int failedCount = 0;
  List<List<dynamic>> _data =
      []; // Lista para almacenar los datos del archivo CSV

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
    const String url =
        "https://backend-strapi-senaracer.onrender.com/api/runners/";

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from closing on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cargando..."),
          content: CircularProgressIndicator(
            color: primaryColor,
          ),
        );
      },
    );

    List<Map<String, String>> failedRunnersDetails =
        []; // Lista para almacenar los detalles de los corredores que fallaron
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
        var reason = "Error ${response.statusCode}: ${response.reasonPhrase}";
        // Manejo especial para algunos códigos de error comunes
        if (response.statusCode == 409) {
          // 409: Conflicto (por ejemplo, identificación duplicada)
          reason = "Identificación duplicada";
        }
        failedRunnersDetails.add({
          "name": runnerData[0].toString(),
          "identification": runnerData[2].toString(),
          "reason": reason,
        });
      }
    }
    registrarMovimiento(UserData.identification, UserData.nameAdmin, 'Subio');

    // ignore: use_build_context_synchronously
    Navigator.pop(context); // Cerrar el diálogo de carga

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                "Se subieron $successfulCount corredores",
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                "No se pudieron subir $failedCount corredores",
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          content: SizedBox(
            height: 200.0,
            width: 400,
            child: ListView.builder(
              itemCount: failedRunnersDetails.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("Nombre: ${failedRunnersDetails[index]['name']}"),
                  subtitle: Text(
                    "Identificación: ${failedRunnersDetails[index]['identification']}\n"
                    "Razón: ${failedRunnersDetails[index]['reason']}",
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cerrar',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteAllRunners() async {
    // Realiza una solicitud GET para obtener todos los corredores
    final response = await http.get(Uri.parse(
        "https://backend-strapi-senaracer.onrender.com/api/runners/"));

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      barrierDismissible: false, // Prevent dialog from closing on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cargando..."),
          content: CircularProgressIndicator(
            color: primaryColor,
          ),
        );
      },
    );

    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON para obtener los datos de los corredores
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey("data")) {
        final List<dynamic> runners = data["data"];

        // Itera sobre los corredores y envía una solicitud DELETE para cada uno
        bool allDeleted =
            true; // Bandera para verificar si todos los corredores se eliminaron correctamente
        for (var runner in runners) {
          final String runnerId = runner['id'].toString();
          final deleteResponse = await http.delete(Uri.parse(
              "https://backend-strapi-senaracer.onrender.com/api/runners/${runnerId.toString()}"));

          if (deleteResponse.statusCode != 200) {
            allDeleted = false;
            break; // Si falla la eliminación de algún corredor, sal del bucle
          }
        }
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Close the loading dialog
        if (allDeleted) {
          _showDialogadmin("Se eliminaron los corredores",
              "Se han eliminado todos los corredores");
        } else {
          _showDialogadmin(
              "Error al eliminar", "Error al eliminar los corredores");
        }
        registrarMovimiento(
            UserData.identification, UserData.nameAdmin, 'Elimino');
      } else {}
    } else {}
  }

  Future<void> registrarMovimiento(
      String identification, String admin, String accion) async {
    const String url =
        "https://backend-strapi-senaracer.onrender.com/api/histories/";

    final Map<String, dynamic> dataBody = {
      "identification": identification,
      "admin": admin,
      "accion": accion,
      "hora": DateTime.now().toString(),
    };

    final Map<String, String> dataHeader = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    await http.post(
      Uri.parse(url),
      headers: dataHeader,
      body: json.encode({'data': dataBody}),
    );
  }

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
    const String url =
        "https://backend-strapi-senaracer.onrender.com/api/runners/";

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
        // ignore: use_build_context_synchronously
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
                child: const Text(
                  "Aceptar",
                  style: TextStyle(
                    color: Color.fromARGB(255, 43, 158, 20),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      _showDialogadmin("Error", "Error al añadir el corredor");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Expanded(
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
                              padding: const EdgeInsets.symmetric(vertical: 10),
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
                                      DataColumn(
                                          label: Text('N°',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 43, 158, 20)))),
                                      DataColumn(
                                          label: Text('Nombre(s)',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 43, 158, 20)))),
                                      DataColumn(
                                          label: Text('Apellidos',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 43, 158, 20)))),
                                      DataColumn(
                                          label: Text('Identificación',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 43, 158, 20)))),
                                      DataColumn(
                                          label: Text('Contraseña',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 43, 158, 20)))),
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
                          "Actualmente hay ${_data.length} registros en el archivo .csv.\n",
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                                "¿Esta seguro de subir ${_data.length} corredores a la base de datos?"),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: primaryColor,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Volver'),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: primaryColor,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _uploadCSVtoStrapi();
                                },
                                child: const Text('Subir'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 185, 40, 30),
                    ),
                    child: const Text("Subir corredores"),
                  ),
                  const SizedBox(width: 5),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text(
                                "¿Esta seguro de eliminar a los corredores de la base de datos?"),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: primaryColor,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Volver'),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: primaryColor,
                                ),
                                onPressed: () {
                                  final TextEditingController passwordadmin =
                                      TextEditingController();

                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Escriba su contraseña para poder borrarlos."),
                                        content: TextField(
                                          controller: passwordadmin,
                                          onChanged: (val) {
                                            passwordadmin.value = passwordadmin
                                                .value
                                                .copyWith(text: val);
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Contraseña",
                                            floatingLabelStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor),
                                            hintText: "1234567890abc",
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: primaryColor,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          OutlinedButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor: primaryColor,
                                            ),
                                            onPressed: () {
                                              if (passwordadmin.text.isEmpty) {
                                                _showDialogadmin("Campo vacio",
                                                    "Debe escribir su contraseña");
                                              } else {
                                                if (passwordadmin.text ==
                                                    UserData.password) {
                                                  Navigator.of(context).pop();
                                                  deleteAllRunners();
                                                } else {
                                                  _showDialogadmin(
                                                    "Contraseña incorrecta",
                                                    "La contraseña que proporcionaste no es la que esta actualmente",
                                                  );
                                                }
                                              }
                                            },
                                            child: const Text('Borrar'),
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
                                },
                                child: const Text('Borrar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 185, 40, 30),
                    ),
                    child: const Text("Eliminar corredores"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
