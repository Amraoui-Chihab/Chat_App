import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController c1 = new TextEditingController();
  TextEditingController c2 = new TextEditingController();
  Future<bool> Login_user() async {
    try {
      UserCredential uc =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: c1.text.trim(),
        password: c2.text,
      );




      return true;
    } catch (e) {
      // Handle login errors
      Get.snackbar("Error",
          "Error during login: ${e is FirebaseAuthException ? e.message : e}",
          backgroundColor: Colors.blue);

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
                height: MediaQuery.of(context).size.height * 35 / 100,
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 5 / 100),
                width: MediaQuery.of(context).size.width * 85 / 100,
                child: Column(
                  children: [
                    Container(
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: c1,
                        decoration: InputDecoration(
                            labelText: "Email",
                            icon: Icon(
                              Icons.email,
                              color: Colors.blue,
                            )),
                      ),
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 2.5 / 100),
                    ),
                    Container(
                      child: TextField(
                        obscureText: true,
                        controller: c2,
                        decoration: InputDecoration(
                            labelText: "Passowrd",
                            icon: Icon(
                              CupertinoIcons.padlock_solid,
                              color: Colors.blue,
                            )),
                      ),
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 2.5 / 100),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 2.5 / 100),
                      width: MediaQuery.of(context).size.width * 80 / 100,
                      height: MediaQuery.of(context).size.height * 10 / 100,
                      child: ElevatedButton(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          onPressed: () async {
                            if (c1.text == "" || c2.text == "") {
                              Get.snackbar("Error", "Please fill all fields",
                                  backgroundColor: Colors.blue);
                            } else {
                              RegExp emailRegExp = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                              if (!emailRegExp.hasMatch(c1.text)) {
                                Get.snackbar("Error", "Email not Valid",
                                    backgroundColor: Colors.blue);
                              } else {
                                bool user_login = await Login_user();
                                FocusScope.of(context).unfocus();
                                if (user_login) {

                                  Get.defaultDialog(
                                    title:"Logging In",
                                      content: CircularProgressIndicator(
                                    color: Colors.blue,
                                  ));
                                  await Future.delayed(Duration(seconds: 5));
                                  if(FirebaseAuth.instance.currentUser!.emailVerified)
                                    {
                                      Get.offNamed("/discuss");
                                    }
                                  else
                                    {
                                      Get.offNamed("/confirm");
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
