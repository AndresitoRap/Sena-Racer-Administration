import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sena_racer_admin/models/admins.dart';
import 'package:sena_racer_admin/models/history.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AdminandHistory extends StatelessWidget {
  const AdminandHistory({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromARGB(255, 43, 158, 20);

    List<Admin> admins = [];
    List<History> history = [];

    Future<List<Admin>> getAllAdmin() async {
      var response = await http.get(Uri.parse(
          "https://backend-strapi-senaracer.onrender.com/api/admins/"));

      if (response.statusCode == 200) {
        admins.clear();
      }

      Map<String, dynamic> decodedData = jsonDecode(response.body);
      Iterable adminsData = decodedData.values;

      for (var item in adminsData.elementAt(0)) {
        admins.add(
          Admin(
            item['id'],
            int.parse(item['attributes']['identification']),
            item['attributes']['password'],
            item['attributes']['name'] ?? 'No registrado',
            item['attributes']['lastname'] ?? 'No registrado',
            item['attributes']['email'] ?? 'No registrado',
            int.parse(item['attributes']['cellphone'] ?? 0.toString()),
          ),
        );
      }
      return admins;
    }

    Future<List<History>> getAllHistory() async {
      var response = await http.get(Uri.parse(
          "https://backend-strapi-senaracer.onrender.com/api/histories/"));

      if (response.statusCode == 200) {
        history.clear();
      }

      Map<String, dynamic> decodedData = jsonDecode(response.body);
      Iterable historydata = decodedData.values;

      for (var item in historydata.elementAt(0)) {
        history.add(History(
          item['id'],
          int.parse(item['attributes']['identification']),
          item['attributes']['admin'],
          item['attributes']['accion'],
          DateTime.parse(item['attributes']['hora']),
        ));
      }
      return history;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Supervisión",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text(
                    "Administradores",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: primaryColor,
                    ),
                  ),
                  FutureBuilder<List<Admin>>(
                    future: getAllAdmin(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: primaryColor,
                        ));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 110,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                dividerThickness: 1,
                                columns: const [
                                  DataColumn(
                                      label: Text(
                                    'Identificación',
                                    style: TextStyle(color: primaryColor),
                                  )),
                                  DataColumn(
                                      label: Text('Nombre',
                                          style:
                                              TextStyle(color: primaryColor))),
                                  DataColumn(
                                      label: Text('Apellido',
                                          style:
                                              TextStyle(color: primaryColor))),
                                  DataColumn(
                                      label: Text('Correo',
                                          style:
                                              TextStyle(color: primaryColor))),
                                  DataColumn(
                                      label: Text('Celular',
                                          style:
                                              TextStyle(color: primaryColor))),
                                ],
                                rows: snapshot.data!.map((data) {
                                  return DataRow(cells: [
                                    DataCell(
                                        Text(data.identification.toString())),
                                    DataCell(Text(data.name)),
                                    DataCell(Text(data.lastname)),
                                    DataCell(Text(data.email)),
                                    DataCell(Text(data.cellphone.toString())),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 7),
                    child: Text(
                      "Movimientos",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 400,
                    height: MediaQuery.of(context).size.height - 100,
                    child: FutureBuilder(
                      future: getAllHistory(),
                      builder:
                          (context, AsyncSnapshot<List<History>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No se encontraron movimientos'),
                          );
                        } else {
                          snapshot.data!
                              .sort((a, b) => b.hora.compareTo(a.hora));
                          return ListView.builder(
                            itemCount: snapshot.data!.reversed.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: primaryColor,
                                        offset: Offset(2, 2),
                                        blurRadius: 2,
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        snapshot.data![index].accion == "Subio"
                                            ? Icons
                                                .arrow_upward // Icono para "Subio"
                                            : Icons
                                                .arrow_downward, // Icono para "Elimino"
                                        color: snapshot.data![index].accion ==
                                                "Subio"
                                            ? Colors
                                                .green // Color verde para "Subio"
                                            : Colors
                                                .red, // Color rojo para "Elimino"
                                        size: 40,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.black12),
                                          width: 1,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text:
                                                          'El administrador identificado con C.C: ',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: "Itim",
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: snapshot
                                                          .data![index]
                                                          .identification
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: primaryColor,
                                                        fontFamily: "Itim",
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                      text: ' llamado: ',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: "Itim",
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: snapshot
                                                          .data![index].admin,
                                                      style: const TextStyle(
                                                        color: primaryColor,
                                                        fontFamily: "Itim",
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          ', ${snapshot.data![index].accion} corredores el día ',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: "Itim",
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: DateFormat(
                                                              'dd-MM-yyyy')
                                                          .format(snapshot
                                                              .data![index]
                                                              .hora),
                                                      style: const TextStyle(
                                                          color: primaryColor,
                                                          fontFamily: "Itim"),
                                                    ),
                                                    const TextSpan(
                                                      text: ' a la hora ',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: "Itim",
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          DateFormat('HH:mm:ss')
                                                              .format(snapshot
                                                                  .data![index]
                                                                  .hora),
                                                      style: const TextStyle(
                                                          color: primaryColor,
                                                          fontFamily: "Itim"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
