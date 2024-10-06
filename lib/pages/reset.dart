// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({super.key});

  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  Future<void> _resetAllData() async {
    try {
      // Lista com os nomes das coleções que você quer excluir
      List<String> collectionNames = ['sensores', 'ph', 'radiacao', 'tds', 'tempar', 'templiq', 'umidade', 'vazao', 'allsensors'];

      for (String collection in collectionNames) {
        CollectionReference ref = FirebaseFirestore.instance.collection(collection);
        QuerySnapshot snapshot = await ref.get();

        for (var doc in snapshot.docs) {
          await ref.doc(doc.id).delete();
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Todos os dados foram resetados com sucesso."),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Erro ao resetar dados: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Função para mostrar pop-up de confirmação
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar Reset"),
          content: Text(
              "Tem certeza de que deseja resetar todos os dados? Esta ação não pode ser desfeita."),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Sim, Resetar"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetAllData();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), 
        title: Text(
          'Resetar Dados',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Times New Roman',
              fontSize: 25,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Lottie animação no centro
            SizedBox(
              width: 250,
              child: Lottie.asset("lottie/reset.json"),
            ),
            SizedBox(height: 20),
            // Mensagem de aviso
            Text(
              "Ao resetar, todos os dados de todos os sensores serão apagados permanentemente. "
              "Por favor, faça o download dos dados na aba Gerenciar antes de continuar.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Times New Roman',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 40),
            // Botão de Resetar com o estilo especificado
            SizedBox.fromSize(
              size: Size(200, 80),
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
                    color: Colors.red, // Cor do botão de reset
                    child: InkWell(
                      splashColor: Color.fromARGB(255, 255, 0, 0), // Cor do splash ao clicar
                      onTap: _showConfirmationDialog, // Aciona o pop-up de confirmação
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                            size: 40,
                          ),
                          Text(
                            "Resetar",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white, // Cor do texto
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
