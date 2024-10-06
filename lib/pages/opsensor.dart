// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, prefer_const_declarations, prefer_null_aware_operators, subtype_of_sealed_class, unused_local_variable

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart'; 
import 'dart:io';
import 'managedata.dart';

class SensorPage extends StatefulWidget {
  const SensorPage({super.key});

  @override
  _SensorPageState createState() => _SensorPageState();
}


class _SensorPageState extends State<SensorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Sensores',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Times New Roman',
              fontSize: 25,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              sensorButton(context, "TDS", Icons.opacity_rounded, 'tds'),
              const SizedBox(width: 25),
              sensorButton(context, "pH", Icons.science_outlined, 'ph'),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              sensorButton(context, "Radiação", Icons.wb_sunny_outlined, 'radiacao'),
              const SizedBox(width: 25),
              sensorButton(context, "Vazão", Icons.water_drop, 'vazao'),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              sensorButton(context, "Temp. Ar", Icons.thermostat, 'tempar'),
              const SizedBox(width: 25),
              sensorButton(context, "Temp. Liq", Icons.local_drink, 'templiq'),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              sensorButton(context, "Umidade", Icons.cloud_queue, 'umidade'),
              const SizedBox(width: 25),
              extractButton(context),  
            ],
          ),
        ],
      ),
    );
  }

  Widget extractButton(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size(145, 130),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              color: Color.fromARGB(255, 0, 50, 0),
              spreadRadius: 0.5,
              offset: Offset(3, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(60),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: Material(
            color: Colors.green,
            child: InkWell(
              splashColor: const Color.fromARGB(255, 0, 255, 0),
              onTap: () async {
                await _downloadSensorData();
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.download_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                  Text(
                    "Extrair",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
 

Future<void> _downloadSensorData() async {
  try {
    var excel = Excel.createExcel();

    // Criar a aba "Sheet1"
    Sheet sheet1 = excel['Sheet1'];
    sheet1.appendRow(['Bem-vindo ao arquivo de dados dos sensores! Aqui você encontrará dados organizados de maneira clara.']);
    sheet1.appendRow(['As próximas abas contêm dados de sensores separados e uma aba com todos os sensores consolidados. ']);
    sheet1.appendRow(['Os valores ausentes em algumas células indicam que houve um outlier ou que você ']);
    sheet1.appendRow(['gerenciou os dados por meio da opção de gerenciamento do aplicativo.']);

    // Criar a aba "Todos Sensores" como a segunda aba
    Sheet allSensorsSheet = excel['Todos Sensores'];
    allSensorsSheet.appendRow(['Data/Hora', 'TDS', 'pH', 'Radiação', 'Vazão', 'Temp. Ar', 'Temp. Liq.', 'Umidade']);

    // Exibir caixa de progresso
    ValueNotifier<double> progressNotifier = ValueNotifier<double>(0.0);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Gerando Excel"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<double>(
                valueListenable: progressNotifier,
                builder: (context, value, child) {
                  return Column(
                    children: [
                      LinearProgressIndicator(
                        value: value, // A barra de progresso vai de 0 a 1
                      ),
                      const SizedBox(height: 20),
                      Text("Progresso: ${((value * 100).toStringAsFixed(0))} %"),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );

    // Baixar os dados da coleção "allsensors"
    QuerySnapshot allSensorsSnapshot = await FirebaseFirestore.instance.collection('allsensors').get();
    
    int totalDocs = allSensorsSnapshot.docs.length;
    int processedDocs = 0;

    for (var doc in allSensorsSnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>; 
      
      var dataHora = (data['datahora'] as Timestamp).toDate().toString();
      var tds = data.containsKey('tds') ? double.parse(data['tds'].toString()).toStringAsFixed(1) : '';  
      var ph = data.containsKey('ph') ? double.parse(data['ph'].toString()).toStringAsFixed(1) : '';     
      var radiacao = data.containsKey('radiacao') ? double.parse(data['radiacao'].toString()).toStringAsFixed(1) : ''; 
      var vazao = data.containsKey('vazao') ? double.parse(data['vazao'].toString()).toStringAsFixed(1) : ''; 
      var tempar = data.containsKey('tempar') ? double.parse(data['tempar'].toString()).toStringAsFixed(1) : ''; 
      var templiq = data.containsKey('templiq') ? double.parse(data['templiq'].toString()).toStringAsFixed(1) : ''; 
      var umidade = data.containsKey('umidade') ? double.parse(data['umidade'].toString()).toStringAsFixed(1) : ''; 

      allSensorsSheet.appendRow([dataHora, tds, ph, radiacao, vazao, tempar, templiq, umidade]);
      
      // Atualizar o progresso
      processedDocs++;
      progressNotifier.value = (processedDocs / totalDocs) * 0.5; // Progresso de 0 a 0.5 para "allsensors"
    }

    // Baixar os dados das coleções separadas
    List<String> collections = ['tds', 'ph', 'radiacao', 'vazao', 'tempar', 'templiq', 'umidade'];
    Map<String, String> sensorNames = {
      'tds': 'TDS',
      'ph': 'pH',
      'radiacao': 'Radiacao',
      'vazao': 'Vazao',
      'tempar': 'Temp Ar',
      'templiq': 'Temp Liq',
      'umidade': 'Umidade'
    };

    int totalCollectionDocs = collections.length; // Total de coleções
    processedDocs = 0;

    for (var collectionName in collections) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(collectionName).get();

      Sheet sensorSheet = excel[sensorNames[collectionName]!];
      sensorSheet.appendRow(['Data/Hora', 'Medição']);

      int sensorDocsCount = snapshot.docs.length;

      for (var doc in snapshot.docs) {
        var dataHora = (doc['datahora'] as Timestamp).toDate().toString();
        var medicao = double.parse(doc['medicao'].toString()).toStringAsFixed(1);
        sensorSheet.appendRow([dataHora, medicao]);
      }

      // Atualizar o progresso
      processedDocs++;
      progressNotifier.value = (0.5 + (processedDocs / totalCollectionDocs) * 0.5); 
    }

    final directory = "/storage/emulated/0/Download";
    final path = "$directory/data_sensors.xlsx";

    final File file = File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    // Fechar a caixa de progresso
    Navigator.of(context).pop();

    // Notificar o usuário que o download foi concluído
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Arquivo Excel salvo em: $path"),
      backgroundColor: Colors.green,
    ));
  } catch (e) {
    // Exibir mensagem de erro em caso de falha
    Navigator.of(context).pop(); 
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Erro ao baixar dados: $e"),
      backgroundColor: Colors.red,
    ));
  }
}


  Widget sensorButton(BuildContext context, String label, IconData icon, String collectionName) {
    return SizedBox.fromSize(
      size: const Size(145, 130),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              color: Color.fromARGB(255, 0, 50, 0),
              spreadRadius: 0.5,
              offset: Offset(3, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(60),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: Material(
            color: Colors.green,
            child: InkWell(
              splashColor: const Color.fromARGB(255, 0, 255, 0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SensorDataPage(collectionName: collectionName),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 50,
                  ),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
