import 'package:cloud_firestore/cloud_firestore.dart';

class SongModel {
  String? songId;
  String? title;
  String? singer;
  String? status = 'pending';
  String? writer;
  String? uploadedBy;
  String? uploadedDate;
  String? category;
  String? imageUrl;
  String? songUrl;
  List? likedBy;

  SongModel({
    this.songId,
    this.title,
    this.singer,
    this.writer,
    this.uploadedDate,
    this.uploadedBy,
    this.category,
    this.imageUrl,
    this.songUrl,
    this.likedBy,
  });

  SongModel.fromFirestore(DocumentSnapshot doc) {
    songId = doc.get('songId');
    title = doc.get('title');
    singer = doc.get('singer');
    status = doc.get('status');
    writer = doc.get('writer');
    uploadedDate = doc.get('uploadedDate');
    uploadedBy = doc.get('uploadedBy');
    category = doc.get('category');
    imageUrl = doc.get('imageUrl');
    songUrl = doc.get('songUrl');
    likedBy = doc.get('likedBy');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['songId'] = songId;
    data['title'] = title;
    data['singer'] = singer;
    data['status'] = status;
    data['uploadedBy'] = uploadedBy;
    data['writer'] = writer;
    data['uploadedDate'] = uploadedDate;
    data['category'] = category;
    data['imageUrl'] = imageUrl;
    data['songUrl'] = songUrl;
    data['likedBy'] = likedBy;
    return data;
  }
}
