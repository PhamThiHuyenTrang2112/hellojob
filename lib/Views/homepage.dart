import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:word_bank/Controller/word_controller.dart';
import 'package:word_bank/Views/chatpage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WordController wordController = Get.put(WordController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WordController>(
        init: WordController(),
        initState: (_){},
        builder: (wordController){
          wordController.getData();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.yellow,
              title: const Text('List User', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  // fontStyle: FontStyle.italic,
                  // letterSpacing: 2
              ),),
            ),
            body: Center(
              //child: wordController.isLoading ? const CircularProgressIndicator() :
              child:
                  ListView.builder(
                    itemCount: wordController.wordList.length,
                    itemBuilder: (BuildContext context, index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  const ChatPage()),
                            );
                          },
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  // child: Container(
                                  //   width: 60,
                                  //     height: 60,
                                  //     child: Image.network(wordController.wordList[index].image,fit: BoxFit.cover,)
                                  // ),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: wordController.wordList[index].image,
                                    imageBuilder: (context, imageProvider){
                                      return Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover
                                          )
                                        ),
                                      );

                                    },
                                    placeholder: (context, url) =>  const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(wordController.wordList[index].name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),overflow: TextOverflow.visible,textAlign: TextAlign.start),
                                    Text(wordController.wordList[index].sex, style: const TextStyle(fontSize: 16),overflow: TextOverflow.visible,textAlign: TextAlign.start,),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ),
          );
        });
  }
}
