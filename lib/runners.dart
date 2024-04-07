import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sena_racer_admin/models/runners.dart';
import 'package:sena_racer_admin/responsive_widget.dart';
import 'package:http/http.dart'
    as http; // Importación para realizar solicitudes HTTP

class RunnersPage extends StatefulWidget {
  const RunnersPage({Key? key}) : super(key: key);

  @override
  State<RunnersPage> createState() => _RunnersPageState();
}

class _RunnersPageState extends State<RunnersPage> {
  final primaryColor = const Color.fromARGB(255, 43, 158, 20);

  List<Runner> runner = [];

  Future<List<Runner>> getAllRunners() async {
    var response = await http.get(Uri.parse(
        "https://backend-strapi-senaracer.onrender.com/api/runners/"));

    if (response.statusCode == 200) {
      runner.clear();
    }

    Map<String, dynamic> decodedData = jsonDecode(response.body);
    Iterable runnersData = decodedData.values;

    for (var item in runnersData.elementAt(0)) {
      
      runner.add(
        Runner(
          int.parse(item['id'].toString()),
          item['attributes']['name'],
          item['attributes']['lastname'],
          int.parse(item['attributes']['identification'].toString()),
          item['attributes']['password'],
          int.parse(item['attributes']['score1'].toString()),
          int.parse(item['attributes']['score2'].toString()),
          int.parse(item['attributes']['score3'].toString()),
          int.parse(item['attributes']['score4'].toString()),
          int.parse(item['attributes']['score5'].toString()),
          int.parse(item['attributes']['time1'].toString()),
          int.parse(item['attributes']['time2'].toString()),
          int.parse(item['attributes']['time3'].toString()),
          int.parse(item['attributes']['time4'].toString()),
          int.parse(item['attributes']['time5'].toString()),
        ),
      );
    }
    return runner;
  }

  void deleteRunner(int index) async {
    await http.delete(
      Uri.parse(
          "https://backend-strapi-senaracer.onrender.com/api/runners/${runner[index].id.toString()}"),
    );
    setState(() {
      runner.removeAt(index);
    });
  }

  void editRunner({
    required Runner runner,
    required String name,
    required String lastname,
    required int identification,
    required String password,
  }) async {
    @override
    const String url =
        "https://backend-strapi-senaracer.onrender.com/api/runners/";

    final Map<String, String> dataHeader = {
      "Acces-Control-Allow-Methods": "[GET, POST, PUT, DETELE, HEAD, OPTIONS]",
      "Content-Type": "application/json; charset=UTF-8",
    };
    final Map<String, dynamic> dataBody = {
      "name": name,
      "lastname": lastname,
      "identification": identification,
      "password": password,
    };

    final response = await http.put(
        Uri.parse(
          url + runner.id.toString(),
        ),
        headers: dataHeader,
        body: json.encode({"data": dataBody}));

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      setState(() {
        getAllRunners();
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    void showEdit(int index) {
      final TextEditingController nameRunner =
          TextEditingController(text: runner[index].name);
      final TextEditingController lastnameRunner =
          TextEditingController(text: runner[index].lastName);
      final TextEditingController identificationRunner =
          TextEditingController(text: runner[index].identification.toString());
      final TextEditingController passwordRunner =
          TextEditingController(text: runner[index].password);
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
                            "Editar corredor",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameRunner,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]+')),
                      ],
                      onChanged: (val) {
                        nameRunner.value = nameRunner.value.copyWith(text: val);
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
                      controller: identificationRunner,
                      onChanged: (val) {
                        identificationRunner.value =
                            identificationRunner.value.copyWith(text: val);
                      },
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
                      controller: passwordRunner,
                      onChanged: (val) {
                        passwordRunner.value =
                            passwordRunner.value.copyWith(text: val);
                      },
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        floatingLabelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: primaryColor),
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
                    const SizedBox(height: 4),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: FittedBox(
                            child: Text(
                              "Una vez guardado los cambios se evidenciaran al instante",
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
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  primaryColor)),
                          onPressed: () {
                            editRunner(
                                runner: runner[index],
                                name: nameRunner.text,
                                lastname: lastnameRunner.text,
                                identification:
                                    int.parse(identificationRunner.text),
                                password: passwordRunner.text);
                          },
                          child: const Text("Editar"),
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

    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 100,
        child: FutureBuilder(
          future: getAllRunners(),
          builder: (context, AsyncSnapshot<List<Runner>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 43, 158, 20)),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                ),
              );
            } else if (snapshot.data == null) {
              return const Center(
                child: Text('No se encontraron corredores.'),
              );
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      ResponsiveWidget.isSmallScreen(context) ? 1 : 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio:
                      ResponsiveWidget.isSmallScreen(context) ? 2 / 1 : 1.9,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        )
                      ],
                    ),
                    height: 80,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    "Nombre",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                        fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        "${snapshot.data![index].name} ${snapshot.data![index].lastName}",
                                        style: const TextStyle(fontSize: 18),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    "Identificación",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                        fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    snapshot.data![index].identification
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    "Contraseña",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                        fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    snapshot.data![index].password,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  showEdit(index);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: primaryColor,
                                        shadowColor: Colors.black,
                                        surfaceTintColor: Colors.black,
                                        content: Text(
                                          "¿Estas seguro de eliminar al aprendiz\n #${snapshot.data![index].id.toString()} ${snapshot.data![index].name} ${snapshot.data![index].lastName} \ncon documento ${snapshot.data![index].identification.toString()}?",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.blue,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child:
                                                const Text('No, deseo volver'),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.red,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              deleteRunner(index);
                                            },
                                            child: const Text(
                                                'Si, deseo eliminarlo'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
