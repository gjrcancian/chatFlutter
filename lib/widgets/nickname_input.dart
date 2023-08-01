import 'package:dio_fire/pages/my_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NickNameInput extends StatefulWidget {
  NickNameInput({Key? key}) : super(key: key);

  @override
  _NickNameInputState createState() => _NickNameInputState();
}

class _NickNameInputState extends State<NickNameInput> {
  late SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nickController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializePrefs();

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Digite o seu apelido'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                controller: nickController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Apelido',
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value == 'Anonimo') {
                    return 'Por Favor digite um apelido válido';
                  }
                  return null;
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    prefs.setString('nickname', nickController.text);
                    print('Botão OK foi pressionado');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            MyHomePage(),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    });
  }

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // seu container aqui
  }
}
