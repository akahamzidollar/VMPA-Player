import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vmpa/Constant/color.dart';
import 'package:vmpa/Views/Home/playlist.dart';
import 'package:vmpa/Views/Home/library.dart';
import 'package:vmpa/Views/Search/search_view.dart';
import '../../Controllers/search_song_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('VMPA', style: Theme.of(context).textTheme.headlineSmall),
          actions: [
            IconButton(
              onPressed: () => Get.to(() => const SearchView(), binding: SongSearchBinding()),
              icon: const Icon(Icons.search, color: AppColors.white, size: 30),
            )
          ],
          backgroundColor: AppColors.primary,
          elevation: 0,
          bottom: TabBar(
              dividerColor: AppColors.primary,
              isScrollable: false,
              indicatorColor: AppColors.primary,
              unselectedLabelColor: AppColors.white54,
              padding: const EdgeInsets.only(bottom: 10),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2.5,
              labelStyle: Theme.of(context).textTheme.titleMedium,
              labelColor: AppColors.white,
              tabs: const [
                Tab(text: 'Music Library'),
                Tab(text: 'Playlist'),
              ]),
        ),
        body: const TabBarView(children: [
          MusicLibrary(isAdmin: false, isAllSongs: true, userUploads: false, isFavoriteSongs: false),
          PlayList(isAdmin: true, userUploads: false, isFavoriteSongs: false),
        ]),
      ),
    );
  }
}
