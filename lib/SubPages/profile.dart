import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 3 / 100,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 5 / 100),
              child: Row(
                children: [
                  Text(
                    "Profile",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width * 90 / 100,
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 2 / 100),
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircleAvatar(
                      radius: 70,
                    );
                  }
                  if (snapshot.hasError) {
                    return CircleAvatar(
                      radius: 70,
                    );
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return CircleAvatar(
                      radius: 70,
                    );
                  }
                  return Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data!["Image"]),
                        radius: 70,
                      ),
                      Text(
                        snapshot.data!["Username"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ],
                  );
                },
              ),
            ),
          ),

          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 90 / 100,
              margin: EdgeInsets.only(top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Account",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(
                      Icons.supervised_user_circle_sharp,
                      color: Colors.blue,
                    ),
                    subtitle: Text("Value"),
                    title: Text(
                      "Username",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(
                      CupertinoIcons.lock_shield_fill,
                      color: Colors.blue,
                    ),
                    title: Text(
                      "Password",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text("General Settings",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ListTile(
                    leading: Icon(
                      Icons.dark_mode,
                      color: Colors.blue,
                    ),
                    subtitle: Text("Off"),
                    title: Text(
                      "Dark Mode",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.language,
                      color: Colors.blue,
                    ),
                    subtitle: Text("English"),
                    title: Text(
                      "Language",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.blue,
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
