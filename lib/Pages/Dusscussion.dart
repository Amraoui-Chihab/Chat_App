import 'package:chat_app/SubPages/Page_One.dart';
import 'package:chat_app/SubPages/Page_Three.dart';
import 'package:chat_app/SubPages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';

class Dusscussion extends StatefulWidget {
  const Dusscussion({super.key});

  @override
  State<Dusscussion> createState() => _DusscussionState();
}

class _DusscussionState extends State<Dusscussion> {
  int Current_index_of_page = 0;
  PageController page_controller = PageController();
  List<Widget> Pages = [
    Page_One(),
    Text("page two"),
    Page_Three(),
    profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Center(
          child: Container(
            child: Center(
              child: PageView.builder(
                itemCount: Pages.length,
                itemBuilder: (context, index) => Center(
                  child: Pages[Current_index_of_page],
                ),
                onPageChanged: (value) {
                  setState(() {
                    Current_index_of_page = value;
                  });
                },
              ),
            ),
            height: MediaQuery.of(context).size.height * 90 / 100,
          ),
        ),
        Center(
          child: Container(
            child: BottomBarDefault(
              titleStyle: TextStyle(fontWeight: FontWeight.bold),
              indexSelected: Current_index_of_page,
              onTap: (index) {
                setState(() {
                  Current_index_of_page = index;
                });
              },
              items: [
                TabItem(
                    icon: CupertinoIcons.chat_bubble_fill,
                    title: "Chats",
                    count: CircleAvatar(
                      child: Text("4"),
                      backgroundColor: Colors.red,
                      radius: 10,
                    )),
                TabItem(icon: CupertinoIcons.phone_fill, title: "Calls"),
                TabItem(icon: Icons.people_alt_rounded, title: "People"),
                TabItem(
                  icon: CupertinoIcons.profile_circled,
                  title: "Profile",
                )
              ],
              backgroundColor: Colors.white,
              color: Colors.grey,
              colorSelected: Colors.blue,
            ),
            height: MediaQuery.of(context).size.height * 10 / 100,
          ),
        )
      ],
    ));
  }
}
