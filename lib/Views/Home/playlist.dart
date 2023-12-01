import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vmpa/Models/song_model.dart';
import 'package:vmpa/Services/player_service.dart';
import 'package:vmpa/Utilities/global_variables.dart';
import 'package:vmpa/Views/Widget/music_container.dart';
import 'package:vmpa/Views/Widget/player_ui.dart';

import '../../../../Services/db_services.dart';

AudioPlayer player = AudioPlayer();

class PlayList extends StatefulWidget {
  final String? songID;
  final String? categoryTitle;
  final bool isAdmin;
  final bool isFavoriteSongs;
  final bool? isAllSongs;
  final bool userUploads;
  const PlayList(
      {Key? key,
      this.songID,
      this.categoryTitle,
      this.isAllSongs,
      required this.isAdmin,
      required this.userUploads,
      required this.isFavoriteSongs})
      : super(key: key);

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  @override
  void initState() {
    super.initState();
    DBServices().getUserUploadSongsData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
              children: [
                FutureBuilder<List<SongModel>>(
                  future: DBServices().getUserUploadSongsData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.requireData.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.requireData[index];
                          bool isLiked = data.likedBy!.contains(userID.value);
                          return GestureDetector(
                            onTap: () async {
                              final playlist = PlayerService().buildAudios(snapshot.requireData);
                              await PlayerService().buildPlayer(player, playlist, initialIndex: index);
                            },
                            child: MusicContainer(
                              playlist: true,
                              isLiked: isLiked,
                              onLike: () {
                                isLiked ? DBServices().removeLike(data.songId!) : DBServices().likeSong(data.songId!);
                              },
                              isUserUpload: widget.userUploads,
                              status: data.status.toString(),
                              isAdmin: widget.isAdmin,
                              songId: data.songId!,
                              title: data.title,
                              singer: data.singer,
                              writer: data.writer,
                              category: data.category,
                              uploadedDate: data.uploadedDate,
                              imageUrl: data.imageUrl,
                              songUrl: data.songUrl,
                            ),
                          );
                        },
                      );
                    } else if (snapshot.data!.isEmpty) {
                      return const Center(child: Text('Try to Add some Music from Library'));
                    } else {
                      if (snapshot.hasError) {
                        log(snapshot.error.toString());
                        return Text(snapshot.error.toString());
                      }
                      log('error');
                      return Text(snapshot.error.toString());
                    }
                  },
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => isPlaying.value ? const PlayerUi() : const SizedBox(),
        ),
      ),
    );
  }
}
