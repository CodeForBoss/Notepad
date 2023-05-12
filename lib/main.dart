
import 'package:flutter/material.dart';
import 'package:notepad/repository/Database/database_service.dart';
import 'package:notepad/repository/Note.dart';
import 'package:notepad/utlities/AppConstant.dart';
import './view/CreateNote.dart';
import './view/NoteDetails.dart';
import 'package:intl/intl.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  // This widget is the root of your application.
  final AppConstant appConstant = AppConstant();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      home: MyHomePage(title: appConstant.notePad),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late DatabaseService service;
  List<Note> notes = [];
  AppConstant appConstant = AppConstant();
  @override
  void initState(){
    super.initState();
    service = DatabaseService();
    service.initializeDB().whenComplete(() async {
      getAllNotesFromDB();
    });
  }

  void getAllNotesFromDB() async {
    final data = await service.getAllItem();
    setState((){
      notes = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getAllNotesFromDB();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        shadowColor: Theme.of(context).shadowColor,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: 32.0,
            padding: const EdgeInsets.fromLTRB(10,10,20,10),
            onPressed: () {
              createNewNoteView(context);
            },
          ),
        ],
      ),
     body: RefreshIndicator(
       onRefresh: _refreshListOfNotes,
       child: GridView.builder(
         shrinkWrap: true,
         padding: const EdgeInsets.all(10),
         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5
         ),
         itemCount: notes.length,
         itemBuilder: (BuildContext ctx, index) {
           return SizedBox(
             child: Card(
                 child: InkWell(
                   onTap: () {
                     noteDetailsView(context,notes[index]);
                   },
                   child:  Container(
                       padding: const EdgeInsets.all(15.0),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(10),
                       ),
                       child: Column(
                         children: [
                           Align(
                               alignment: Alignment.centerLeft,
                               child:Padding(
                                 padding: const EdgeInsets.all(2.0),
                                 child:  Text(
                                   maxLines:1,
                                   overflow: TextOverflow.ellipsis,
                                   notes[index].title,
                                   style: const TextStyle(
                                     fontSize: 16,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               )
                           ),
                           Align(
                               alignment: Alignment.centerLeft,
                               child: Padding(
                                 padding: const EdgeInsets.all(2.0),
                                 child:  Text(
                                   maxLines:4,
                                   overflow: TextOverflow.ellipsis,
                                   notes[index].description,
                                   style: const TextStyle(
                                     fontSize: 16,
                                     fontWeight: FontWeight.normal,
                                     color: Colors.black,
                                   ),
                                 ),
                               )
                           ),
                          Expanded(
                              child:  Row(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        maxLines:1,
                                        overflow: TextOverflow.ellipsis,
                                        convertTimeStampsToDateTime(notes[index].timestamp),
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                   Expanded(
                                     child: InkWell(
                                       onTap: () {
                                         showAlertDialogForDelete(context,notes[index].id);
                                       },
                                       child: const Visibility(
                                         visible: true,
                                         child: Align(
                                           alignment: Alignment.bottomRight,
                                           child: Padding(
                                             padding:  EdgeInsets.all(5.0),
                                             child: Icon(
                                               Icons.delete,
                                               color: Colors.grey,
                                             ),
                                           ),
                                         ),
                                       ),
                                     )
                                  )
                                ],
                              )
                            )
                         ],
                       )
                   ),
                 ),
               ),
           );
         },
       ),
     )
    );
  }
  static void createNewNoteView(BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>  CreateNote()));
  }

  static void noteDetailsView(BuildContext context, Note note){
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => NoteDetails(note: note)));
  }

  Future<void> _refreshListOfNotes(){
    return Future.delayed(
        const Duration(seconds: 1),
        getAllNotesFromDB
    );
  }

   String convertTimeStampsToDateTime(int timestamps){
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamps);
    String formattedDate = DateFormat(appConstant.datetime_format).format(date);
    return formattedDate;
  }

  void showAlertDialogForDelete(BuildContext context, int? noteId){
    Widget okButton = TextButton(
        onPressed: (){
            deleteItem(context,noteId);
        },
        child: Text(appConstant.label_yes)
    );

    Widget cancelButton = TextButton(
        onPressed: () {
            Navigator.pop(context);
        },
        child: Text(appConstant.lable_no)
    );

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
              appConstant.delete_note_title,
              textAlign: TextAlign.center,
          ),
          content: Text(
              appConstant.delete_note_content,
              textAlign: TextAlign.center,
          ),
          actions: [
              okButton,
              cancelButton
          ],
         )
     );
  }

  static void deleteItem(BuildContext context,int? id){
      DatabaseService dbService = DatabaseService();
      dbService.deleteItem(id).whenComplete(() => Navigator.pop(context));
  }

}
