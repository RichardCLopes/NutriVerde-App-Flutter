// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRanges extends StatefulWidget {
  const MyRanges({super.key});

  @override
  _MyRangesState createState() => _MyRangesState();
}

class _MyRangesState extends State<MyRanges> {
  TextEditingController tdsMinController = TextEditingController();
  TextEditingController tdsMaxController = TextEditingController();
  TextEditingController radiacaoMinController = TextEditingController();
  TextEditingController radiacaoMaxController = TextEditingController();
  TextEditingController vazaoMinController = TextEditingController();
  TextEditingController vazaoMaxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRanges();
  }

  Future<void> _loadRanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tdsMinController.text = (prefs.getDouble('tdsMin') ?? '').toString();
      tdsMaxController.text = (prefs.getDouble('tdsMax') ?? '').toString();
      radiacaoMinController.text = (prefs.getDouble('radiacaoMin') ?? '').toString();
      radiacaoMaxController.text = (prefs.getDouble('radiacaoMax') ?? '').toString();
      vazaoMinController.text = (prefs.getDouble('vazaoMin') ?? '').toString();
      vazaoMaxController.text = (prefs.getDouble('vazaoMax') ?? '').toString();
    });
  }

  Future<void> _saveRanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('tdsMin', double.parse(tdsMinController.text));
    await prefs.setDouble('tdsMax', double.parse(tdsMaxController.text));
    await prefs.setDouble('radiacaoMin', double.parse(radiacaoMinController.text));
    await prefs.setDouble('radiacaoMax', double.parse(radiacaoMaxController.text));
    await prefs.setDouble('vazaoMin', double.parse(vazaoMinController.text));
    await prefs.setDouble('vazaoMax', double.parse(vazaoMaxController.text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Intervalos salvos com sucesso!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            'Intervalos',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Times New Roman',
                fontSize: 25,
                fontWeight: FontWeight.w600),
          )),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(height: 50),
          _buildRangeInput('Total Dissolved Solids (TDS)', tdsMinController, tdsMaxController),
          const SizedBox(height: 30),
          _buildRangeInput('Radiação', radiacaoMinController, radiacaoMaxController),
          const SizedBox(height: 30),
          _buildRangeInput('Vazão', vazaoMinController, vazaoMaxController),
          const SizedBox(height: 30),
          SizedBox.fromSize(
            size: const Size(200, 80),
            child: Container(
              decoration: const BoxDecoration(
                  boxShadow: [
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
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(60),
                    bottomLeft: Radius.circular(60)),
                child: Material(
                  color: Colors.green,
                  child: InkWell(
                    splashColor: const Color.fromARGB(255, 0, 255, 0),
                    onTap: _saveRanges,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.save,
                          color: Colors.white,
                          size: 40,
                        ),
                        Text(
                          "Salvar",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildRangeInput(String label, TextEditingController minController, TextEditingController maxController) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 15, 71, 34),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: minController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Min',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: maxController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Max',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
