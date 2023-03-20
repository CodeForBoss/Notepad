
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
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
      )
    );
  }
  static void createNewNoteView(BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>  CreateNote()));
  }
}
