import 'package:dio/dio.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:word_bank/Controller/mess_controller.dart';

import 'package:path/path.dart' as Path;
import 'package:word_bank/Views/template_one.dart';

import '../Binding/utility.dart';
import '../Model/word_model.dart';
import 'display_image.dart';

final firestore = FirebaseFirestore.instance;

class ChatPage extends StatefulWidget {
  String userid='';
  String username='';



  ChatPage(this.userid,this.username);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool uploading = false;

  late String _localPath;
  late bool _permissionReady;
  TargetPlatform? platform;

   String userid='';

  double val = 0;

  List<XFile> _image = [];
  final picker = ImagePicker();

  // var type;


  var sort;
  final _textController = TextEditingController();
  late Image imageFromPreferences;
  final ImagePicker imagePicker = ImagePicker();
  bool isComposing = false;
  late CollectionReference chatReference;
  PlatformFile? pickedFile;
  int index = 0;
  late String _uploadedFileURL;


  void selectImages() async {

    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      _image!.addAll(selectedImages);
      uploadFile();

    }
    setState(() {

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
          title:  Text(
            widget.username
          ),
        ),
        body: GetBuilder<MessController>(
            init: MessController(),
            builder: (messa) {
              messa.getDataMess(widget.userid);
              return Column(
                children: <Widget>[
                  Flexible(
                    child:  ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) {
                        return
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            (messa.messlist[index].messageContent.isEmpty || messa.messlist[index].messageContent == '' || messa.messlist[index].messageContent.length == 0)?Container():Container(
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
                                      messa.messlist[index].messageContent
                                  )
                              ),
                            ),

                              (messa.messlist[index].arrimglocal.length<=0 || messa.messlist[index].arrimglocal.isEmpty)? Container():
                             Container(
                                width: 250,
                                 margin: const EdgeInsets.only(bottom: 10),
                                 clipBehavior: Clip.hardEdge,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(20),
                                 ),
                                 child:
                                 DisplayTemplate(messa.messlist[index].templete,messa.messlist[index].arrimglocal))

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
  Widget DisplayTemplate(int index,List<dynamic> listimg){
    switch(index){
      case 1: return DisplayImage(listimg);
      break;
      default:
        return _columImg(listimg);
        break;
    }

  }
  Future uploadFile() async {
    CollectionReference mess =
    FirebaseFirestore.instance.collection('messages');
    List<String> imgs = [];
    List<String> imaglocals = [];
    String idmess = '';
    List<XFile> datas = _image;
    _image = [];

    for (var img in datas) {
      _permissionReady = await _checkPermission();

      print("_permissionReady: $_permissionReady");
      if (_permissionReady) {
        await _prepareSaveDir();
        print("Save file");
        try {
          final File image = File(img.path);
          var fileName = img.name;
          // copy the file to a new path
          final File newImage = await image.copy('$_localPath/$fileName');
          imaglocals.add(newImage.path);
          print("file local ." + newImage.path);

          print("Save Completed.");
        } catch (e) {
          print("Save Failed.\n\n" + e.toString());
        }
      }
    }

    var newmess = {'userid': widget.userid,'templete': 0, 'text': '', 'images': imgs, 'time':DateTime.now().microsecondsSinceEpoch,'imageslocal': imaglocals};

    mess
        .add(newmess)
        .then((value) {
      idmess = value.id;
      print(" data Added");
    }
    )
        .catchError((error) => print("data couldn't be added."));

    for (var img in datas) {
      File fileX = File(img.path);

      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('chats/${Path.basename(img.path)}');
      await firebaseStorageRef.putFile(fileX).whenComplete(() async {
        await firebaseStorageRef.getDownloadURL().then((url) {
          imgs.add(url);
        });
      });
    }

    newmess['images'] = imgs;

    mess.doc(idmess).update(newmess);
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    // print(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/sdcard/download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return directory.path + Platform.pathSeparator + 'Download';
    }
  }

  Widget _columImg(List<dynamic> lstImg){
    return Column(
      children: [
        for(var i = 0; i < lstImg.length; i=i+3)
          _rowImg(i<lstImg.length? lstImg[i]: '', i+1<lstImg.length? lstImg[i+1]: '', i+2<lstImg.length? lstImg[i+2]: '')

      ],
    );
  }

  Widget _rowImg(String img1, String img2, String img3){
    int count= 0;
    double h=0;
    if(img1.isNotEmpty) {
      count++;
    }
    if(img2.isNotEmpty) {
      count++;
    }
    if(img3.isNotEmpty) {
      count++;
    }
    if(count==1) {
      h = 180;
    }
    if(count==2) {
      h = 160;
    }
    if(count==3) {
      h = 120;
    }

    return Row(
      children: [
        if(img1.isNotEmpty)
          Expanded(child:
            FullScreenWidget(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.file(File(img1), fit: BoxFit.cover, height: h,),
            ),
          )
          ),
        if(img2.isNotEmpty)
          Expanded(child:
            FullScreenWidget(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.file(File(img2), fit: BoxFit.cover, height: h,),
            ),
          )
          ),
        if(img3.isNotEmpty)
          Expanded(child:
          FullScreenWidget(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.file(File(img3), fit: BoxFit.cover, height: h,),
            ),
          )
          )

      ],
    );
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
          .add({ 'userid': widget.userid, 'templete': 0,  'text': text, 'images': [],'time':DateTime.now().microsecondsSinceEpoch, 'imageslocal': []})
          .then((value) => print(" data Added"))
          .catchError((error) => print("data couldn't be added."));
    });
  }

  showDataAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.only(
              top: 10.0,
            ),
            title: const Center(
              child: Text(
                "Template",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            content: SizedBox(
              height: 370,
              width:MediaQuery.of(context).size.width,

              child: Column(

                children:  [

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Divider(thickness: 1,)),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>   TemplateOne(widget.userid)),
                          );
                        },
                          child: Image.asset('assets/image/temp1.png',width: 138,height: 138,)),
                      const SizedBox(width: 4,),
                      GestureDetector(
                        onTap: (){
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => const TemplateTwo()),
                          // );
                        },
                          child: Image.asset('assets/image/temp2.png',width: 138,height: 138,)),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => const TemplateThree()),
                          // );
                        }, child: Image.asset('assets/image/temp3.png',)),
                      const SizedBox(width: 4,),
                      GestureDetector(
                        onTap: (){
                          selectImages();

                        },
                          child: Image.asset('assets/image/temp_none.png',width: 138,height: 138,)),
                    ],
                  )
                ],
              ),
            ),
          );
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
                onPressed: () => showDataAlert()),
          ),
          Expanded(
            child: _buildTextInput(),
          ),
        ],
      ),
    );
  }
}
