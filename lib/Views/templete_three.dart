
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Controller/upload_image.dart';

class TempleteThree extends StatefulWidget {
  String userid='';


  TempleteThree(this.userid);

  @override
  State<TempleteThree> createState() => _TempleteThreeState();
}

class _TempleteThreeState extends State<TempleteThree> {
  File? imageFile;
  File? imageFile1;
  File? imageFile2;
  late UploadImage uploadimage = UploadImage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50,),

          Row(
            children: [
              const SizedBox(width: 20,),
              imageFile==null?Container(
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
                    _getFromGallery(1);
                  },
                ),
              ):Container(
                width: 157,
                height: 173,
                decoration: BoxDecoration(
                    color: const Color(-2500135),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Image.file(imageFile!),
              ),
              const SizedBox(width: 5,),
              imageFile1==null? Container(
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
                    _getFromGallery(2);
                  },
                ),
              ):Container(
                width: 157,
                height: 173,
                decoration: BoxDecoration(
                    color: const Color(-2500135),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Image.file(imageFile1!),
              ),
            ],
          ),
          imageFile2==null?Container(
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
                _getFromGallery(3);
              },
            ),
          ):Container(
            width: 327,
            height: 223,
            decoration: BoxDecoration(
                color: const Color(-2500135),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Image.file(imageFile2!),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          List<XFile> lstFile = [];
          if(imageFile != null){
            lstFile.add(XFile(imageFile!.path));
          }
          if(imageFile1 != null){
            lstFile.add(XFile(imageFile1!.path));
          }
          if(imageFile2 != null){
            lstFile.add(XFile(imageFile2!.path));
          }
          uploadimage.uploadFile(lstFile, widget.userid, 3);
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.send),

      ),
    );
  }
  _getFromGallery(int numb) async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        switch(numb)
        {
          case 1:
            imageFile = File(pickedFile.path);
            break;
          case 2:
            imageFile1 = File(pickedFile.path);
            break;
          case 3:
            imageFile2 = File(pickedFile.path);
            break;
        }
      });
    }
  }
}
