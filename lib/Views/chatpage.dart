import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../Controller/word_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

_handleTouchOnCamera() {}

_handleTouchOnGalleryPhoto() {}

class _ChatPageState extends State<ChatPage> {
  final _textController = TextEditingController();
  bool isComposing = false;
  int index=0;
  //final List<ChatMessage> _list=[];
  @override
  Widget build(BuildContext context) {
    return  GetBuilder<WordController>(
        init: WordController(),
        initState: (_){},
        builder: (wordController) {
          wordController.getData();
          return Scaffold(
            appBar: AppBar(
              title:  Text(wordController.wordList[index].name,),
            ),
            body: SafeArea(
                child: Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                        //controller: _controller,
                          padding: const EdgeInsets.all(8.0),
                          reverse: true,
                          itemBuilder: (_, int index) {
                            return const Text('we coming soon');
                          }
                        //=> _messages[index],
                        //itemCount: _messages.length,
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
                )),
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
                onPressed: () => _handleTouchOnGalleryPhoto()),
          ),
          Expanded(
            child: _buildTextInput(),

          ),
        ],
      ),
    );
  }

}

