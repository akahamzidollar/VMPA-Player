import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:vmpa/Models/song_model.dart';
import 'package:vmpa/Services/db_services.dart';
import 'package:vmpa/Services/player_service.dart';
import 'package:vmpa/Views/Home/playlist.dart';
import 'package:vmpa/Views/Widget/music_container.dart';
import 'package:vmpa/Views/Widget/player_ui.dart';

import '../../Utilities/global_variables.dart';

class ReccomendView extends StatefulWidget {
  const ReccomendView({super.key, required this.isAdmin, required this.userUploads});
  final bool isAdmin;
  final bool userUploads;

  @override
  State<ReccomendView> createState() => _ReccomendViewState();
}

class _ReccomendViewState extends State<ReccomendView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          'Recommendations',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: ListView(
              children: [
                StreamBuilder<List<SongModel>>(
                  stream: DBServices().reccomendedList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
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
                                  backgroundColor: Colors.red,
                                  label: 'Delete',
                                  icon: Icons.delete,
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                // isAudioLoading.value = true;
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
              ],
            )),
      ),
      bottomNavigationBar: Obx(
        () => isPlaying.value ? const PlayerUi() : const SizedBox(),
      ),
    );
  }
}
