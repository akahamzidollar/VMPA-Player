import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:vmpa/Constant/color.dart';
import 'package:vmpa/Models/song_model.dart';
import 'package:vmpa/Services/player_service.dart';
import 'package:vmpa/Utilities/global_variables.dart';
import 'package:vmpa/Views/Home/playlist.dart';
import 'package:vmpa/Views/Widget/music_container.dart';
import 'package:vmpa/Views/Widget/player_ui.dart';
import 'package:rxdart/rxdart.dart' as rx;
import '../../Services/db_services.dart';
import '../../Services/player_common.dart';

class MusicLibrary extends StatefulWidget {
  final String? categoryTitle;
  final bool isAdmin;
  final bool isFavoriteSongs;
  final bool? isAllSongs;
  final bool userUploads;
  const MusicLibrary(
      {Key? key,
      this.categoryTitle,
      this.isAllSongs,
      required this.isAdmin,
      required this.userUploads,
      required this.isFavoriteSongs})
      : super(key: key);

  @override
  State<MusicLibrary> createState() => _MusicLibraryState();
}

class _MusicLibraryState extends State<MusicLibrary> {
  @override
  void initState() {
    DBServices().getUserUploadSongsData();
    super.initState();
  }

  Stream<PositionData> get positionDataStream => rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        player.positionStream,
        player.bufferedPositionStream,
        player.durationStream,
        (position, bufferedPosition, duration) => PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Column(children: [
            StreamBuilder<List<SongModel>>(
              stream: DBServices().streamUserUploadSongsData(),
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
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const BehindMotion(),
                          children: [
                            SlidableAction(
                              onPressed: ((context) {
                                DBServices().deleteSong(data.songId!);
                              }),
                              backgroundColor: AppColors.error,
                              label: 'Delete',
                              icon: Icons.delete,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            final playlist = PlayerService().buildAudios([data]);
                            await PlayerService().buildPlayer(player, playlist, initialIndex: 0);
                          },
                          child: MusicContainer(
                            isLiked: isLiked,
                            onLike: () {
                              isLiked ? DBServices().removeLike(data.songId!) : DBServices().likeSong(data.songId!);
                            },
                            isUserUpload: widget.userUploads,
                            status: data.status.toString(),
                            isAdmin: widget.isAdmin,
                            songId: data.songId ?? '',
                            title: data.title,
                            singer: data.singer,
                            writer: data.writer,
                            category: data.category,
                            uploadedDate: data.uploadedDate,
                            imageUrl: data.imageUrl,
                            songUrl: data.songUrl!,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  if (snapshot.hasError) {
                    log(snapshot.error.toString());
                    return Text(snapshot.error.toString());
                  }
                  log('error');
                  return const Text('Error');
                }
              },
            ),
            const SizedBox(height: 50),
          ]),
        ),
      ),
      bottomNavigationBar: Obx(
        () => isPlaying.value ? const PlayerUi() : const SizedBox(),
      ),
    );
  }
}
