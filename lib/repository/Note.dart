
class Note{
   late String title;
   late String description;
   late int timestamp;
   int? id;

   Note({required this.id,required this.title, required this.description, required this.timestamp});

  Map<String, dynamic> toMap(){
    return {
      'title': title,
      'description': description,
      'timestamp': timestamp
    };
  }

  Note.fromMap(Map<String,dynamic> item):
        id = item["id"],
        description = item["description"],
        title = item["title"],
        timestamp = item["timestamp"];


  @override
  String toString(){
    return 'Note(title: $title, description: $description,timestamp: $timestamp)';
  }

}