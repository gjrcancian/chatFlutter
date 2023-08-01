import 'package:cloud_firestore/cloud_firestore.dart';

class commentModel {
  String comment = "";
  DateTime data = DateTime.now();
  String name = "";
  String userId = "";
  String room = "";

  commentModel(
      {required this.comment,
      required this.name,
      required this.userId,
      required this.room});

  commentModel.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    data = (json['data'] as Timestamp).toDate();
    name = json['name'];
    userId = json['user_id'];
    room = json['room'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['data'] = this.data;
    data['name'] = this.name;
    data['user_id'] = this.userId;
    data['room'] = this.room;
    return data;
  }
}
