import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadImage{
  List<XFile> _image = [];
  late bool _permissionReady;
  TargetPlatform? platform;
  late String _localPath;

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

    var newmess = {'userid': "widget.userid", 'text': '', 'images': imgs, 'time':DateTime.now().microsecondsSinceEpoch,'imageslocal': imaglocals};

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
}