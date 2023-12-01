import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vmpa/Constant/color.dart';
import 'package:vmpa/Models/song_model.dart';
import 'package:vmpa/Services/db_services.dart';
import 'package:vmpa/Services/storage_services.dart';
import 'package:vmpa/Utilities/input_valiators.dart';
import 'package:vmpa/Utilities/overlays_widgets.dart';
import 'package:uuid/uuid.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController singerController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController musicController = TextEditingController();
  PlatformFile? pickedImageFile;
  PlatformFile? pickedAudioFile;
  DateTime selectedDate = DateTime.now();
  var uuid = const Uuid();
  get v1 => uuid.v1();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Text('Upload Music', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SizedBox(
        height: size.height * 0.81,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset('assets/images/jpg/Logo.jpg', height: size.height * 0.2, width: size.width * 0.5),
                  TextFormField(
                    controller: titleController,
                    validator: requiredValidator,
                    keyboardType: TextInputType.name,
                    autofillHints: const [AutofillHints.name],
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: singerController,
                    validator: requiredValidator,
                    keyboardType: TextInputType.name,
                    autofillHints: const [AutofillHints.name],
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintText: 'Singer',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: imageController,
                    validator: requiredValidator,
                    maxLines: 1,
                    readOnly: true,
                    onTap: imagePicker,
                    decoration: const InputDecoration(
                      hintText: 'Choose an image',
                      prefixIcon: Icon(Icons.image),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: musicController,
                    validator: requiredValidator,
                    maxLines: 1,
                    readOnly: true,
                    onTap: audioPicker,
                    decoration: const InputDecoration(
                      hintText: 'Pick an audio file',
                      prefixIcon: Icon(Icons.audio_file),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: Size(size.width * 0.8, 50),
                      ),
                      onPressed: () async {
                        try {
                          if (_formKey.currentState!.validate()) {
                            loadingOverlay('Uploading');
                            final imageUrl = await StorageService().uploadImageFile(pickedImageFile);
                            final songUrl = await StorageService().uploadAudioFile(pickedAudioFile);
                            SongModel songModel = SongModel(
                              title: titleController.text,
                              singer: singerController.text,
                              uploadedDate: DateFormat('yyyy-MM-dd – kk:mm').format(selectedDate),
                              imageUrl: imageUrl,
                              uploadedBy: v1,
                              songUrl: songUrl,
                              likedBy: [],
                            );
                            await DBServices().uploadSong(songModel);
                            _formKey.currentState?.reset();
                            Get.back(closeOverlays: true);
                            Get.snackbar('Uploaded', 'Check the status in your uploads');
                            imageController.clear();
                            musicController.clear();
                            titleController.clear();
                            singerController.clear();
                          }
                        } catch (e) {
                          errorOverlay(e.toString());
                          log(e.toString());
                        }
                      },
                      child: const Text('Upload')),
                  const SizedBox(height: 40)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void imagePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;
    setState(() {
      pickedImageFile = result.files.first;
      imageController.text = pickedImageFile!.name;
    });
  }

  void audioPicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null) {
      return;
    }
    setState(() {
      pickedAudioFile = result.files.first;
      musicController.text = pickedAudioFile!.name;
    });
  }

  Column inputFields(Size size) {
    var uuid = const Uuid();
    var v1 = uuid.v1();
    return Column(
      children: [
        Image.asset('assets/images/jpg/Logo.jpg', height: size.height * 0.2, width: size.width * 0.5),
        TextFormField(
          controller: titleController,
          validator: requiredValidator,
          keyboardType: TextInputType.name,
          autofillHints: const [AutofillHints.name],
          maxLines: 1,
          decoration: const InputDecoration(
            hintText: 'Title',
            prefixIcon: Icon(Icons.title),
          ),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: singerController,
          validator: requiredValidator,
          keyboardType: TextInputType.name,
          autofillHints: const [AutofillHints.name],
          maxLines: 1,
          decoration: const InputDecoration(
            hintText: 'Singer',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: imageController,
          validator: requiredValidator,
          maxLines: 1,
          readOnly: true,
          onTap: imagePicker,
          decoration: const InputDecoration(
            hintText: 'Choose an image',
            prefixIcon: Icon(Icons.image),
          ),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: musicController,
          validator: requiredValidator,
          maxLines: 1,
          readOnly: true,
          onTap: audioPicker,
          decoration: const InputDecoration(
            hintText: 'Pick an audio file',
            prefixIcon: Icon(Icons.audio_file),
          ),
        ),
        const SizedBox(height: 30),
        FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: Size(size.width * 0.8, 50),
            ),
            onPressed: () async {
              try {
                loadingOverlay('Uploading');
                final imageUrl = await StorageService().uploadImageFile(pickedImageFile);
                final songUrl = await StorageService().uploadAudioFile(pickedAudioFile);
                SongModel songModel = SongModel(
                  title: titleController.text,
                  singer: singerController.text,
                  uploadedDate: DateFormat('yyyy-MM-dd – kk:mm').format(selectedDate),
                  imageUrl: imageUrl,
                  uploadedBy: v1,
                  songUrl: songUrl,
                  likedBy: [],
                );
                await DBServices().uploadSong(songModel);
                _formKey.currentState?.reset();
                Get.back(closeOverlays: true);
                Get.snackbar('Uploaded', 'Check the status in your uploads');
                imageController.clear();
                musicController.clear();
                titleController.clear();
                singerController.clear();
              } catch (e) {
                errorOverlay(e.toString());
                log(e.toString());
              }
            },
            child: const Text('Upload')),
        const SizedBox(height: 40)
      ],
    );
  }
}
