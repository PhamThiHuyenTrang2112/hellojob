import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class TemplateOne extends StatefulWidget {
  const TemplateOne({Key? key}) : super(key: key);

  @override
  State<TemplateOne> createState() => _TemplateOneState();
}

class _TemplateOneState extends State<TemplateOne> {
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50,),
         imageFile==null?Container(
           margin: const EdgeInsets.only(bottom: 5),
           //clipBehavior: Clip.hardEdge,
          width: 327,
           height: 223,
           decoration: BoxDecoration(
             color: const Color(-2500135),
             borderRadius: BorderRadius.circular(10)
           ),
           child: IconButton(
             icon: const Icon(Icons.add),
             onPressed: (){
               _getFromGallery();
             },
           ),
         ):Container(
           width: 327,
           height: 223,
           decoration: BoxDecoration(
               color: const Color(-2500135),
               borderRadius: BorderRadius.circular(10)
           ),
           child: Image.file(imageFile!),
         ),
          Row(
            children: [
              const SizedBox(width: 20,),
              Container(
                //clipBehavior: Clip.hardEdge,
                width: 157,
                height: 173,
                decoration: BoxDecoration(
                    color: const Color(-2500135),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: (){

                  },
                ),
              ),
              const SizedBox(width: 5,),
              Container(
                //clipBehavior: Clip.hardEdge,
                width: 157,
                height: 173,
                decoration: BoxDecoration(
                    color: Color(-2500135),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: (){

                  },
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.send),

      ),
    );
  }
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

}
