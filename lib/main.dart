// ignore_for_file: prefer_const_constructors, unused_element, avoid_print
import 'package:flutter/material.dart';
import 'package:nutriverde/pages/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Inicializar as notificações
  await _initializeNotifications();
  
  // Iniciar o monitoramento de sensores
  startMonitoring();

  runApp(const MyApp());
}

// Configuração do Flutter Local Notifications
final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = 
      AndroidInitializationSettings('logo'); // Nome do ícone que você adicionou nas pastas drawable
  final InitializationSettings initializationSettings = 
      InitializationSettings(android: initializationSettingsAndroid);
  await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// Função para iniciar o monitoramento de sensores
void startMonitoring() {
  Timer.periodic(Duration(seconds: 30), (Timer timer) async {
    await monitorSensors();
  });
}

Future<void> monitorSensors() async {
  double? tdsMin = await _getRangeValue('tdsMin');
  double? tdsMax = await _getRangeValue('tdsMax');
  double? lastValue = await _getLastSensorValue('tds');

  print('\n');
  print(tdsMin);
  print('\n');
  print(tdsMax);
  print('\n');
  print(lastValue);
  print('\n');
  if (lastValue != null && tdsMin != null && tdsMax != null) {
    if (_isValueOutOfRange(lastValue, tdsMin, tdsMax)) {
      _sendNotification('Alerta', 'O valor do TDS está fora do intervalo!');
    }
  }
}

Future<double?> _getRangeValue(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getDouble(key);
}

Future<double?> _getLastSensorValue(String sensorId) async {
  try {
    var snapshot = await FirebaseFirestore.instance
        .collection(sensorId)
        .orderBy('datahora', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first['medicao'] as double?;
    }
  } catch (e) {
    print("Erro ao obter o valor do sensor: $e");
  }
  return null;
}

bool _isValueOutOfRange(double value, double min, double max) {
  return value < min || value > max;
}

void _sendNotification(String title, String body) async {
  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    channelDescription: 'description of your channel',
    importance: Importance.high,
    priority: Priority.high,
    icon: 'logo', 
  );

  const platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  
  await _flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutri Verde',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Color.fromARGB(255, 194, 223, 189),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: Colors.white,
            fontFamily: 'Times New Roman',
            fontSize: 20,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Color.fromARGB(255, 232, 255, 225),
            backgroundColor: Colors.green,
            minimumSize: Size(130, 130),
            textStyle: TextStyle(fontSize: 10),
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.green,
        ),
      ),
      home: MyHomePage(),
    );
  }
}
