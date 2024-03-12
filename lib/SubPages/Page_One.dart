import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:get/get.dart';
import 'package:story_maker/story_maker.dart';
import 'package:video_player/video_player.dart';
import '../Tools/Story.dart';
import 'package:dashed_circle/dashed_circle.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Page_One extends StatefulWidget {
  const Page_One({super.key});

  @override
  State<Page_One> createState() => _Page_OneState();
}

class _Page_OneState extends State<Page_One> with TickerProviderStateMixin {
  List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  String generateRandomImageName() {
    // Generate a random number with 8 digits
    String randomNumber = Random().nextInt(99999999).toString().padLeft(8, '0');

    // Concatenate the parts to form the image name
    String imageName = "video$randomNumber.mp4";

    return imageName;
  }

  void add_Story_Photo_(File file) async {
    Reference ref = FirebaseStorage.instance.ref(generateRandomImageName());
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
      "type": "image",
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
      print("Inserted");
    }).onError((error, stackTrace) {
      print("error $error $stackTrace");
    });
    print("FIN FIN FIN FIN ------------------");
  }

  @override
  void initState() {
    print("init page one =========================");

    super.initState();
  }

  bool isStoryExpired(DateTime? timestamp) {
    if (timestamp == null) {
      // Handle null case, you may consider treating null timestamp as expired or not
      return true; // For this example, treating null as expired
    }

    DateTime now = DateTime.now();
    Duration difference = now.difference(timestamp);

    // Check if the difference is exactly 24 hours

    return difference.inHours >= 24;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> Get_User_Document(
      String user_id) async* {
    yield* FirebaseFirestore.instance
        .collection("users")
        .doc(user_id)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> Get_User_Stories(
      String user_id) async* {
    yield* FirebaseFirestore.instance
        .collection("Stories")
        .where("Ownerid", isEqualTo: user_id)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 5 / 100,
              width: MediaQuery.of(context).size.width * 90 / 100,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 5 / 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chats",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            CupertinoIcons.search,
                            color: Colors.black,
                          )),
                      IconButton(
                          onPressed: () {
                            Get.defaultDialog(
                                title:
                                    "Add Your Story \n Choose Photo Or Video",
                                content: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: FittedBox(
                                          child: IconButton(
                                              onPressed: () {
                                                Get.back();
                                                Get.bottomSheet(
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              40 /
                                                              100,
                                                          child: FittedBox(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Text(
                                                                  "Gallery",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          6),
                                                                ),
                                                                IconButton(
                                                                  icon: Icon(
                                                                      CupertinoIcons
                                                                          .photo_fill_on_rectangle_fill),
                                                                  onPressed:
                                                                      () async {
                                                                    final image =
                                                                        await ImagePicker().pickImage(
                                                                            source:
                                                                                ImageSource.gallery);
                                                                    if (image !=
                                                                        null) {
                                                                      final editedFile =
                                                                          await Navigator.of(context)
                                                                              .push(
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              StoryMaker(
                                                                            filePath:
                                                                                image.path,
                                                                          ),
                                                                        ),
                                                                      );
                                                                      print(
                                                                          "Fin2222");
                                                                      Get.back();
                                                                      add_Story_Photo_(
                                                                          editedFile);
                                                                    }
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              40 /
                                                              100,
                                                          child: FittedBox(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Text("Camera",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            6)),
                                                                IconButton(
                                                                  icon: Icon(
                                                                      CupertinoIcons
                                                                          .photo_camera_solid),
                                                                  onPressed:
                                                                      () async {
                                                                    final image =
                                                                        await ImagePicker().pickImage(
                                                                            source:
                                                                                ImageSource.camera);
                                                                    if (image !=
                                                                        null) {
                                                                      final editedFile =
                                                                          await Navigator.of(context)
                                                                              .push(
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              StoryMaker(
                                                                            filePath:
                                                                                image.path,
                                                                          ),
                                                                        ),
                                                                      );
                                                                      Get.back();
                                                                      add_Story_Photo_(
                                                                          editedFile);
                                                                    }
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    backgroundColor:
                                                        Colors.white);
                                                // Get.toNamed("/add_story",arguments: ["photo"]);
                                              },
                                              icon: Icon(
                                                CupertinoIcons
                                                    .photo_camera_solid,
                                              )),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                30 /
                                                100,
                                      ),
                                      Container(
                                        child: FittedBox(
                                          child: IconButton(
                                              onPressed: () {
                                                Get.back();
                                                Get.bottomSheet(
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              40 /
                                                              100,
                                                          child: FittedBox(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Text(
                                                                  "Gallery",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          6),
                                                                ),
                                                                IconButton(
                                                                  icon: Icon(
                                                                      CupertinoIcons
                                                                          .photo_fill_on_rectangle_fill),
                                                                  onPressed:
                                                                      () async {
                                                                    XFile?
                                                                        video =
                                                                        await ImagePicker().pickVideo(
                                                                            source:
                                                                                ImageSource.gallery);

                                                                    if (video !=
                                                                        null) {
                                                                      File
                                                                          videoFile =
                                                                          File(video
                                                                              .path);

                                                                      VideoPlayerController
                                                                          _controller =
                                                                          VideoPlayerController.file(
                                                                              videoFile);
                                                                      await _controller
                                                                          .initialize();
                                                                      Get.back();

                                                                      Get.toNamed(
                                                                          "/add_story",
                                                                          arguments: [
                                                                            _controller,
                                                                            videoFile
                                                                          ]);
                                                                    }
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              40 /
                                                              100,
                                                          child: FittedBox(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Text("Camera",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            6)),
                                                                IconButton(
                                                                  icon: Icon(
                                                                      CupertinoIcons
                                                                          .photo_camera_solid),
                                                                  onPressed:
                                                                      () async {
                                                                    XFile?
                                                                        video =
                                                                        await ImagePicker().pickVideo(
                                                                            source:
                                                                                ImageSource.camera);

                                                                    if (video !=
                                                                        null) {
                                                                      File
                                                                          videoFile =
                                                                          File(video
                                                                              .path);

                                                                      VideoPlayerController
                                                                          _controller =
                                                                          VideoPlayerController.file(
                                                                              videoFile);
                                                                      await _controller
                                                                          .initialize();
                                                                      Get.back();

                                                                      Get.toNamed(
                                                                          "/add_story",
                                                                          arguments: [
                                                                            _controller,
                                                                            videoFile
                                                                          ]);
                                                                    }
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    backgroundColor:
                                                        Colors.white);
                                                //Get.toNamed("/add_story",arguments: ["video"]);
                                              },
                                              icon: Icon(
                                                CupertinoIcons
                                                    .videocam_circle_fill,
                                              )),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                30 /
                                                100,
                                      )
                                    ],
                                  ),
                                ));
                          },
                          icon: Icon(
                            CupertinoIcons.add_circled_solid,
                            color: Colors.black,
                          ))
                    ],
                  )
                ],
              ),
            ), ////////////////////////////////////////////fih 10 kamel
            Container(
              child: Center(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream:
                      Get_User_Document(FirebaseAuth.instance.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While data is loading
                      return Center(
                        child: CircleAvatar(),
                      );
                    } else if (snapshot.hasError) {
                      // If an error occurs
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      // If data is available, you can access the DocumentSnapshot
                      DocumentSnapshot<Map<String, dynamic>>? documentSnapshot =
                          snapshot.data;

                      // Do something with the documentSnapshot
                      return Center(
                        child: ListView(
                          children: [
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: Get_User_Stories(
                                  FirebaseAuth.instance.currentUser!.uid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return Text('No documents found.');
                                } else {
                                  var document = snapshot.data!.docs.first;
                                  // Access data from the single document

                                  List<story> stories = snapshot.data!.docs
                                      .map((doc) {
                                        // Access the 'Content' field from the document
                                        List<dynamic> contentData =
                                            doc['Content'];

                                        // Map each map in the array to an instance of the Story class
                                        List<story> storyList =
                                            contentData.map((data) {
                                          return story(
                                            content: data['Content'],
                                            type: data['type'],
                                            Viewers: data['Viewers'],
                                            createdAt:
                                                (data['Time'] as Timestamp)
                                                    .toDate(),
                                          );
                                        }).toList();

                                        return storyList;
                                      })
                                      .expand((element) =>
                                          element) // Flatten the list of lists
                                      .toList();
                                  stories.removeWhere((element) =>
                                      isStoryExpired(element.createdAt));
                                  stories.sort((a, b) =>
                                      a.createdAt!.compareTo(b.createdAt!));

                                  bool Not_Viewed_by_User = stories.any((str) =>
                                      str.Viewers.contains(FirebaseAuth
                                          .instance.currentUser!.uid) ==
                                      false);

                                  int my_index = (stories.indexWhere(
                                      (element) => !element.Viewers.contains(
                                          FirebaseAuth
                                              .instance.currentUser!.uid)));

                                  return InkWell(
                                    child: Container(
                                      margin: EdgeInsets.only(right: 5),
                                      //color:Colors.cyan,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                10 /
                                                100,
                                            child: FittedBox(
                                                child: DashedCircle(
                                              gapSize: 50,
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    stories.length != 0
                                                        ? 5.0
                                                        : 0),
                                                child: CircleAvatar(
                                                  radius: 30.0,
                                                  backgroundImage: NetworkImage(
                                                      documentSnapshot![
                                                          "Image"]),
                                                ),
                                              ),
                                              color: Not_Viewed_by_User == true
                                                  ? Colors.blue
                                                  : Colors.grey,
                                            )),
                                          ),
                                          Text(
                                            "Your Story",
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              15 /
                                              100,
                                      width: MediaQuery.of(context).size.width *
                                          25 /
                                          100,
                                    ),
                                    onTap: () {
                                      if (stories.length > 0)
                                        Get.toNamed("/story_view", arguments: [
                                          stories,
                                          my_index,
                                          "user"
                                        ]);
                                    },
                                  );
                                }
                              },
                            ),
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('Stories')
                                  .where("Ownerid",
                                      whereIn: documentSnapshot![
                                          "Friends"]) // Replace 'yourAttribute' with your actual attribute name
                                  .orderBy('last_update',
                                      descending:
                                          true) // Order by 'last_update' in descending order
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(); // or any loading indicator you prefer
                                }

                                if (snapshot.data!.docs.isEmpty) {
                                  return Text('');
                                }

                                return Row(
                                  children: List.generate(
                                      snapshot.data!.docs.length, (index) {
                                    List<story> storyList =
                                        story.mapListToStory(snapshot
                                            .data!.docs[index]["Content"]);

                                    storyList.removeWhere((element) =>
                                        isStoryExpired(element.createdAt));
                                    storyList.sort((a, b) =>
                                        a.createdAt!.compareTo(b.createdAt!));

                                    bool Not_Viewed_by_User = storyList.any(
                                        (str) =>
                                            str.Viewers.contains(FirebaseAuth
                                                .instance.currentUser!.uid) ==
                                            false);

                                    int my_index = (storyList.indexWhere(
                                        (element) => !element.Viewers.contains(
                                            FirebaseAuth
                                                .instance.currentUser!.uid)));

                                    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> (stream: FirebaseFirestore.instance.collection("users").doc(snapshot
                                        .data!.docs[index]["Ownerid"]).snapshots(), builder: (context, snapshot2) {
                                      if (snapshot2.hasError) {
                                        return Text('Error: ${snapshot2.error}');
                                      }

                                      if (snapshot2.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text(""); // or any loading indicator you prefer
                                      }

                                      if (!snapshot2.data!.exists) {
                                        return Text('');
                                      }

                                      return InkWell(
                                        child: Container(
                                          margin: EdgeInsets.only(right: 5),
                                          //color:Colors.cyan,
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    10 /
                                                    100,
                                                child: FittedBox(
                                                    child: DashedCircle(
                                                      gapSize: 50,
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            storyList.length != 0
                                                                ? 5.0
                                                                : 0),
                                                        child: CircleAvatar(
                                                          radius: 30.0,
                                                          backgroundImage:
                                                          NetworkImage(
                                                              snapshot2.data!.data()!["Image"]),
                                                        ),
                                                      ),
                                                      color:
                                                      Not_Viewed_by_User == true
                                                          ? Colors.blue
                                                          : Colors.grey,
                                                    )),
                                              ),
                                              Text(
                                                "${snapshot2.data!.data()!["Username"]}",
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ],
                                          ),
                                          height:
                                          MediaQuery.of(context).size.height *
                                              15 /
                                              100,
                                          width:
                                          MediaQuery.of(context).size.width *
                                              25 /
                                              100,
                                        ),
                                        onTap: () {
                                          if (storyList.length > 0)
                                            Get.toNamed("/story_view",
                                                arguments: [
                                                  storyList,
                                                  my_index,
                                                  "friend",
                                                  snapshot.data!.docs[index]
                                                  ["Ownerid"]
                                                ]);
                                        },
                                      );
                                    },);
                                  }),
                                );
                              },
                            )
                          ],
                          scrollDirection: Axis.horizontal,
                        ),
                      );
                    } else {
                      // If there is no data (null)
                      return Center(
                        child: Text('No data available'),
                      );
                    }
                  },
                ),
              ),
              height: MediaQuery.of(context).size.height * 15 / 100,
              width: MediaQuery.of(context).size.width * 90 / 100,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Discussions",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              height: MediaQuery.of(context).size.height * 5 / 100,
              width: MediaQuery.of(context).size.width * 90 / 100,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('Discussions')
                    .where("members",
                        arrayContains: FirebaseAuth.instance.currentUser!.uid)
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot1) {
                  if (snapshot1.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot1.hasError) {
                    return Center(child: Text('Error: ${snapshot1.error}'));
                  }
                  if (!snapshot1.hasData || snapshot1.data!.docs.isEmpty) {
                    return Center(child: Text('No discussions Yet'));
                  }

                  return Center(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        List<dynamic> members =
                            snapshot1.data!.docs[index]["members"];

                        return Container(
                          child: StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(members
                                    .where((element) =>
                                        element !=
                                        FirebaseAuth.instance.currentUser!.uid)
                                    .single)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }
                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return Center(
                                    child: Text('No discussions Yet'));
                              }
                              List<dynamic> my_list =
                                  snapshot1.data!.docs[index]["Content"];
                              print(my_list.last);
                              return ListTile(
                                onTap: (){
                                  Get.toNamed("/message",arguments: [snapshot1.data!.docs[index].id,my_list,snapshot.data!.id]);
                                },
                                  trailing: my_list.last["owner"] ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "${monthNames[DateTime.fromMillisecondsSinceEpoch(my_list.last["Time"].seconds * 1000).month - 1]},${DateTime.fromMillisecondsSinceEpoch(my_list.last["Time"].seconds * 1000).day}",
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.start,
                                            )
                                            ,Text("")
                                          ],
                                        )
                                      : Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "${monthNames[DateTime.fromMillisecondsSinceEpoch(my_list.last["Time"].seconds * 1000).month - 1]},${DateTime.fromMillisecondsSinceEpoch(my_list.last["Time"].seconds * 1000).day}",
                                        style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,
                                      )
                                      ,Text("")
                                    ],
                                  ),
                                  subtitle: Text(
                                      my_list.last["owner"] ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                          ? "You: ${my_list.last["Content_msg"]}"
                                          : my_list.last["Content_msg"],
                                      style: my_list.last["owner"] !=
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                          ? my_list.last["seen"] == false
                                              ? TextStyle(
                                                  fontWeight: FontWeight.bold)
                                              : null
                                          : null),
                                  title: Text(
                                    "${snapshot.data!.data()!["Username"]}",
                                    style: my_list.last["owner"] !=
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                        ? my_list.last["seen"] == false
                                            ? TextStyle(
                                                fontWeight: FontWeight.bold)
                                            : null
                                        : null,
                                  ),
                                  leading: Stack(
                                    children: [
                                      CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              snapshot.data!.data()!["Image"])),
                                      snapshot.data!.data()!["status"] == true
                                          ? Positioned(
                                              child: CircleAvatar(
                                                radius: 7,
                                                backgroundColor: Colors.green,
                                              ),
                                              top: 26,
                                              left: 25,
                                            )
                                          : Text("")
                                    ],
                                  ));
                            },
                          ),
                          width: 50,
                        );
                      },
                      itemCount: snapshot1.data!.docs.length,
                    ),
                  );
                },
              ),
              height: MediaQuery.of(context).size.height * 60 / 100,
              width: MediaQuery.of(context).size.width * 90 / 100,
            ) ////////////////////////////////////////// fih 5 kamel
          ],
        ),
      ),
    );
  }
}
