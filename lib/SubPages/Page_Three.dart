import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Page_Three extends StatefulWidget {
  const Page_Three({super.key});

  @override
  State<Page_Three> createState() => _Page_ThreeState();
}

class _Page_ThreeState extends State<Page_Three> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 5 / 100,
              width: MediaQuery.of(context).size.width * 90 / 100,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 5 / 100),
              child: Row(
                children: [
                  Text(
                    "People",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 5 / 100,
              width: MediaQuery.of(context).size.width * 90 / 100,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 3 / 100),
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.add_circled_solid,
                      color: Colors.lightBlue,
                    ),
                    Container(
                      child: Text(
                        "Add new contact",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue),
                      ),
                      margin: EdgeInsets.only(left: 5),
                    )
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 5 / 100,
              width: MediaQuery.of(context).size.width * 90 / 100,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 2 / 100),
              child: Row(
                children: [
                  Text(
                    "Active now",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 2 / 100),
              height: MediaQuery.of(context).size.height * 63 / 100,
              width: MediaQuery.of(context).size.width * 90 / 100,
              child: Center(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text("Error");
                    }
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Text("No Friends Yet");
                    }
                    return Center(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .where("id", whereIn: snapshot.data!["Friends"])
                            .orderBy('status', descending: true)
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
                            return Text('empty');
                          }
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return ListTile(
                                trailing: Container(
                                  width: 100,
                                  child: snapshot.data!.docs[index]["status"] ==
                                          true
                                      ? FittedBox(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.phone,
                                                      color: Colors.lightBlue
                                                  )),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.video_call,color: Colors.lightBlue,))
                                            ],
                                          ),
                                        )
                                      : null,
                                ),
                                onTap: () {},
                                subtitle:
                                    snapshot.data!.docs[index]["status"] == true
                                        ? Text("Active now")
                                        : Text("Active 5h ago"),
                                leading: Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          snapshot.data!.docs[index]["Image"]),
                                    ),
                                    snapshot.data!.docs[index]["status"] == true
                                        ? Positioned(
                                            left: 25,
                                            top: 27,
                                            child: CircleAvatar(
                                              radius: 6,
                                              backgroundColor: Colors.green,
                                            ),
                                          )
                                        : Text("")
                                  ],
                                ),
                                title: Text(
                                  "${snapshot.data!.docs[index]["Username"]}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                            itemCount: snapshot.data!.docs.length,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
