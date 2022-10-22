import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Model/chat_message.dart';

class MessController extends GetxController{
  var isLoading = false;

  var messlist = <ChatMessage>[];
  List<dynamic> arrimg=[];
  bool type=false;


  Future<void> getDataMess(String userid) async {
    try{
      QuerySnapshot words = await FirebaseFirestore.instance.collection('messages').where('userid',isEqualTo: userid).orderBy('time', descending:  true).get();
      messlist.clear();
      for(var word in words.docs){
        messlist.add(ChatMessage(word['text'],word['images'],word['imageslocal']));
      }
      isLoading = false;
    } catch(e) {
      Get.snackbar('Error', '${e.toString()}');
    }
    update();
  }

}