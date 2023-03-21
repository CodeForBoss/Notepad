import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class Note{
  final int id;
  final String title;
  final String description;
  final int timestamps;

 const Note({
     required this.id,
     required this.title,
     required this.description,
     required this.timestamps
    });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'description': description,
      'timestamp': timestamps
    };
  }

  @override
  String toString(){
    return 'Note(id: $id, title: $title, description: $description,timestamp: $timestamps)';
  }

}