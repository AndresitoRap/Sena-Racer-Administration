import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sena_racer_admin/models/admins.dart';
import 'package:http/http.dart' as http;

class AdminandHistory extends StatelessWidget {
  const AdminandHistory({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromARGB(255, 43, 158, 20);

    List<Admin> admins = [];

    Future<List<Admin>> getAllAdmin() async {
      var response = await http.get(Uri.parse(
          "https://backend-strapi-senaracer.onrender.com/api/admins/"));

      if (response.statusCode == 200) {
        admins.clear();
      }

      Map<String, dynamic> decodedData = jsonDecode(response.body);
      Iterable runnersData = decodedData.values;

      for (var item in runnersData.elementAt(0)) {
        admins.add(
          Admin(
            item['id'],
            item['attributes']['identification'],
            item['attributes']['password'],
            item['attributes']['name'],
            item['attributes']['lastname'],
            item['attributes']['email'],
            item['attributes']['cellphone'],
          ),
        );
      }
      return admins;
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
  body: FutureBuilder<List<Admin>>(
    future: getAllAdmin(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.data == null || snapshot.data!.isEmpty) {
        return const Center(child: Text('No se encontraron administradores.'));
      } else {
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final admin = snapshot.data![index];
            return ListTile(
              title: Text('Identification: ${admin.identification}'),
              subtitle: Text('Name: ${admin.name}, Email: ${admin.email}'),
            );
          },
        );
      }
    },
  ),
);

  }
}
