
import 'package:flutter/material.dart';
import 'package:notepad/repository/Database/database_service.dart';
import 'package:notepad/repository/Note.dart';
import './view/CreateNote.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Notepad'),
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
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 20.0),
        width: 80,
        height: 80,
        child: FittedBox(
         child: FloatingActionButton(
               onPressed:() {
                 createNewNoteView(context);
               },
               child: const Icon(Icons.edit),
         ),
        )
      ),
     body: RefreshIndicator(
       onRefresh: _refreshListOfNotes,
       child: GridView.builder(
         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
             crossAxisCount: 2,
             childAspectRatio: 1.2,
             crossAxisSpacing: 5,
             mainAxisSpacing: 5),
         itemCount: notes.length,
         itemBuilder: (BuildContext ctx, index) {
           return Container(
             alignment: Alignment.center,
             decoration: BoxDecoration(
               color: Colors.amber,
               borderRadius: BorderRadius.circular(10),
             ),
             child:  Text(notes[index].description),
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
  Future<void> _refreshListOfNotes(){
    return Future.delayed(
        const Duration(seconds: 1),
        getAllNotesFromDB
    );
  }
}
