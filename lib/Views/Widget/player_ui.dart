import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vmpa/Constant/color.dart';
import 'package:vmpa/Services/player_common.dart';
import 'package:vmpa/Utilities/global_variables.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:vmpa/Views/Home/playlist.dart';

class PlayerUi extends StatelessWidget {
  const PlayerUi({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<PositionData> positionDataStream = rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      player.positionStream,
      player.bufferedPositionStream,
      player.durationStream,
      (position, bufferedPosition, duration) => PositionData(position, bufferedPosition, duration ?? Duration.zero),
    );
    return SafeArea(
        child: Container(
      alignment: Alignment.center,
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ControlButtons(player),
          StreamBuilder<PositionData>(
            stream: positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                duration: positionData?.duration ?? Duration.zero,
                position: positionData?.position ?? Duration.zero,
                bufferedPosition: positionData?.bufferedPosition ?? Duration.zero,
                onChangeEnd: (newPosition) {
                  player.seek(newPosition);
                },
              );
            },
          ),
          StreamBuilder<SequenceState?>(
              stream: player.sequenceStateStream,
              builder: (context, snapshot) {
                Future.delayed(Duration.zero).then((value) {
                  if (snapshot.hasData) {
                    currentAudioText.value = snapshot.data!.currentSource!.tag.extras['text'];
                  }
                });

                return const SizedBox();
              }),
        ],
      ),
    ));
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.volume_up),
        onPressed: () {
          showSliderDialog(
            context: context,
            title: "Adjust volume",
            divisions: 10,
            min: 0.0,
            max: 1.0,
            stream: player.volumeStream,
            onChanged: player.setVolume,
            value: 1,
          );
        },
      ),
      StreamBuilder<LoopMode>(
        stream: player.loopModeStream,
        builder: (context, snapshot) {
          final loopMode = snapshot.data ?? LoopMode.off;
          const icons = [
            Icon(Icons.repeat),
            Icon(Icons.repeat, color: AppColors.primary),
            Icon(Icons.repeat_one, color: AppColors.primary),
          ];
          const cycleModes = [
            LoopMode.off,
            LoopMode.all,
            LoopMode.one,
          ];
          final index = cycleModes.indexOf(loopMode);
          return IconButton(
            padding: EdgeInsets.zero,
            icon: icons[index],
            onPressed: () {
              player.setLoopMode(cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
            },
          );
        },
      ),
      StreamBuilder<SequenceState?>(
        stream: player.sequenceStateStream,
        builder: (context, snapshot) => IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.skip_previous),
          onPressed: player.hasPrevious ? player.seekToPrevious : null,
        ),
      ),
      StreamBuilder<PlayerState>(
        stream: player.playerStateStream,
        builder: (context, snapshot) {
          final playerState = snapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing;
          if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
            return const SizedBox(
              height: 50,
              width: 50,
              child: Center(
                  heightFactor: 1,
                  widthFactor: 1,
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2, backgroundColor: AppColors.primary)),
            );
          } else if (playing != true) {
            return IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 44.0,
              onPressed: player.play,
            );
          } else if (processingState != ProcessingState.completed) {
            return IconButton(
              icon: const Icon(Icons.pause),
              iconSize: 44.0,
              onPressed: player.pause,
            );
          } else {
            return IconButton(
              icon: const Icon(Icons.replay),
              iconSize: 44.0,
              onPressed: () => player.seek(Duration.zero, index: player.effectiveIndices!.first),
            );
          }
        },
      ),
      StreamBuilder<SequenceState?>(
        stream: player.sequenceStateStream,
        builder: (context, snapshot) => IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: player.hasNext ? player.seekToNext : null,
        ),
      ),
      StreamBuilder<PlayerState?>(
        builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () {
              player.stop();
              currentAudioText.value = '';
              isPlaying.value = false;
            }),
        stream: player.playerStateStream,
      ),
      StreamBuilder<double>(
        stream: player.speedStream,
        builder: (context, snapshot) => IconButton(
          icon: Text("${snapshot.data?.toStringAsFixed(1)}x", style: const TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust speed",
              divisions: 10,
              min: 0.5,
              max: 1.5,
              stream: player.speedStream,
              onChanged: player.setSpeed,
              value: 1,
            );
          },
        ),
      ),
    ]);
  }
}
