import 'dart:developer';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';
import 'package:vmpa/Models/song_model.dart';
import 'package:vmpa/Utilities/global_variables.dart';

class PlayerService {
  Future<void> buildPlayer(AudioPlayer player, ConcatenatingAudioSource playlist, {int? initialIndex = 0}) async {
    log('called buildplayer');
    final session = await AudioSession.instance;
    log('called session');
    await session.configure(const AudioSessionConfiguration.speech());
    log('called configure');
    player.sequenceStateStream.listen((event) {
      log('tag: ${event!.currentSource!.tag.extras['text']}');
    });
    player.playbackEventStream.listen((event) {}, onError: (Object e, StackTrace stackTrace) {
      log('A stream error occurred: $e');
    });
    try {
      log('called setaudio');
      await player.setAudioSource(playlist, preload: false, initialIndex: initialIndex);
      player.play();
      log('player set audio');
      isAudioLoading.value = false;
      isPlaying.value = true;
    } catch (e, stackTrace) {
      log("Error loading playlist: $e");
      log('$stackTrace');
    }
  }

  ConcatenatingAudioSource buildAudios(List<SongModel> songModel) {
    List<AudioSource> audioList = [];

    for (var song in songModel) {
      audioList.add(AudioSource.uri(Uri.parse(song.songUrl!),
          tag: MediaItem(
              id: song.songId!,
              title: '${song.title}',
              album: song.category,
              artUri: Uri.parse(song.imageUrl!),
              extras: {'text': song.songId!})));
    }

    final concatenatingAudioSource = ConcatenatingAudioSource(children: audioList);

    return concatenatingAudioSource;
  }
}
