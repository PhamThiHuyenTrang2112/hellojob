import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:image_picker/image_picker.dart';

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

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    // final path='files/${pickedFile!.name}';
    // final file =File(pickedFile!.path!);
    if (selectedImages!.isNotEmpty) {
      _image.addAll(selectedImages);
      uploadFile();

    }
    setState(() {
      print('lưu ảnh');
      // final ref=FirebaseStorage.instance.ref().child(path);
      // ref.putFile(file);
    });
  }

  @override
  void initState() {
    super.initState();
    chatReference = FirebaseFirestore.instance.collection('imageURLs');
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference messa =
        FirebaseFirestore.instance.collection('messages');
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
                            (messa.messlist[index].arrimg==null || messa.messlist[index].arrimg.length == 0)? Container():
                              Row(
                                children: [
                                  for(int i=0;i<messa.messlist[index].arrimg.length;i++)

                                      Image.network(messa.messlist[index].arrimg[i],
                                        width: 100,height: 100,

                            ),
                                ],
                              )
                            // StreamBuilder<QuerySnapshot>(
                            //     stream: FirebaseFirestore.instance
                            //         .collection('imageURLs')
                            //         .snapshots(),
                            //     builder: (context, snapshot) {
                            //       return !snapshot.hasData
                            //           ? const Center(
                            //               child: CircularProgressIndicator(),
                            //             )
                            //           : Container(
                            //               width: 300,
                            //               height: 300,
                            //               margin:
                            //                   const EdgeInsets.only(left: 40),
                            //               child: StaggeredGridView.countBuilder(
                            //                   physics:
                            //                       const NeverScrollableScrollPhysics(),
                            //                   staggeredTileBuilder: (index) =>
                            //                       StaggeredTile.count(
                            //                           (index % 7) == 0 ? 3 : 1,
                            //                           (index % 7 == 0) ? 2 : 1
                            //                           //2,3
                            //                           ),
                            //                   // index%7==0?const StaggeredTile.count(2,2):const StaggeredTile.count(1, 1),
                            //                   crossAxisCount: 3,
                            //                   //itemCount: _image.length,
                            //                   itemCount: snapshot.data!.docs.length,
                            //                   itemBuilder:
                            //                       (context, int index) {
                            //                     //return Image.file(File(imageFileList![index].path), fit: BoxFit.cover);
                            //                     return Container(
                            //                       margin:
                            //                           const EdgeInsets.all(3),
                            //                       child:
                            //                           FadeInImage.memoryNetwork(
                            //                               fit: BoxFit.cover,
                            //                               placeholder:
                            //                                   kTransparentImage,
                            //                               image: snapshot
                            //                                   .data!.docs[index]
                            //                                   .get('url')),
                            //                     );
                            //                     // Card(
                            //                     //     child: Image.file(File(imageFileList![index].path), fit: BoxFit.cover,alignment: Alignment.center,scale: 3,)
                            //                     //
                            //                     // );
                            //                   }),
                            //             );
                            //     })
                          ],
                        );
                      },
                      itemCount: messa.messlist.length,
                      //_messages.length,
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


  // chooseImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //   setState(() {
  //     _image.add(File(pickedFile!.path));
  //     uploadFile();
  //   });
  //   if (pickedFile!.path == null) retrieveLostData();
  // }

  // Future<void> retrieveLostData() async {
  //   final LostData response = await picker.getLostData();
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   if (response.file != null) {
  //     setState(() {
  //       _image.add(File(response.file!.path));
  //     });
  //   } else {
  //     print(response.file);
  //   }
  // }

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
        });
      });
    }

    mess
        .add({ 'text': '', 'images': imgs, 'time':DateTime.now().microsecondsSinceEpoch})
        .then((value) => print(" data Added"))
        .catchError((error) => print("data couldn't be added."));
    i++;
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
