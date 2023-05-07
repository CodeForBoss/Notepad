import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notepad/repository/Database/database_service.dart';
import 'package:notepad/utlities/AppConstant.dart';

import '../repository/Note.dart';

class CreateNote extends StatelessWidget{
   CreateNote({super.key});
   final titleInputTextController = TextEditingController();
   final descriptionInputTextController = TextEditingController();
   final AppConstant appConstant = AppConstant();

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
       debugShowCheckedModeBanner: false,
       theme: ThemeData(
           colorSchemeSeed: Colors.green,
           brightness: Brightness.light,
           useMaterial3: true
       ),
       home: Scaffold(
         appBar: AppBar(
           centerTitle: true,
           title: Text(appConstant.new_note),
           leading: IconButton(onPressed: (){
             Navigator.pop(context);
           },
               iconSize: 35,
               padding: const EdgeInsets.all(10),
               icon: const Icon(Icons.arrow_back)),
       ),
        floatingActionButton: Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
          height: 80,
          width: 80,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: (){
                saveDataInDatabase(titleInputTextController.text, descriptionInputTextController.text,context);
              },
              child: const Icon(Icons.check_outlined),
            ),
          ),
        ),
        body: Column(
              children:  [
                Container(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child:  TextField(
                   decoration: InputDecoration(
                     hintText: appConstant.title,
                     border: InputBorder.none,
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
                        hintText: appConstant.write_something,
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
       )
     );
  }
  void saveDataInDatabase(String title,String descriptions, BuildContext context) async{
    if(title.isEmpty && descriptions.isEmpty){
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
    var note = Note(id: null,title: title, description: descriptions,timestamp: DateTime.now().millisecondsSinceEpoch);
    dbService.createItem(note).whenComplete(() => Navigator.pop(context));
  }
}