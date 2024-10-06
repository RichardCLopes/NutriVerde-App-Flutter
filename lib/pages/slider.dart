// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:nutriverde/pages/graphsensor.dart'; // Importando a página genérica

class ControleDesl extends StatefulWidget {
  const ControleDesl({super.key});

  @override
  _ControleDeslState createState() => _ControleDeslState();
}

class _ControleDeslState extends State<ControleDesl> {
  int paginaAtual = 0;
  late PageController pc;

  // Lista de sensores com seus parâmetros
  final List<Map<String, String>> sensores = [
    {
      'collection': 'tds',
      'name': 'Nutrientes TDS',
      'unit': 'mg/l',
      'lottie': 'lottie/tds.json',
    },
    {
      'collection': 'ph',
      'name': 'pH',
      'unit': 'pH',
      'lottie': 'lottie/ph.json',
    },
    {
      'collection': 'radiacao',
      'name': 'Radiação Solar',
      'unit': 'W/m²',
      'lottie': 'lottie/radiacao.json',
    },
    {
      'collection': 'vazao',
      'name': 'Vazão',
      'unit': 'L/min',
      'lottie': 'lottie/vazao.json',
    },
    {
      'collection': 'tempar',
      'name': 'Temperatura do Ar',
      'unit': 'ºC',
      'lottie': 'lottie/tempar.json',
    },
    {
      'collection': 'templiq',
      'name': 'Temperatura do Líquido',
      'unit': 'ºC',
      'lottie': 'lottie/templiq.json',
    },
    {
      'collection': 'umidade',
      'name': 'Umidade',
      'unit': '%',
      'lottie': 'lottie/umidade.json',
    },
  ];

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: pc,
        itemCount: sensores.length,
        itemBuilder: (context, index) {
          final sensor = sensores[index];
          return ChartSensor(
            sensorCollection: sensor['collection']!,
            sensorName: sensor['name']!,
            sensorUnit: sensor['unit']!,
            lottieAsset: sensor['lottie']!,
          );
        },
      ),
    );
  }
}
