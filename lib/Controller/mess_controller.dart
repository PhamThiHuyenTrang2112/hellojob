import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Model/chat_message.dart';

class MessController extends GetxController{
  var isLoading = false;

  var messlist = <ChatMessage>[];


  Future<void> getDataMess() async {
    try{
      QuerySnapshot words = await FirebaseFirestore.instance.collection('messages').get();
      messlist.clear();
      for(var word in words.docs){
        print('đây là ${word}');
        messlist.add(ChatMessage(word['text']));
      }
      isLoading = false;
    } catch(e) {
      Get.snackbar('Error', '${e.toString()}');
    }
    update();
  }
}