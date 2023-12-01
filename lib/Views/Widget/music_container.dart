import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vmpa/Constant/color.dart';
import 'package:vmpa/Utilities/global_variables.dart';
import 'package:vmpa/Views/Widget/detail_row.dart';

class MusicContainer extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String? category;
  final String? writer;
  final String status;
  final String? uploadedDate;
  final String? imageUrl;
  final String? singer;
  final bool isUserUpload;
  final String? title;
  final bool isAdmin;
  final String songId;
  final bool isLiked;
  final VoidCallback onLike;
  final String? songUrl;
  final bool? playlist;

  MusicContainer({
    required this.isAdmin,
    super.key,
    this.imageUrl,
    this.singer,
    this.title,
    this.category,
    this.writer,
    required this.isLiked,
    required this.songId,
    this.uploadedDate,
    required this.isUserUpload,
    required this.status,
    required this.onLike,
    this.songUrl,
    this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: currentAudioText.value == songId ? AppColors.deepPurple : AppColors.transparent,
          borderRadius:
              isUserUpload ? const BorderRadius.horizontal(left: Radius.circular(12)) : BorderRadius.circular(12),
        ),
        child: Column(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              leading: SizedBox(
                height: 80,
                width: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: imageUrl.toString(),
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
              title: Text(
                title.toString(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: songId == currentAudioText.value ? AppColors.white : AppColors.black,
                    ),
              ),
              subtitle: Text(
                singer.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: songId == currentAudioText.value ? AppColors.white : AppColors.grey,
                    ),
              ),
              trailing: IconButton(
                onPressed: () {
                  Get.bottomSheet(
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(35),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Text('Details', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 10),
                          KDetailRow(heading: 'Title', value: title.toString()),
                          KDetailRow(heading: 'Singer', value: singer.toString()),
                          KDetailRow(heading: 'Date', value: uploadedDate.toString()),
                          Row(children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () async {
                                  try {
                                    if (playlist == true) {
                                      QuerySnapshot querySnapshot =
                                          await FirebaseFirestore.instance.collection('playlist').get();
                                      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
                                        var data = documentSnapshot.data() as Map<String, dynamic>;
                                        if (data.containsKey('songId') && data['songId'] == songId) {
                                          await FirebaseFirestore.instance
                                              .collection('playlist')
                                              .doc(documentSnapshot.id)
                                              .delete();
                                        }
                                      }
                                    } else {
                                      await FirebaseFirestore.instance
                                          .collection('playlist')
                                          .doc(songId)
                                          .set({'songId': songId});
                                      debugPrint('Song ID saved to playlist: $songId');
                                    }
                                  } catch (error) {
                                    debugPrint('Error saving song ID: $error');
                                  }
                                  Get.back();
                                },
                                child: Text(playlist == true ? 'Remove' : 'Add to Playlist'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: FilledButton(
                                onPressed: () async {
                                  await Share.shareUri(Uri.parse(songUrl!));
                                },
                                child: const Text('Share'),
                              ),
                            ),
                          ])
                        ]),
                      ),
                    ),
                    backgroundColor: AppColors.transparent,
                    isDismissible: true,
                    enableDrag: true,
                  );
                },
                icon: const Icon(Icons.more_vert),
              ),
            )
          ]),
          const SizedBox(height: 3)
        ]),
      ),
    );
  }
}
