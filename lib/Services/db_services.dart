import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vmpa/Models/song_model.dart';
import 'package:vmpa/Utilities/global_variables.dart';

class DBServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static String songs = 'songs';
  static String categories = 'categories';
  static String users = 'users';

  Future<void> uploadSong(SongModel songModel) async {
    final id = firestore.collection(songs).doc().id;
    songModel.songId = id;
    await firestore.collection(songs).doc(id).set(songModel.toJson());
  }

  Future<void> likeSong(String songId) async {
    await firestore.collection(songs).doc(songId).update({
      'likedBy': FieldValue.arrayUnion([userID.value]),
    });
  }

  Future<void> removeLike(String songId) async {
    await firestore.collection(songs).doc(songId).update({
      'likedBy': FieldValue.arrayRemove([userID.value]),
    });
  }

  Stream<List<SongModel>> reccomendedList() {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    return fireStore.collection('songs').where('uploadedBy').snapshots().map((event) {
      List<SongModel> retVal = [];
      for (var doc in event.docs) {
        retVal.add(SongModel.fromFirestore(doc));
      }
      retVal.shuffle();
      List<SongModel> reccomended = retVal.length > 5 ? retVal.sublist(0, 5) : retVal;
      return reccomended;
    });
  }

  Stream<List<SongModel>> streamUserUploadSongsData() {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    return fireStore.collection('songs').snapshots().map((event) {
      List<SongModel> retVal = [];
      log(event.docs.toString());
      for (var doc in event.docs) {
        print('object');
        log(doc.data().toString());
        retVal.add(SongModel.fromFirestore(doc));
      }
      return retVal;
    });
  }

  Future<List<SongModel>> getUserUploadSongsData() async {
    List<String> songIds = [];
    QuerySnapshot querySnapshot = await firestore.collection('playlist').get();
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      var data = documentSnapshot.data() as Map<String, dynamic>;
      if (data.containsKey('songId')) {
        songIds.add(data['songId']);
      }
    }
    if (songIds.isEmpty) {
      return [];
    } else {
      try {
        QuerySnapshot snapshot = await firestore.collection('songs').where('songId', whereIn: songIds).get();
        List<SongModel> retVal = [];
        for (var doc in snapshot.docs) {
          retVal.add(SongModel.fromFirestore(doc));
        }
        return retVal;
      } catch (error) {
        return [];
      }
    }
  }

  Future<List<SongModel>> getAllSongsForSearch() async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    return await fireStore.collection('songs').get().then((snapshot) {
      List<SongModel> retVal = [];
      for (var doc in snapshot.docs) {
        retVal.add(SongModel.fromFirestore(doc));
      }
      return retVal;
    });
  }

  Future<void> deleteSong(String songId) async {
    await firestore.collection(songs).doc(songId).delete();
  }
}
