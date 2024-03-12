import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Sign_up extends StatefulWidget {
  const Sign_up({super.key});

  @override
  State<Sign_up> createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> {
  TextEditingController c1 = new TextEditingController();
  TextEditingController c2 = new TextEditingController();
  TextEditingController c3 = new TextEditingController();
  TextEditingController c4 = new TextEditingController();
  Future<bool> Check_Username() async {
    QuerySnapshot<Map<String, dynamic>> RESPONSE = await FirebaseFirestore
        .instance
        .collection("users")
        .where("Username", isEqualTo: c1.text)
        .get();
    return RESPONSE.size == 0 ? false : true;
  }

  Future<bool> Check_email() async {
    QuerySnapshot<Map<String, dynamic>> RESPONSE = await FirebaseFirestore
        .instance
        .collection("users")
        .where("Email", isEqualTo: c2.text)
        .get();
    return RESPONSE.size == 0 ? false : true;
  }

  Future<bool> Register_new_user(
      String username, String email, String Password) async {
    try {
      UserCredential uc = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: Password);
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uc.user!.uid)
          .set({
        'Username': username,
        'Email': email.trim(),
      });

      // User login successful, you can now navigate to another screen or perform additional tasks.


      return true;
    } catch (e) {
      Get.snackbar("Error",
          "Error in Registration Because : ${e is FirebaseAuthException ? e.message : e}",
          backgroundColor: Colors.blue);
      // Handle login errors
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 5 / 100),
                width: MediaQuery.of(context).size.width * 85 / 100,
                child: Image.asset("assets/message.jpg"),
                height: MediaQuery.of(context).size.height * 30 / 100,
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 5 / 100),
                width: MediaQuery.of(context).size.width * 85 / 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: TextField(
                        controller: c1,
                        decoration: InputDecoration(
                            labelText: "Username",
                            icon: Icon(
                              Icons.account_circle,
                              color: Colors.blue,
                            )),
                      ),
                    ),
                    Container(
                      child: TextField(
                        controller: c2,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Email",
                            icon: Icon(
                              Icons.email_rounded,
                              color: Colors.blue,
                            )),
                      ),
                    ),
                    Container(
                      child: TextField(
                        controller: c3,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            labelText: "Password",
                            icon: Icon(
                              CupertinoIcons.padlock_solid,
                              color: Colors.blue,
                            )),
                      ),
                    ),
                    Container(
                      child: TextField(
                        controller: c4,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            labelText: "Confirm Password",
                            icon: Icon(
                              CupertinoIcons.padlock_solid,
                              color: Colors.blue,
                            )),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 60 / 100,
                      height: MediaQuery.of(context).size.height * 10 / 100,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),

                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            // You can customize other properties as well, such as padding, shape, etc.
                          ),
                          child: Text(
                            "Signup",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (c1.text == "" ||
                                c2.text == "" ||
                                c3.text == "" ||
                                c4.text == "") {
                              Get.snackbar("Error", "Please fill all fileds",
                                  backgroundColor: Colors.blue);
                            } else {
                              if (c3.text != c4.text) {
                                Get.snackbar("Error",
                                    "Password and Confirmation does not match",
                                    backgroundColor: Colors.blue);
                              } else {
                                RegExp usernameRegExp =
                                    RegExp(r'^[a-zA-Z0-9_]{3,15}$');
                                if (!usernameRegExp.hasMatch(c1.text)) {
                                  Get.snackbar("Error", "Username is not valid",
                                      backgroundColor: Colors.blue);
                                } else {
                                  RegExp emailRegExp = RegExp(
                                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                                  if (!emailRegExp.hasMatch(c2.text)) {
                                    Get.snackbar("Error", "Email is not valid",
                                        backgroundColor: Colors.blue);
                                  } else {
                                    bool username_exist =
                                        await Check_Username();
                                    if (username_exist) {
                                      Get.snackbar(
                                          "Error", "Username Already Exist",
                                          backgroundColor: Colors.blue);
                                    } else {
                                      bool email_exist = await Check_email();
                                      if (email_exist) {
                                        Get.snackbar(
                                            "Error", "Email Already Exist",
                                            backgroundColor: Colors.blue);
                                      } else {
                                        FocusScope.of(context).unfocus();
                                        bool user_registred =
                                            await Register_new_user(
                                                c1.text, c2.text, c3.text);
                                        if (user_registred) {

                                          Get.defaultDialog(
                                              title: "Succesfully Registred \n Just Wait",
                                              content:
                                                  CircularProgressIndicator(
                                                color: Colors.blue,
                                              ));
                                          await Future.delayed(Duration(seconds: 5));
                                          Get.offNamed("/confirm");
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }),
                    )
                  ],
                ),
                height: MediaQuery.of(context).size.height * 55 / 100,
              ),
            )
          ],
        ),
      ),
    );
  }
}
