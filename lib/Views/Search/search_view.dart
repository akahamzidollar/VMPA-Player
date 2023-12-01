import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vmpa/Controllers/search_song_controller.dart';
import 'package:vmpa/Models/song_model.dart';
import 'package:vmpa/Services/player_service.dart';
import 'package:vmpa/Views/Home/playlist.dart';
import 'package:vmpa/Views/Widget/music_container.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final searchDataController = Get.find<SearchSongController>();
  RxString searchString = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: false,
        title: Hero(
          tag: 'search',
          child: CupertinoSearchTextField(
              backgroundColor: Colors.white,
              onChanged: (value) {
                searchString.value = value;
                searchDataController.filterSongs(value);
              }),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Obx(() {
          if (searchDataController.filteredSongs == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (searchDataController.filteredSongs!.isNotEmpty) {
            return Obx(() {
              final List<SongModel> songs = searchDataController.filteredSongs!;
              return ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final SongModel song = songs[index];
                  return GestureDetector(
                    onTap: () async {
                      final List<SongModel> matchingSongs = songs
                          .where(
                            (element) => element.title!.toLowerCase().contains(searchString.value.toLowerCase()),
                          )
                          .toList();
                      if (matchingSongs.isNotEmpty) {
                        final playlist = PlayerService().buildAudios(matchingSongs);
                        await PlayerService().buildPlayer(player, playlist, initialIndex: 0);
                      }
                    },
                    child: MusicContainer(
                      title: song.title,
                      singer: song.singer,
                      imageUrl: song.imageUrl,
                      isAdmin: false,
                      isLiked: false,
                      songId: song.songId!,
                      isUserUpload: false,
                      status: 'status',
                      onLike: () {},
                      uploadedDate: song.uploadedDate,
                      writer: song.writer,
                      category: song.category,
                      songUrl: song.songUrl,
                    ),
                  );
                },
              );
            });
          } else {
            return const Center(
              child: Text('No songs found'),
            );
          }
        }),
      ),
    );
  }
}
