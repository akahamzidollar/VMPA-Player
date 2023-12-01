import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  FirebaseStorage storage = FirebaseStorage.instance;
  UploadTask? uploadTask;

  Future<String> uploadImageFile(PlatformFile? pickedImageFile) async {
    late String imageUrl;
    final path = 'imageFiles/${pickedImageFile!.name}';
    final file = File(pickedImageFile.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    await uploadTask!.whenComplete(() async {
      String downloadedUrl = (await ref.getDownloadURL()).toString();
      imageUrl = downloadedUrl;
    });
    log(imageUrl);
    return imageUrl;
  }

  Future<String> uploadAudioFile(PlatformFile? pickedAudioFile) async {
    late String musicUrl;
    final path = 'musicFiles/${pickedAudioFile!.name}';
    final file = File(pickedAudioFile.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    await uploadTask!.whenComplete(() async {
      String downloadedUrl = (await ref.getDownloadURL()).toString();
      musicUrl = downloadedUrl;
    });
    return musicUrl;
  }
}
