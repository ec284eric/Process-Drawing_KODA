import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../draw.dart';

class VideoPlayerDialog extends StatefulWidget {
  final BuildContext context;

  const VideoPlayerDialog({
    super.key,
    required this.context,
  });

  @override
  State<VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  late ChewieController chewieController;
  late Chewie playerWidget;

  final videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
      'https://videos.pexels.com/video-files/20422317/20422317-hd_1920_1080_25fps.mp4'));

  @override
  void initState() {
    super.initState();
    videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      aspectRatio: 16 / 9,
    );
    playerWidget = Chewie(
      controller: chewieController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.context.read<DrawBloc>(),
      child: Builder(
        builder: (context) {
          return Transform.scale(
            scale: 0.5,
            child: SimpleDialog(
              contentPadding: const EdgeInsets.all(
                0,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.zero,
                ),
              ),
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    child: playerWidget,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }
}
