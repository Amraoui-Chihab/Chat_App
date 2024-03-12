import 'package:cloud_firestore/cloud_firestore.dart';

class story {

  List<dynamic> Viewers;
  String content;
  DateTime? createdAt;
  String type;

  story({
    required this.type,
    required this.Viewers,

    required this.content,
    required this.createdAt,
  });

  // Factory method to create a Story object from a map (received from Firebase)
  factory story.fromMap(Map<String, dynamic> map) {
    print(map["Time"].runtimeType);
    return story(

      content: map['Content'],
      createdAt: (map['Time'] as Timestamp).toDate()  , Viewers: map['Viewers'], type: map['type'],
    );
  }

  // Method to convert the Story object to a map (for storing in Firebase)
  Map<String, dynamic> toMap() {
    return {
      'Viewers':Viewers,
        'type':type,
      'Content': content,
      'Time': createdAt != null ? createdAt!.millisecondsSinceEpoch : null,
    };
  }
  static List<story>  mapListToStory(List<dynamic> dataList) {
    List<story> storyList = [];
  print("hello");
    for (var data in dataList) {

      if (data is Map<String, dynamic>) {

        storyList.add(story.fromMap(data));
      }
    }


    return storyList;
  }
}
