import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class confirm_email extends StatefulWidget {
  const confirm_email({super.key});

  @override
  State<confirm_email> createState() => _confirm_emailState();
}

class _confirm_emailState extends State<confirm_email> {
   late Timer t1;
  @override
  void initState() {
    // TODO: implement initState
    t1= Timer.periodic(Duration(seconds: 6), (timer) async {
      print("hi");
      FirebaseAuth.instance.currentUser!.reload();
      if(FirebaseAuth.instance.currentUser!.emailVerified)
        {
          t1.cancel();
          Get.defaultDialog(
              title: "Email Succesfully Confirmed \n Just Wait",
              content:
              Icon(Icons.done));
          await Future.delayed(Duration(seconds: 5));
          Get.toNamed("/discuss");
        }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 5 / 100),
              height: MediaQuery.of(context).size.height * 35 / 100,
              width: MediaQuery.of(context).size.width * 90 / 100,
              child: Image.asset("assets/check_email.jpg"),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 5 / 100),
              height: MediaQuery.of(context).size.height * 15 / 100,
              width: MediaQuery.of(context).size.width * 90 / 100,
              child: Center(
                child: Text(
                  "Waiting For Your Email Confirmation",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 5 / 100),
              height: MediaQuery.of(context).size.height * 15 / 100,
              width: MediaQuery.of(context).size.width * 90 / 100,
              child: Center(
                child: CircularProgressIndicator(color: Colors.lightBlue,),
              ),
            ),
          )
        ],
      ),
    );
  }
}
