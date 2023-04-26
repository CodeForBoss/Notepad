
import 'package:flutter/cupertino.dart';

class Note{
   late String title;
   late String description;
   late int timestamp;

   Note(this.title, this.description, this.timestamp);

  Map<String, dynamic> toMap(){
    return {
      'title': title,
      'description': description,
      'timestamp': timestamp
    };
  }

  Note.fromMap(Map<String,dynamic> item):
        description = item["description"],
        title = item["title"],
        timestamp = item["timestamp"];


  @override
  String toString(){
    return 'Note(title: $title, description: $description,timestamp: $timestamp)';
  }

}