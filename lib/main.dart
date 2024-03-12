import 'package:chat_app/Midllewares/My_midllewre.dart';
import 'package:chat_app/Pages/Add_Story.dart';
import 'package:chat_app/Pages/Dusscussion.dart';
import 'package:chat_app/Pages/Sign_up.dart';
import 'package:chat_app/Pages/Story_View.dart';
import 'package:chat_app/Pages/confirm_email.dart';
import 'package:chat_app/Pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/Message.dart';
import 'firebase_options.dart';

import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(
            name: "/message",
            page: () =>  Message(),

        ),
        GetPage(
          name: "/",
          page: () => const MyHomePage(),
          middlewares: [My_middleware()]
        ),
        GetPage(
            name: "/profile",
            page: () => const MyHomePage(),

        ),
        GetPage(
          name: "/confirm",
          page: () => const confirm_email(),
        ),
        GetPage(
          name: "/story_view",
          page: () => const Story_View(),
        ),
        GetPage(
          name: "/discuss",
          page: () => const Dusscussion(),
        ),
        GetPage(
          name: "/sign_up",
          page: () => const Sign_up(),
        ),
        GetPage(
          name: "/login",
          page: () => const login(),
        ),
        GetPage(
          name: "/add_story",
          page: () => const Add_Story(),
        )
      ],
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Nunito",
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

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
              child: Image.asset("assets/message.jpg"),
            ),
          ),
          Center(
              child: Container(
            height: MediaQuery.of(context).size.height * 20 / 100,
            width: MediaQuery.of(context).size.width * 90 / 100,
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 5 / 100),
            child: Text(
                "Welcome to Chat App \n Connect with friends, family, and colleagues effortlessly",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center),
          )),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 80 / 100,
              height: MediaQuery.of(context).size.height * 35 / 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 80 / 100,
                    height: MediaQuery.of(context).size.height * 10 / 100,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          // You can customize other properties as well, such as padding, shape, etc.
                        ),
                        child: Text(
                          "Signup",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        onPressed: () {
                          Get.toNamed("/sign_up");
                        }),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 80 / 100,
                    height: MediaQuery.of(context).size.height * 10 / 100,
                    child: ElevatedButton(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        onPressed: () {
                          Get.toNamed("/login");
                        }),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
