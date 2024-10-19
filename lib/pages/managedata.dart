// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SensorDataPage extends StatefulWidget {
  final String collectionName;

  const SensorDataPage({super.key, required this.collectionName});

  @override
  _SensorDataPageState createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Dados do Sensor',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Times New Roman',
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      body: StreamBuilder(
        stream: db.collection(widget.collectionName).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Nenhum dado encontrado"));
          }

          var docs = snapshot.data!.docs;

          return ScrollbarTheme(
            data: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(Colors.green),),
              child: Scrollbar(
              thumbVisibility: true,
              thickness: 8,
              radius: const Radius.circular(4),
              scrollbarOrientation: ScrollbarOrientation.right,
              interactive: true,
              child: ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  var doc = docs[index];
                  DateTime dateTime = DateTime.parse(doc['datahora'].toDate().toString());
                  String formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
                  double value = double.parse(doc['medicao'].toString());
                  String unidade;

                  if (widget.collectionName == 'tds') {
                    unidade = 'mg/l';
                  } else if (widget.collectionName == 'ph') {
                    unidade = 'pH';
                  } else if (widget.collectionName == 'radiacao') {
                    unidade = 'W/m²';
                  } else if (widget.collectionName == 'vazao') {
                    unidade = 'L/min';
                  } else if (widget.collectionName == 'tempar') {
                    unidade = 'ºC';
                  } else if (widget.collectionName == 'templiq') {
                    unidade = 'ºC';
                  } else if (widget.collectionName == 'umidade') {
                    unidade = '%';
                  } else {
                    unidade = '';
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 175, 226, 175),
                        border: Border.all(
                          color: Colors.green.shade900,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                        title: Text(
                          formattedDate,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900),
                        ),
                        subtitle: Text(
                          "${value.toStringAsFixed(1)} $unidade",
                          style: const TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            // Excluir o documento da coleção específica do sensor
                            await db.collection(widget.collectionName).doc(doc.id).delete();

                            // Buscar o documento correspondente na coleção 'allsensors' baseado na mesma data e hora
                            DateTime dateTime = doc['datahora'].toDate().toUtc();
                            String formattedDateTime = "${dateTime.toIso8601String().split('.').first}Z";
                            String documentId = "AllSensors_$formattedDateTime";

                            DocumentReference allSensorsRef = db.collection('allsensors').doc(documentId);

                            // Verificar se o documento existe em 'allsensors'
                            DocumentSnapshot snapshot = await allSensorsRef.get();
                            if (snapshot.exists) {
                              await allSensorsRef.update({widget.collectionName: FieldValue.delete()});

                              // Verificar se o documento ainda tem outros campos, caso contrário, excluí-lo completamente
                              if ((snapshot.data() as Map<String, dynamic>).length == 1) {
                                await allSensorsRef.delete();
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
