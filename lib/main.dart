
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final searchTextController = TextEditingController();
  List<Note> filterNotes = [];

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
     body: Column(
       children: [
         Padding(
             padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
             child: Card(
               child: Container(
                 height: 50,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(10),
                 ),
                 child: TextField(
                   controller: searchTextController,
                   decoration: InputDecoration(
                     suffixIcon: Visibility(
                       visible: searchTextController.text.isEmpty? false:true,
                       child: IconButton(
                         onPressed: () {
                           FocusScopeNode currentFocus = FocusScope.of(context);
                           if (!currentFocus.hasPrimaryFocus) {
                             currentFocus.focusedChild?.unfocus();
                           }
                           searchTextController.clear();
                         },
                         icon: const Icon(
                           Icons.clear_rounded,
                         ),
                       ),
                     ),
                     prefixIcon: const Icon(
                         Icons.search
                     ),
                     hintText: appConstant.label_search,
                     border: InputBorder.none,
                   ),
                   onChanged:(value){
                     setState(() {
                       filterNotes.clear();
                       if(searchTextController.text.isNotEmpty){
                         for(final note in notes){
                           if(note.title.toLowerCase().contains(searchTextController.text.toLowerCase()) ||
                               note.description.toLowerCase().contains(searchTextController.text.toLowerCase())){
                             filterNotes.add(note);
                           } else {
                             filterNotes.remove(note);
                           }
                         }
                       } else {
                         filterNotes.clear();
                       }
                     });
                   }
                 ),
               ),
             )
         ),
         Expanded(
             child:  RefreshIndicator(
               onRefresh: _refreshListOfNotes,
               child: searchTextController.text.isEmpty?
               gridviewBuilder(context,notes):gridviewBuilder(context,filterNotes),
             )
         )
       ],
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

  Widget gridviewBuilder(BuildContext context,List<Note> allNotes){
   return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5
      ),
      itemCount: allNotes.length,
      itemBuilder: (BuildContext ctx, index) {
        return Card(
              child: InkWell(
                onTap: () {
                  noteDetailsView(context,allNotes[index]);
                },
                child: Container(
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
                                allNotes[index].title,
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
                                allNotes[index].description,
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
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      maxLines:1,
                                      overflow: TextOverflow.ellipsis,
                                      convertTimeStampsToDateTime(allNotes[index].timestamp),
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: IconButton(
                                          onPressed: () {
                                            showAlertDialogForDelete(context,allNotes[index].id);
                                          },
                                          icon: const Icon(
                                              Icons.delete
                                          ),
                                          color: Colors.grey,
                                        )
                                    ),
                                  ),
                              ],
                            )
                        )
                      ],
                    )
                ),
              ),
          );
      },
    );
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
