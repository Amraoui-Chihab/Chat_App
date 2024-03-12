import 'package:chat_app/Tools/Story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_view/story_view.dart';

import '../Tools/Story.dart';
import '../Tools/Story.dart';
import '../Tools/Story.dart';

class Story_View extends StatefulWidget {
  const Story_View({super.key});

  @override
  State<Story_View> createState() => _Story_ViewState();
}

class _Story_ViewState extends State<Story_View> {
  final StoryController controller = StoryController();
  final List<StoryItem> stories = [];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < Get.arguments[0].length; i++) {
      if (Get.arguments[0][i].type == "image") {
        stories.add(StoryItem.pageImage(
            key: Key("$i"),
            duration: Duration(seconds: 8),
            url: Get.arguments[0][i].content,
            controller: controller));
      } else {
        stories.add(StoryItem.pageVideo(
          Get.arguments[0][i].content,
          controller: controller,
          duration: Duration(seconds: 12),
          key: Key("$i"),
        ));
      }
    }
    Future.delayed(
      Duration(seconds: 0),
      () {
        for (int i = 0; i < Get.arguments[1]; i++) {
          controller.next();
        }
      },
    );
  }

  void Mark_Story_As_Viewed_Current_user(int id) async {
    print("//////////////////////////////////////////////////////////$id");
    QuerySnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
        .collection("Stories")
        .where("Ownerid", isEqualTo: Get.arguments[2]=="user"?FirebaseAuth.instance.currentUser!.uid:Get.arguments[3])
        .get();
    List<dynamic> storiesData = doc.docs.first.data()["Content"];


    List<Map> transformedStories = storiesData.map((dynamic item) {

      if (item is Map<String, dynamic>) {
        return item;
      }

      return {};
    }).toList();
    print("helklfdskhjsgkhjqskj");
     id = storiesData.length - (Get.arguments[0] as List).length + id;

    transformedStories[id]["Viewers"]
        .add(FirebaseAuth.instance.currentUser!.uid);

    doc.docs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
      String docId = doc.id;
      await FirebaseFirestore.instance.collection('Stories').doc(docId).update({
        // Add your update fields and values here
        'Content': transformedStories,
        'last_update':FieldValue.serverTimestamp()
      }).then((value) {
        print("Inserted");
      }).onError((error, stackTrace) {
        print("error");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoryView(
      onVerticalSwipeComplete: (p0) {
        Get.back();
      },
      storyItems: stories,
      controller: controller,
      onComplete: () {
        Get.back();
      },
      onStoryShow: (value) {

        print("on show");

        String key = value.view.key.toString();
        String story_id =
            key.substring(key.indexOf("'") + 1, key.lastIndexOf("'"));
        print(Get.arguments[0][int.parse(story_id)].createdAt);
        if(Get.arguments[1]!=-1)
        Mark_Story_As_Viewed_Current_user((Get.arguments[1]));
      },
    );
  }
}
