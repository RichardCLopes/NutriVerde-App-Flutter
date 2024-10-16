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
  //Pega dados de TDS
  double? tdsMin = await _getRangeValue('tdsMin');
  double? tdsMax = await _getRangeValue('tdsMax');
  double? lasttds = await _getLastSensorValue('tds');
  
  //Pega dados de Radiação
  double? radiacaoMin = await _getRangeValue('radiacaoMin');
  double? radiacaoMax = await _getRangeValue('radiacaoMax');
  double? lastrad = await _getLastSensorValue('radiacao');
  
  //Pega dados de Vazao
  double? vazaoMin = await _getRangeValue('vazaoMin');
  double? vazaoMax = await _getRangeValue('vazaoMax');
  double? lastvazao = await _getLastSensorValue('vazao');

  print('\n$tdsMin\t$tdsMax\t$lasttds\n');
  print('\n$radiacaoMin\t$radiacaoMax\t$lastrad\n');
  print('\n$vazaoMin\t$vazaoMax\t$lastvazao\n');

  bool hasError = false;

  // Notificação TDS
  if (lasttds != null && tdsMin != null && tdsMax != null) {
    if (_isValueOutOfRange(lasttds, tdsMin, tdsMax)) {
      _sendNotification('Alerta', 'O valor do TDS está fora do intervalo!');
      hasError = true;
    }
  }
  
  // Notificação Radiação
  if (lastrad != null && radiacaoMin != null && radiacaoMax != null) {
    if (_isValueOutOfRange(lastrad, radiacaoMin, radiacaoMax)) {
      _sendNotification('Alerta', 'A radiação solar está muito alta!');
      hasError = true;
    }
  }
  
  // Notificação Vazão
  if (lastvazao != null && vazaoMin != null && vazaoMax != null) {
    if (_isValueOutOfRange(lastvazao, vazaoMin, vazaoMax)) {
      _sendNotification('Alerta', 'O valor da vazão está fora do intervalo!');
      hasError = true;
    }
  }

  // Salvar o status de erro do sensor
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('sensorError', hasError);
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
    channelDescription: 'channel of notifications',
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
