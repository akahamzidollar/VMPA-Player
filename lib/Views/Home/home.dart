import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vmpa/Utilities/overlays_widgets.dart';
import 'package:vmpa/Views/Home/playlist.dart';
import 'package:vmpa/Views/Home/library.dart';
import 'package:vmpa/Views/Search/search_view.dart';
import '../../Controllers/search_song_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Future getData() async {
    try {
      FirebaseFirestore fireStore = FirebaseFirestore.instance;
      QuerySnapshot snapshot = await fireStore.collection('categories').get();
      return snapshot.docs;
    } catch (e) {
      errorOverlay(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appBar(),
        body: const TabBarView(children: [
          MusicLibrary(isAdmin: false, isAllSongs: true, userUploads: false, isFavoriteSongs: false),
          PlayList(isAdmin: true, userUploads: false, isFavoriteSongs: false),
        ]),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('VMPA', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        Hero(
          tag: 'search',
          child: Material(
            color: Colors.deepPurple,
            child: IconButton(
              onPressed: () {
                Get.to(() => const SearchView(), binding: SongSearchBinding());
              },
              icon: const Icon(Icons.search),
            ),
          ),
        )
      ],
      backgroundColor: Colors.deepPurple,
      elevation: 0,
      bottom: const TabBar(
          dividerColor: Colors.deepPurple,
          isScrollable: false,
          indicatorColor: Colors.deepPurple,
          unselectedLabelColor: Colors.white54,
          padding: EdgeInsets.only(bottom: 10),
          indicatorSize: TabBarIndicatorSize.label,
          indicatorWeight: 2.5,
          labelStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),
          labelColor: Colors.white,
          tabs: [
            Tab(text: 'Music Library'),
            Tab(text: 'Playlist'),
          ]),
    );
  }

  Column categoryContainer({required String categoryName, required String imageUrl}) {
    return Column(children: [
      Stack(children: [
        Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            )),
        Positioned(
          top: 15,
          left: 15,
          child: Container(
            height: 30,
            color: Colors.black54,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              categoryName,
              style: const TextStyle(color: Colors.white, fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ]),
      const SizedBox(height: 15)
    ]);
  }
}
