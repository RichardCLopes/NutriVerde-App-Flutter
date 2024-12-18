// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'range.dart';
import 'slider.dart';
import 'opsensor.dart';
import 'dart:async';
import 'reset.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   bool _sensorError = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadSensorError();
    // Iniciar um timer para atualizar a cada 30 segundos
    _timer = Timer.periodic(Duration(seconds: 10), (Timer timer) {
      _loadSensorError();
    });
  }

  Future<void> _loadSensorError() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _sensorError = prefs.getBool('sensorError') ?? false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancelar o timer quando o widget for removido
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Nutri Verde',
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
        SizedBox(
          width: 280,
          child: Lottie.asset(_sensorError ? "lottie/broccoli_error.json" : "lottie/broccoli.json"),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox.fromSize(
                size: Size(130, 130),
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 10,
                            color: Color.fromARGB(255, 0, 50, 0),
                            spreadRadius: 0.5,
                            offset: Offset(3, 3)),
                      ],
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(60),
                          bottomLeft: Radius.circular(60))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(60),
                        bottomLeft: Radius.circular(60)),
                    child: Material(
                      color: Colors.green,
                      child: InkWell(
                        splashColor: Color.fromARGB(255, 0, 255, 0),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ControleDesl()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.show_chart_rounded,
                              color: Colors.white,
                              size: 60,
                            ),
                            Text(
                              "Dados",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              SizedBox.fromSize(
                size: Size(130, 130),
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 10,
                            color: Color.fromARGB(255, 0, 50, 0),
                            spreadRadius: 0.5,
                            offset: Offset(-3, 3)),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60)),
                    child: Material(
                      color: Colors.green, // button color
                      child: InkWell(
                        splashColor:
                            Color.fromARGB(255, 0, 255, 0), // splash color
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyRanges()));
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.warehouse_outlined,
                              color: Colors.white,
                              size: 60,
                            ),
                            Text(
                              "Intervalos",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
        SizedBox(height: 20),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox.fromSize(
                size: Size(130, 130),
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 10,
                            color: Color.fromARGB(255, 0, 50, 0),
                            spreadRadius: 0.5,
                            offset: Offset(3, -3)),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60)),
                    child: Material(
                      color: Colors.green, 
                      child: InkWell(
                        splashColor:
                            Color.fromARGB(255, 0, 255, 0), 
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SensorPage()));}, 
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.manage_search,
                              color: Colors.white,
                              size: 60,
                            ),
                            Text(
                              "Gerenciar",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              SizedBox.fromSize(
                size: Size(130, 130),
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 10,
                            color: Color.fromARGB(255, 0, 50, 0),
                            spreadRadius: 0.5,
                            offset: Offset(-3, -3)),
                      ],
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(60),
                          bottomLeft: Radius.circular(60))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(60),
                        bottomLeft: Radius.circular(60)),
                    child: Material(
                      color: Colors.green, // button color
                      child: InkWell(
                        splashColor:
                            Color.fromARGB(255, 0, 255, 0), // splash color
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ResetPage()));
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.power_settings_new_rounded,
                              color: Colors.white,
                              size: 60,
                            ),
                            Text(
                              "Resetar",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ])
      ]),
    );
  }
}
