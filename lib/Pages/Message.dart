import 'package:chat_app/MVC/Controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vengamo_chat_ui/vengamo_chat_ui.dart';
import 'package:record/record.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class Message extends StatefulWidget {
  const Message({super.key});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  TextEditingController message_controller = TextEditingController();
  Controller c2 = Controller();
  final ScrollController _scrollController = ScrollController();
  FocusNode focus_node = FocusNode();





  @override
  void initState() {
    super.initState();

    focus_node.addListener(() {
      if (focus_node.hasFocus) {
        print("has focus");
        _scrollToBottom();
      }
    });
    Future.delayed(
      Duration(milliseconds: 250),
      () {
        _scrollToBottom();
      },
    );

  }

  Future<void> Record() async {
    final record = AudioRecorder();

// Check and request permission if needed
    if (await record.hasPermission()) {
      // Start recording to file
      await record.start(const RecordConfig(), path: 'aFullPath/myFile.m4a');
      // ... or to stream
      final stream = await record
          .startStream(const RecordConfig(encoder: AudioEncoder.pcm16bits));
    }
    else{
      if (await record.hasPermission())
        {
          print("redemand");
        }
      else{
        print("no persmission");
      }

    }
    record.dispose();

  }

  @override
  void dispose() {
    _scrollController.dispose();
    focus_node.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          shadowColor: Colors.black26,
          elevation: 6,
          titleSpacing: 0,
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.phone,
                  color: Colors.blue,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.video_call,
                  color: Colors.blue,
                ))
          ],
          title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(Get.arguments[2])
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("");
              }
              if (snapshot.hasError) {
                return Text("");
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Text("");
              }
              return Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data!.data()!["Image"]),
                      ),
                      Positioned(
                        child: snapshot.data!.data()!["status"] == true
                            ? CircleAvatar(
                                radius: 5,
                                backgroundColor: Colors.green,
                              )
                            : Text(""),
                        top: 28,
                        left: 27,
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${snapshot.data!.data()!["Username"]}",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        snapshot.data!.data()!["status"] == true
                            ? Text(
                                "Active now",
                                style: TextStyle(fontSize: 13),
                              )
                            : Text(
                                "Active 5h",
                                style: TextStyle(fontSize: 13),
                              )
                      ],
                    ),
                  )
                ],
              );
            },
          )),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("Discussions")
            .doc(Get.arguments[0])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("");
          }
          if (snapshot.hasError) {
            return Text("");
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Text("");
          }
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      primary:false,
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return VengamoChatUI(
                          textColor: snapshot.data!.data()!["Content"][index]
                                      ["owner"] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Colors.white
                              : Colors.black,
                          senderBgColor: Colors.blue.shade500,
                          receiverBgColor: Colors.grey.shade300,
                          isSender: snapshot.data!.data()!["Content"][index]
                                      ["owner"] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? true
                              : false,
                          isNextMessageFromSameSender: false,
                          time: "time",
                          timeLabelColor: Colors.black,
                          text:
                              "${snapshot.data!.data()!["Content"][index]["Content_msg"]}",
                          pointer: false,
                          ack: snapshot.data!.data()!["Content"][index]
                                      ["seen"] ==
                                  true
                              ? const Icon(
                                  Icons.check,
                                  color: Colors
                                      .black, // You can customize the color here
                                  size: 13, // You can customize the size here
                                )
                              : Text(""),
                        );
                      },
                      itemCount: snapshot.data!.data()!["Content"].length,
                    ),
                  ),
                  Container(child: Row(

                    children: [

                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: CircleAvatar(
                          radius: 30,
                          child: Icon(
                            Icons.mic_rounded,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        onTap: () {


                          Record();
                        },
                      ),
                      Expanded(
                        child: TextFormField(
                          focusNode: focus_node,
                          onChanged: (value) {
                            c2.Update(value);
                          },
                          controller: message_controller,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(),

                            alignLabelWithHint: true,
                              filled: true,
                              fillColor: Colors.grey.shade300,
                              hintText: "Message",
                              suffixIcon: IconButton(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  icon: Icon(Icons.emoji_emotions_sharp),
                                  onPressed: () {
                                    print("recording");
                                  }),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(50))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: CircleAvatar(
                            radius: 30,
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.blue,
                          ),
                          onTap: () {
                            List<dynamic> content =
                            snapshot.data!.data()!["Content"];
                            content.add({
                              "Content_msg": message_controller.text,
                              "Time": Timestamp.now(),
                              "owner": FirebaseAuth.instance.currentUser!.uid,
                              "seen": false
                            });

                            FirebaseFirestore.instance
                                .collection("Discussions")
                                .doc(snapshot.data!.id)
                                .update({
                              "Content": content,
                              "time": Timestamp.now()
                            });
                            message_controller.clear();
                          },
                        ),
                      )
                    ],
                  ),height: MediaQuery.of(context).size.height*6/100,)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
