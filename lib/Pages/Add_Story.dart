import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_maker/story_maker.dart';

import 'dart:io';

import 'package:video_player/video_player.dart';

class Add_Story extends StatefulWidget {
  const Add_Story({super.key});

  @override
  State<Add_Story> createState() => _Add_StoryState();
}

class _Add_StoryState extends State<Add_Story> {
  String generateRandomvideoName() {
    // Generate a random number with 8 digits
    String randomNumber = Random().nextInt(99999999).toString().padLeft(8, '0');

    // Concatenate the parts to form the image name
    String imageName = "video$randomNumber.mp4";

    return imageName;
  }

Future<void> add_Story_Video_(File file) async {
    Reference ref = FirebaseStorage.instance.ref(generateRandomvideoName());
    UploadTask task = ref.putFile(file);
    TaskSnapshot taskSnapshot = await task.whenComplete(() {
      print("Succes");
    });
    String url = await (taskSnapshot.ref.getDownloadURL());
    print("URL ");
    print(url);

    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection("Stories")
        .where("Ownerid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<dynamic> storiesData = doc.docs.first["Content"];

    List<Map> transformedStories = storiesData.map((dynamic item) {
      if (item is Map<String, dynamic>) {
        return item;
      }

      return {};
    }).toList();

    transformedStories.add({
      "Content": url,
      "Time": Timestamp.now(),
      "type": "video",
      "Viewers": []
    });
    print(transformedStories[3]["type"]);
    print("gdfhsjsjh");
    print(doc.docs.first.id);
    await FirebaseFirestore.instance
        .collection('Stories')
        .doc(doc.docs.first.id)
        .update({
      // Add your update fields and values here
      'Content': transformedStories,
      'last_update': FieldValue.serverTimestamp()
    }).then((value) {
      print("FIN FIN FIN FIN ------------------");
      print("Inserted");

    }).onError((error, stackTrace) {
      print("error $error $stackTrace");

    });


  }
 late VideoPlayerController c;

  @override
  void initState() {
    // TODO: implement initState
    c=Get.arguments[0];
    super.initState();
  }

  @override
  void dispose() {
    Get.arguments[0].dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.arguments[0].play();
    return WillPopScope(
      onWillPop: () async {
        Get.arguments[0].pause();
        return await true;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () async{

            await add_Story_Video_(Get.arguments[1]);
             Get.arguments[0].pause();
             Get.back();


            },
            child: Icon(CupertinoIcons.checkmark_alt_circle_fill)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 50 / 100,
                  child: AspectRatio(
                    aspectRatio: Get.arguments[0].value.aspectRatio,
                    child: VideoPlayer(Get.arguments[0]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
