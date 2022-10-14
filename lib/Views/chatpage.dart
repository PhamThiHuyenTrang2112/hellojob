import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:image_picker/image_picker.dart';

import '../Controller/word_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

_handleTouchOnCamera() {}



class _ChatPageState extends State<ChatPage> {
  var _image;

  // var type;
  var sort;
  final _textController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  bool isComposing = false;

  int index=0;
  List<XFile>? imageFileList = [];
  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {
    });
  }
  Widget CustomSelect(){
    return Column(
      children: [
        IconButton(onPressed: (){

        },
            icon: const Icon(Icons.send)),

      ],
    );
  }
  @override

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<WordController>(
        init: WordController(),
        initState: (_){},
        builder: (wordController) {
          wordController.getData();
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title:  Text(wordController.wordList[index].name,),
            ),
            body: Column(
              children: [
                Flexible(
                  child:  StaggeredGridView.countBuilder(
                    scrollDirection:Axis.vertical,
                    staggeredTileBuilder: (index)=>StaggeredTile.count(2,index.isEven?2:1),
                          crossAxisCount: 4,
                      itemCount: imageFileList!.length,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      itemBuilder: (context, int index) {
                        return Image.file(File(imageFileList![index].path), fit: BoxFit.cover);
                      }
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: SafeArea(
                    bottom: true,
                    child: _buildTextComposer(),
                  ),
                ),
              ],
            ),
          );

        }

    );
  }

  Widget _buildTextInput() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.only(left: 8.0),
      decoration:  BoxDecoration(
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
              decoration: const InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          Container(
            child: IconButton(icon: const Icon(Icons.send), onPressed: () {
              _handleSubmitted(_textController.text);
            }),
          ),
        ],
      ),
    );
  }

void _handleSubmitted(String text) {
  _textController.clear();


}
  // _handleTouchOnGalleryPhoto() async {
  //   var source = ImageSource.gallery;
  //   XFile image = await imagePicker.pickImage(
  //       source: source,
  //       imageQuality: 85,
  //       preferredCameraDevice: CameraDevice.front);
  //   setState(() {
  //     _image = File(image.path);
  //   });
  // }

  Widget _buildTextComposer() {
    return IconTheme(
      data: const IconThemeData(color: Colors.cyan),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: IconButton(
                icon: const Icon(Icons.photo_camera), onPressed: () {

            }),
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

