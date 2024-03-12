
import 'package:get/get.dart';

class Controller extends GetxController{
  RxString msg=''.obs;
  void Update(String new_msg)
  {
    msg=new_msg.obs;
  }


}