
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notepad/repository/Database/database_service.dart';
import 'package:notepad/utlities/AppConstant.dart';

import '../repository/Note.dart';

class NoteDetails extends StatelessWidget{
   NoteDetails({super.key, required this.note});
  final titleInputTextController = TextEditingController();
  final descriptionInputTextController = TextEditingController();
  final Note note;
  final AppConstant appConstant = AppConstant();

  @override
  Widget build(BuildContext context) {
    titleInputTextController.text = note.title;
    descriptionInputTextController.text = note.description;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        brightness: Brightness.light,
        useMaterial3: true
      ),
      home: Scaffold(
        appBar: AppBar(
            title:  Text(appConstant.note),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                iconSize: 35,
                padding: const EdgeInsets.all(10),
                icon: const Icon(
                    Icons.arrow_back
                )
            )
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20,0,20,0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: appConstant.title,
                  border: InputBorder.none
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                ),
                controller: titleInputTextController,
              ),
            ),
            Container(
                padding:const EdgeInsets.fromLTRB(20,0,20,0),
                child:   SizedBox(
                  height: 200,
                  child: TextField(
                    decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: appConstant.write_something
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    expands: true,
                    controller: descriptionInputTextController,
                  ),
                )
            )
          ],
        ),
        floatingActionButton: Container(
          height: 80,
          width: 80,
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: (){
                updateInDatabase(note.id,titleInputTextController.text, descriptionInputTextController.text,context);
              },
              child: const Icon(Icons.check_outlined),
            ),
          ),
        ),
      )
    );
  }

   void updateInDatabase(int? _id,String _title, String descriptions, BuildContext context){
    if(_title.isEmpty && descriptions.isEmpty){
      Fluttertoast.showToast(
          msg: appConstant.note_is_empty,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.black

      );
      return;
    }
    DatabaseService dbService = DatabaseService();
    var note = Note(id: _id,
        title: _title,
        description: descriptions,
        timestamp: DateTime.now().millisecondsSinceEpoch);
    dbService.updateItem(note).whenComplete(() => Navigator.pop(context));
  }

}