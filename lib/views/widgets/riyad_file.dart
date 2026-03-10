import 'dart:io';
import 'package:flutter/material.dart';

enum MediaType { image, video, audio }

class PickedMedia {
  final File? file;
  final String? remoteUrl;
  final MediaType type;
  final String? originalName;
  final String? fileExtension;

  const PickedMedia({
    this.file,
    this.remoteUrl,
    required this.type,
    this.originalName,
    this.fileExtension,
  }) : assert(
         file != null || remoteUrl != null,
         'Either file or remoteUrl must be provided',
       );

  bool get isRemote => remoteUrl != null;
}

List<Map<String, dynamic>>? buildFileMetadata(List<PickedMedia> mediaList) {
  if (mediaList.isEmpty) return null;

  return mediaList.map((media) {
    if (media.isRemote) {
      final fileName = media.originalName ?? media.remoteUrl!.split('/').last;
      final extname =
          media.fileExtension ??
          (fileName.contains('.') ? fileName.split('.').last : '');
      final fileType = media.type == MediaType.image
          ? 'image'
          : media.type == MediaType.video
          ? 'video'
          : 'audio';
      return {
        'fileLoc': media.remoteUrl!,
        'originalName': fileName,
        'type': fileType,
        'size': 0,
        'extname': extname,
      };
    } else {
      final filePath = media.file!.path;
      final fileName = filePath.split('/').last;
      final extname = fileName.contains('.') ? fileName.split('.').last : '';
      final fileType = media.type == MediaType.image
          ? 'image'
          : media.type == MediaType.video
          ? 'video'
          : 'audio';
      return {
        'fileLoc': filePath,
        'originalName': fileName,
        'type': fileType,
        'size': media.file!.lengthSync(),
        'extname': extname,
      };
    }
  }).toList();
}

class MediaPickerWidget extends StatelessWidget {
  final List<PickedMedia> mediaList;
  final Function(int index) onRemove;

  const MediaPickerWidget({
    super.key,
    required this.mediaList,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (mediaList.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mediaList.length,
        itemBuilder: (context, index) {
          final media = mediaList[index];
          return _MediaThumbnail(media: media, onRemove: () => onRemove(index));
        },
      ),
    );
  }
}

class _MediaThumbnail extends StatelessWidget {
  final PickedMedia media;
  final VoidCallback onRemove;

  const _MediaThumbnail({required this.media, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildThumbnailContent(),

            if (media.type == MediaType.video) _buildBadge('VIDEO'),
            if (media.type == MediaType.audio) _buildBadge('AUDIO'),

            // Remove button
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailContent() {
    if (media.type == MediaType.image) {
      if (media.isRemote) {
        return Image.network(
          media.remoteUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          ),
        );
      } else {
        return Image.file(media.file!, fit: BoxFit.cover);
      }
    }

    return Container(
      color: Colors.black87,
      child: Center(
        child: Icon(
          media.type == MediaType.video
              ? Icons.play_circle_fill
              : Icons.audiotrack,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildBadge(String label) {
    return Positioned(
      bottom: 6,
      left: 6,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
