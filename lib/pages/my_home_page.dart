import 'package:dio_fire/widgets/nickname_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_drawer.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nickname = TextEditingController();
  bool is_anonimo = false;

  carregarUsuario() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var nick = prefs.getString('nickname');

    if (nick == null) {
      await prefs.setString('nickname', 'Anonimo');
    }
    nickname.text = prefs.getString('nickname')!;
    if (nickname.text == 'Anonimo') {
      setState(() {
        is_anonimo = true;
      });
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    carregarUsuario();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Chats Do Dio"),
      ),
      body: Center(
          child: is_anonimo
              ? NickNameInput()
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Olá " +
                        nickname.text +
                        " bem vindo, esse é um projeto de um chat desenvolvido para o curso da Dio 'Flutter Specialist' clique no menu escolha uma sala e converse em nosso bate papo",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
      drawer: CustomDrawer(),
    ));
  }
}
