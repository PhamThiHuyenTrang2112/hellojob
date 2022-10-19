import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:word_bank/Controller/mess_controller.dart';

import 'package:path/path.dart' as Path;
import '../Binding/utility.dart';

final firestore = FirebaseFirestore.instance;

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool uploading = false;
  double val = 0;

  List<XFile> _image = [];
  final picker = ImagePicker();

  // var type;
  String message = "";


  var sort;
  final _textController = TextEditingController();
  late Image imageFromPreferences;
  final ImagePicker imagePicker = ImagePicker();
  bool isComposing = false;
  late CollectionReference chatReference;
  PlatformFile? pickedFile;
  int index = 0;
  List<XFile>? imageFileList = [];
  late String _uploadedFileURL;
  bool isupload=false;

  void selectImages() async {
    Get.find<MessController>().getDataImage();
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {

      _image.addAll(selectedImages);
      uploadFile();
    }
    setState(() {
      isupload=true;
    });
  }


  @override
  void initState() {
    super.initState();
    chatReference = FirebaseFirestore.instance.collection('imageURLs');
  }

  @override
  Widget build(BuildContext context) {
    // CollectionReference messa =
    //     FirebaseFirestore.instance.collection('messages');
    return Scaffold(
        backgroundColor: Color(-2633006),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Hello chat",
          ),
        ),
        body: GetBuilder<MessController>(
            init: MessController(),
            builder: (messa) {
              messa.getDataMess();
              return Column(
                children: <Widget>[
                  Flexible(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            (messa.messlist[index].messageContent.isEmpty || messa.messlist[index].messageContent == '' || messa.messlist[index].messageContent.length == 0)?SizedBox():Container(
                              margin:
                                  const EdgeInsets.only(bottom: 10, right: 10),
                              height: 45,
                              width: 150,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ), //
                              ),
                              child: Align(
                                  alignment: Alignment.center,
                                  child:  Text(
                                      messa.messlist[index].messageContent)
                              ),
                            ),

                            (messa.messlist[index].arrimg.isEmpty)? Container():
                              Column(
                                children: [
                                  for(int i=0;i<messa.messlist[index].arrimg.length;i++)
                                    messa.messlist[index].type? Image.file(File(_image[0].path), fit: BoxFit.cover): CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: messa.messlist[index].arrimg[i],
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
                                 )

                                ],
                              )
                          ],
                        );
                      },
                      itemCount: messa.messlist.length,

                    ),
                  ),
                  Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).cardColor),
                    child: _buildTextComposer(),
                  ),
                ],
              );
            }));
  }

  Future uploadFile() async {
    int i = 1;
    CollectionReference mess =
    FirebaseFirestore.instance.collection('messages');
    List<String> imgs = [];

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('chats/${Path.basename(img.path)}');
      File fileX = File(img.path);
      await firebaseStorageRef.putFile(fileX).whenComplete(() async {
        await firebaseStorageRef.getDownloadURL().then((value) {
          chatReference.add({'url': value});
          imgs.add(value);
          i++;
        });
      });
    }
    mess
        .add({ 'text': '', 'images': imgs, 'time':DateTime.now().microsecondsSinceEpoch})
        .then((value) => print(" data Added"))
        .catchError((error) => print("data couldn't be added."));
  }

  Widget _buildTextInput() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color(0xFF000000),
            width: 1.0,
            style: BorderStyle.solid),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ), //
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onChanged: (String text) {
                setState(() {
                  //  _isComposing = text.length > 0;
                });
              },
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              minLines: 1,
              decoration:
                  const InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          Container(
            child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  _handleSubmitted(_textController.text);
                }),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    CollectionReference mess =
        FirebaseFirestore.instance.collection('messages');
    _textController.clear();
    // ChatMessage chatMessage =  ChatMessage(text: text);
    setState(() {
      //_messages.insert(0, chatMessage);
      mess
          .add({'text': text, 'images': [],'time':DateTime.now().microsecondsSinceEpoch})
          .then((value) => print(" data Added"))
          .catchError((error) => print("data couldn't be added."));
    });
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: const IconThemeData(color: Colors.cyan),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: IconButton(
                icon: const Icon(Icons.photo_camera), onPressed: () {}),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: IconButton(
                icon: const Icon(Icons.photo_library),
                onPressed: () => selectImages()),
          ),
          Expanded(
            child: _buildTextInput(),
          ),
        ],
      ),
    );
  }
}
