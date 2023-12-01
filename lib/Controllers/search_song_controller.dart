import 'package:get/get.dart';
import 'package:vmpa/Models/song_model.dart';
import 'package:vmpa/Services/db_services.dart';

class SearchSongController extends GetxController {
  final Rxn<List<SongModel>> _songs = Rxn<List<SongModel>>();
  final RxList<SongModel> _filteredSongs = RxList<SongModel>();
  List<SongModel>? get songs => _songs.value;
  List<SongModel>? get filteredSongs => _filteredSongs.isNotEmpty ? _filteredSongs : _songs.value;

  @override
  void onInit() {
    _songs.bindStream(Stream.fromFuture(DBServices().getAllSongsForSearch()));
    super.onInit();
  }

  void filterSongs(String query) {
    if (_songs.value != null) {
      _filteredSongs.clear();
      _filteredSongs
          .addAll(_songs.value!.where((song) => song.title!.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  void resetFilter() {
    _filteredSongs.clear();
  }
}

class SongSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SearchSongController());
  }
}
