import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sena_racer_admin/models/runners.dart';
import 'package:sena_racer_admin/models/score.dart';
import 'package:sena_racer_admin/models/time.dart';
import 'package:sena_racer_admin/responsive_widget.dart';
import 'package:http/http.dart' as http;

// Clase SearchBarDelegate que extiende SearchDelegate para proporcionar funcionalidad de búsqueda
class SearchBarDelegate extends SearchDelegate {
  // Color primario

  Future<List<Runner>> getAllRunners() async {
    final response =
        await http.get(Uri.parse("http://localhost:1337/api/runners/"));
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final runnersData =
          decodedData['data']; // Assuming 'data' contains the list of runners
      List<Runner> runnerList = [];
      for (var item in runnersData) {

        List<Time> runnerTimes = [];
        List<Score> runnerScores = [];

        var timesResponse = await http.get(Uri.parse(
            "https://backend-strapi-senaracer.onrender.com/api/tiempos/?runnerId=${item['id']}"));

        if (timesResponse.statusCode == 200) {
          final Map<String, dynamic> timesData = jsonDecode(timesResponse.body);
          final Iterable timeData = timesData.values;

          for (var timeItem in timeData.elementAt(0)) {
            runnerTimes.add(
              Time(
                timeItem['id'],
                timeItem['attributes']['time1'] ?? 0,
                timeItem['attributes']['time2'] ?? 0,
                timeItem['attributes']['time3'] ?? 0,
                timeItem['attributes']['time4'] ?? 0,
              ),
            );
          }
        }

        var scoresResponse = await http.get(Uri.parse(
            "https://backend-strapi-senaracer.onrender.com/api/scores/?runnerId=${item['id']}"));

        if (scoresResponse.statusCode == 200) {
          final Map<String, dynamic> scoresData =
              jsonDecode(scoresResponse.body);
          final Iterable scoreData = scoresData.values;

          for (var scoreItem in scoreData.elementAt(0)) {
            runnerScores.add(
              Score(
                scoreItem['id'],
                int.parse(scoreItem['attributes']['score1'] ?? 0),
                int.parse(scoreItem['attributes']['score2'] ?? 0),
                int.parse(scoreItem['attributes']['score3'] ?? 0),
                int.parse(scoreItem['attributes']['score4'] ?? 0),
              ),
            );
          }
        }
        
        runnerList.add(
          Runner(
            int.parse(item['id'].toString()),
            item['attributes']['name'],
            item['attributes']['lastname'],
            int.parse(item['attributes']['identification'].toString()),
            item['attributes']['password'],
            runnerTimes,
            runnerScores,
          ),
        );
      }
      return runnerList;
    } else {
      throw Exception('Failed to load runners');
    }
  }

  // Etiqueta para el campo de búsqueda
  @override
  String get searchFieldLabel => 'Buscar corredor';

  // Acciones del campo de búsqueda
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => {query = ""},
        icon: const Icon(Icons.clear),
      )
    ];
  }

  // Widget para el ícono de retroceso
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_ios),
    );
  }

  // Widget para mostrar los resultados de la búsqueda
  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
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
            final filteredRunners = snapshot.data!.where((runner) =>
                runner.name.toLowerCase().contains(query.toLowerCase()) ||
                runner.lastName.toLowerCase().contains(query.toLowerCase()) ||
                runner.identification.toString().contains(query) ||
                runner.password.toString().contains(query.toLowerCase()));
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveWidget.isSmallScreen(context) ? 2 : 4,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio:
                    ResponsiveWidget.isSmallScreen(context) ? 2 / 1 : 2 / 1,
              ),
              itemCount: filteredRunners.length,
              itemBuilder: (BuildContext context, int index) {
                return RunnersWidget(
                  filteredRunners: filteredRunners,
                  indexrunner: index,
                );
              },
            );
          }
        },
      ),
    );
  }

  // Widget para mostrar sugerencias durante la búsqueda
  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

class RunnersWidget extends StatefulWidget {
  const RunnersWidget({
    super.key,
    required this.filteredRunners,
    required this.indexrunner,
  });

  final Iterable<Runner> filteredRunners;
  final int indexrunner;

  @override
  State<RunnersWidget> createState() => _RunnersWidgetState();
}

class _RunnersWidgetState extends State<RunnersWidget> {
  final primaryColor = const Color.fromARGB(255, 43, 158, 20);
  @override
  Widget build(BuildContext context) {
    void deleteRunner(int index) async {
      await http.delete(
        Uri.parse(
            "http://localhost:1337/api/runners/${widget.filteredRunners.elementAt(index).id.toString()}"),
      );
      setState(() {
        widget.filteredRunners.elementAt;
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
      const String url = "http://localhost:1337/api/runners/";

      final Map<String, String> dataHeader = {
        "Acces-Control-Allow-Methods":
            "[GET, POST, PUT, DETELE, HEAD, OPTIONS]",
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
        widget.filteredRunners.elementAt;
      } else {}
    }

    void showEdit(int index) {
      final TextEditingController nameRunner = TextEditingController(
          text: widget.filteredRunners.elementAt(index).name);
      final TextEditingController lastnameRunner = TextEditingController(
          text: widget.filteredRunners.elementAt(index).lastName);
      final TextEditingController identificationRunner = TextEditingController(
          text: widget.filteredRunners
              .elementAt(index)
              .identification
              .toString());
      final TextEditingController passwordRunner = TextEditingController(
          text: widget.filteredRunners.elementAt(index).password);
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
                                runner: widget.filteredRunners.elementAt(index),
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
            padding: const EdgeInsets.symmetric(horizontal: 30),
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
                          "${widget.filteredRunners.elementAt(widget.indexrunner).name} ${widget.filteredRunners.elementAt(widget.indexrunner).lastName}",
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
                      widget.filteredRunners
                          .elementAt(widget.indexrunner)
                          .identification
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
                      widget.filteredRunners
                          .elementAt(widget.indexrunner)
                          .password,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
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
                    showEdit(widget.indexrunner);
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
                            "¿Estas seguro de eliminar al aprendiz\n #${widget.filteredRunners.elementAt(widget.indexrunner).id.toString()} ${widget.filteredRunners.elementAt(widget.indexrunner).name} ${widget.filteredRunners.elementAt(widget.indexrunner).lastName} \ncon documento ${widget.filteredRunners.elementAt(widget.indexrunner).identification.toString()}?",
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
                              child: const Text('No, deseo volver'),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                deleteRunner(widget.indexrunner);
                              },
                              child: const Text('Si, deseo eliminarlo'),
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
  }
}
