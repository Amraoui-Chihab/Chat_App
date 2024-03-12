
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class My_middleware extends GetMiddleware
{
  @override
  RouteSettings? redirect(String? route) {
   if(FirebaseAuth.instance.currentUser!=null)
     {
       if(FirebaseAuth.instance.currentUser!.emailVerified==true)
         {
           return RouteSettings(name: "/discuss");
         }
       else
         {
           return RouteSettings(name: "/confirm");
         }
     }
   return null;

  }
}