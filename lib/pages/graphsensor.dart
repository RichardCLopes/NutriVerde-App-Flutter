// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class ChartSensor extends StatefulWidget {
  final String sensorCollection;
  final String sensorName;
  final String sensorUnit;
  final String lottieAsset;

  const ChartSensor({
    super.key,
    required this.sensorCollection,
    required this.sensorName,
    required this.sensorUnit,
    required this.lottieAsset,
  });

  @override
  _ChartSensorState createState() => _ChartSensorState();
}

class _ChartSensorState extends State<ChartSensor> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List dadosCompletos = [];
  List<FlSpot> dadosGrafico = [];
  double maxX = 0;
  double maxY = 0;
  double minY = 0;
  ValueNotifier<bool> loaded = ValueNotifier(false);
  double last = 0;
  String datault = '';

  @override
  Widget build(BuildContext context) {
    pegaDados();
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),  
          title: Text(
            widget.sensorName,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Times New Roman',
              fontSize: 20,
              fontWeight: FontWeight.w600),
          )),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 170,
                    child: Lottie.asset(widget.lottieAsset),
                  ),
                  ValueListenableBuilder(
                    valueListenable: loaded,
                    builder: (context, bool isLoaded, _) {
                      return (isLoaded)
                          ? Text(
                              "$last ${widget.sensorUnit}",
                              style: const TextStyle(
                                  fontFamily: 'digital',
                                  fontSize: 60,
                                  color: Color.fromARGB(255, 15, 71, 34)),
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: loaded,
                    builder: (context, bool isLoaded, _) {
                      return (isLoaded)
                          ? Text(
                              datault,
                              style: const TextStyle(
                                  fontFamily: 'digital',
                                  fontSize: 40,
                                  color: Color.fromARGB(255, 15, 71, 34)),
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                    },
                  ),
                ]),
            AspectRatio(
              aspectRatio: 1.3,
              child: Stack(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 10, right: 15),
                    child: ValueListenableBuilder(
                      valueListenable: loaded,
                      builder: (context, bool isLoaded, _) {
                        return (isLoaded)
                            ? LineChart(
                                getChartData(),
                              )
                            : const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );
  }

 pegaDados() async {
  loaded.value = false;
  maxY = 0;
  minY = double.infinity;
  int indice = 0;
  double auxdou = 0;

  await db.collection(widget.sensorCollection).get().then((event) {
    if (event.docs.isEmpty) {
      minY = 0;
    } else {
      for (var doc in event.docs) {
        DateTime myDateTime = DateTime.parse(doc.get('datahora').toDate().toString());
        String formattedDateTime =
            DateFormat('dd/MM – HH:mm:ss').format(myDateTime);
        auxdou = doc.get('medicao');
        dadosGrafico.add(FlSpot(indice.toDouble(), double.parse(auxdou.toStringAsFixed(1))));
        dadosCompletos.add(formattedDateTime);
        maxY = auxdou > maxY ? auxdou : maxY;
        minY = auxdou < minY ? auxdou : minY;
        last = double.parse(auxdou.toStringAsFixed(1));
        datault = formattedDateTime;
        indice++;
      }
    }
  });

  maxX = dadosGrafico.length.toDouble() - 1;
  loaded.value = true;
}


  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 59, 128, 113),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    String text = value.toInt().toString();

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  getDate(int index) {
    return dadosCompletos[index];
  }


  LineChartData getChartData() {
    double minYValue;
    double maxYValue;

  if (widget.sensorCollection == 'tds') {
    minYValue = minY - 30;
    maxYValue = maxY + 30;
  } else if (widget.sensorCollection == 'ph') {
    minYValue = minY - 1;
    maxYValue = maxY + 1;
  } else if (widget.sensorCollection == 'radiacao') {
    minYValue = 0;
    maxYValue = maxY + 1;
  } else if (widget.sensorCollection == 'vazao') {
    minYValue = 0;
    maxYValue = maxY + 1;
  } else if (widget.sensorCollection == 'tempar') {
    minYValue = minY - 2;
    maxYValue = maxY + 2;
  } else if (widget.sensorCollection == 'templiq') {
    minYValue = minY - 2;
    maxYValue = maxY + 2;
  } else if (widget.sensorCollection == 'umidade') {
    minYValue = minY - 10;
    maxYValue = maxY + 10;
  } else {
    minYValue = minY;
    maxYValue = maxY;
  }

    return LineChartData(
      titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
              axisNameSize: 25,
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: leftTitleWidgets,
              ))),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color.fromARGB(70, 61, 179, 153),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color.fromARGB(70, 61, 179, 153),
            strokeWidth: 1,
          );
        },
      ),
      minX: 0,
      maxX: maxX,
      minY: minYValue,
      maxY: maxYValue,  

      lineBarsData: [
        LineChartBarData(
            spots: dadosGrafico,
            isCurved: true,
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            color: const Color.fromARGB(255, 0, 0, 0),
            barWidth: 5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors
                    .map((color) => color.withOpacity(0.3))
                    .toList(),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ))
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(getTooltipItems: (data) {
          return data.map((item) {
            final date = getDate(item.spotIndex);
            return LineTooltipItem("${item.y} ${widget.sensorUnit}",
                const TextStyle(color: Color.fromARGB(255, 0, 255, 179)),
                children: [
                  TextSpan(
                      text: '\n $date',
                      style: const TextStyle(color: Color.fromARGB(255, 0, 255, 179)))
                ]);
          }).toList();
        }),
      ),
    );
  }
}
