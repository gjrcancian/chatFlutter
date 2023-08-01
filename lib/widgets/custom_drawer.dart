import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio_fire/helpers/my_text.dart';
import 'package:dio_fire/pages/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  CustomDrawer({Key? key}) : super(key: key);
  String userId = "";

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late Stream<QuerySnapshot> rooms;
  String chat = "";
  String nickName = "";

  @override
  void initState() {
    super.initState();
    final FirebaseFirestore db = FirebaseFirestore.instance;
    carregarUsuario();
    rooms = db.collection('rooms').snapshots();
  }

  carregarUsuario() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nickName = prefs.getString('nickname')!;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder<QuerySnapshot>(
          stream: rooms,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (!snapshot.hasData) {
              return Text("Ainda não há salas{user}");
            } else {
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot e) {
                  return Container(
                    margin: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          MyText.capitalize(e['room']),
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Futura',
                              color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () => {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Entrar no chat: ${e['room']}'),
                                  content: Text('Seu apelido é ${nickName}'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Entrar'),
                                      onPressed: () {
                                        String room = e['room'];
                                        Future callback(String room) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);

                                          return Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    Chat(sala: room)),
                                          );
                                        }

                                        callback(room);
                                      },
                                    ),
                                  ],
                                );
                              },
                            )
                          },
                          child: Text("Entrar"),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }
          }),
    );
  }
}
