import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:word_bank/Model/word_model.dart';

class WordController extends GetxController{
  var isLoading = false;
  var wordList = <WordModel>[];

  Future<void> getData() async {
    try{
      QuerySnapshot words = await FirebaseFirestore.instance.collection('User').orderBy('name').get();
      wordList.clear();
      for(var word in words.docs){
        print(word.id);
        print(wordList);
        wordList.add(WordModel(word['name'], word['sex'],word['image'], word.id));
      }
      isLoading = false;
    } catch(e) {
      Get.snackbar('Error', '${e.toString()}');
    }
  }
}