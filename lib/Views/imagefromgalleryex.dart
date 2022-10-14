


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageFromGalleryEx extends StatefulWidget {
  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState();
}

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var _image;
  var imagePicker;
  // var type;
  var sort;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image from Gallery")),
      body: Center(
        child: _image != null
            ? Image.file(
          _image,
          width: 100,
          height: 100,
          fit: BoxFit.fitHeight,
        )
            : IconButton(
              icon: const Icon(Icons.photo_library_rounded),
            onPressed: () async {
            var source = ImageSource.gallery;
            XFile image = await imagePicker.pickImage(
                source: source,
                imageQuality: 85,
                preferredCameraDevice: CameraDevice.front);
            setState(() {
              _image = File(image.path);
            });
          },
        ),
      ),
    );
  }
}