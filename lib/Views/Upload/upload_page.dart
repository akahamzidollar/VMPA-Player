import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vmpa/Models/song_model.dart';
import 'package:vmpa/Services/db_services.dart';
import 'package:vmpa/Services/storage_services.dart';
import 'package:vmpa/Utilities/input_valiators.dart';
import 'package:vmpa/Utilities/overlays_widgets.dart';
import 'package:vmpa/Views/Widget/input_field.dart';
import 'package:vmpa/Views/Widget/round_button.dart';
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
  final TextEditingController writerController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController musicController = TextEditingController();
  PlatformFile? pickedImageFile;
  PlatformFile? pickedAudioFile;
  DateTime selectedDate = DateTime.now();

  String selectedCategory = 'Pop';
  List<String> categoryList = ['Pop', 'Rock', 'Hip Hop', 'Electronic', 'Classic', 'Other'];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          'Upload Music',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
              child: inputFields(size),
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
    if (result == null) return;
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
        const SizedBox(
          height: 20,
        ),
        const CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage('assets/images/jpg/Logo.jpg'),
        ),
        inputField(
            hint: 'Title',
            controller: titleController,
            textInputType: TextInputType.name,
            validator: requiredValidator,
            iconPrefix: Icons.title),
        inputField(
            hint: 'Singer',
            controller: singerController,
            textInputType: TextInputType.name,
            validator: requiredValidator,
            iconPrefix: Icons.person),
        // inputField(
        //     hint: 'Writer',
        //     controller: writerController,
        //     textInputType: TextInputType.name,
        //     validator: requiredValidator,
        //     iconPrefix: Icons.person),
        // 12.16.10.229
        // inputField(
        //     hint: DateFormat.yMd().format(selectedDate),
        //     widget: Container(),
        //     iconPrefix: Icons.date_range),
        // dropDownButton(),
        inputField(
          hint: 'Choose an image',
          controller: imageController,
          validator: requiredValidator,
          widget: IconButton(
            onPressed: imagePicker,
            icon: const Icon(Icons.image),
          ),
          iconPrefix: Icons.image,
        ),
        inputField(
            hint: 'Pick an audio file',
            controller: musicController,
            validator: requiredValidator,
            widget: IconButton(
              onPressed: audioPicker,
              icon: const Icon(Icons.audio_file),
            ),
            iconPrefix: Icons.audio_file),
        const SizedBox(
          height: 30,
        ),
        RoundButton(
          size: size,
          onPress: () async {
            try {
              loadingOverlay('Uploading');
              final imageUrl = await StorageService().uploadImageFile(pickedImageFile);
              final songUrl = await StorageService().uploadAudioFile(pickedAudioFile);
              SongModel songModel = SongModel(
                title: titleController.text,
                singer: singerController.text,
                // writer: writerController.text,
                uploadedDate: DateFormat('yyyy-MM-dd – kk:mm').format(selectedDate),
                // category: selectedCategory,
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
          text: 'Upload',
        ),
        const SizedBox(
          height: 40,
        )
      ],
    );
  }

  Container dropDownButton() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.purple, width: 1.5)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: selectedCategory,
          onChanged: (value) {
            if (value is String) {
              setState(() {
                selectedCategory = value;
              });
            }
          },
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black,
          ),
          items: categoryList
              .map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(
                      value.toString(),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
