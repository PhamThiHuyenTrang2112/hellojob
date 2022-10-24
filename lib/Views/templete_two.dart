
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Controller/upload_image.dart';

class TempleteTwo extends StatefulWidget {
  String userid='';


  TempleteTwo(this.userid);

  @override
  State<TempleteTwo> createState() => _TempleteTwoState();
}

class _TempleteTwoState extends State<TempleteTwo> {
  File? imageFile;

  File? imageFile1;
  File? imageFile2;
  File? imageFile3;
  late UploadImage uploadimage = UploadImage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 30,),
          Row(
            children: [
              const SizedBox(width: 20,),
              imageFile==null?Container(
                margin: const EdgeInsets.only(bottom: 5),
                //clipBehavior: Clip.hardEdge,
                width: 157,
                 height: 290,
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
                height: 290,
                decoration: BoxDecoration(
                    color: const Color(-2500135),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Image.file(imageFile!,width: 157,fit: BoxFit.cover,),

              ),
              const SizedBox(width: 5,),
              imageFile1==null?Container(
                margin: const EdgeInsets.only(bottom: 5),
                //clipBehavior: Clip.hardEdge,
                width: 157,
                height: 290,
                decoration: BoxDecoration(
                    color: const Color(-2500135),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: (){
                    _getFromGallery(2);
                  },
                ),
              ):Container(
                width: 157,
                height: 290,
                decoration: BoxDecoration(
                    color: const Color(-2500135),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Image.file(imageFile1!,width: 157,fit: BoxFit.cover),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 20,),
              imageFile2==null?Container(
                //clipBehavior: Clip.hardEdge,
                width: 157,
                height: 290,
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
                width: 157,
                height: 290,
                decoration: BoxDecoration(
                    color: const Color(-2500135),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Image.file(imageFile2!,width: 157,fit: BoxFit.cover),
              ),
              const SizedBox(width: 5,),
              imageFile3==null? Container(
                //clipBehavior: Clip.hardEdge,
                width: 157,
                height: 290,
                decoration: BoxDecoration(
                    color: Color(-2500135),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: (){
                    _getFromGallery(4);
                  },
                ),
              ):Container(
                width: 157,
                height: 290,
                decoration: BoxDecoration(
                    color: const Color(-2500135),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Image.file(imageFile3!,width: 157,fit: BoxFit.cover),
              ),
            ],
          )
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
          if(imageFile3 != null){
            lstFile.add(XFile(imageFile3!.path));
          }
          uploadimage.uploadFile(lstFile, widget.userid, 2);
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
          case 4:
            imageFile3 = File(pickedFile.path);
            break;
        }
      });
    }
  }
}
