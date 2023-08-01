import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/comment_model.dart';

class Chat extends StatefulWidget {
  final String sala;

  const Chat({Key? key, this.sala = ''}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChatState();
  }
}

class ChatState extends State<Chat> {
  get initialScroolOffset => initialScroolOffset;
  final db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> room;
  final commentController = TextEditingController(text: '');
  late String sala;
  String userId = "";
  String nickName = "";

  @override
  void initState() {
    super.initState();
    sala = widget.sala;
    final FirebaseFirestore db = FirebaseFirestore.instance;
    print('Iniciando a consulta com sala: $sala');
    room = db
        .collection('comments')
        .where('room', isEqualTo: sala)
        .orderBy('data')
        .snapshots();
    carregarDados();
  }

  carregarDados() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nickName = prefs.getString('nickname')!;
    userId = prefs.getString('user_id')!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat de $sala"),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: room,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData) {
                    return Center(child: Text("Ainda não há salas"));
                  } else {
                    return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot e) {
                        DateTime data = (e['data'] as Timestamp).toDate();
                        String formattedDate =
                            DateFormat('dd/MM/yyyy HH:mm').format(data);

                        return Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: userId == e['user_id']
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 300,
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: userId == e['user_id']
                                          ? Colors.indigo
                                          : Colors.indigoAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${e['name']} disse: ${e['comment']}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,

                    style: TextStyle(fontSize: 16), // Altera o tamanho da fonte
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8), // Define o preenchimento interno
                      hintText:
                          'Digite sua mensagem aqui', // Texto de dica quando o campo está vazio
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            20), // Define um raio para as bordas
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    var comment = commentModel(
                      comment: commentController.text,
                      name: nickName,
                      userId: userId,
                      room: sala,
                    );
                    await db.collection("comments").add(comment.toJson());
                    commentController.text = "";
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
