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

  final videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
      'https://videos.pexels.com/video-files/20422317/20422317-hd_1920_1080_25fps.mp4'));

  bool showPlaceholder = true; // track if placeholder is visible

  @override
  void initState() {
    super.initState();
    videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false, // prevent placeholder from disappearing automatically
      looping: true,
      aspectRatio: 16 / 9,
      showControls: true, // user can play video manually
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
                  child: Stack(
                    children: [
                      // Video Player
                      Chewie(controller: chewieController),

                      // Permanent Placeholder
                      if (showPlaceholder)
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/art_placeholder.jpg', // your hand drawing image
                            fit: BoxFit.cover,
                          ),
                        ),

                      // Play Button to start video and remove placeholder
                      if (showPlaceholder)
                        Positioned.fill(
                          child: Center(
                            child: IconButton(
                              iconSize: 64,
                              icon: const Icon(Icons.play_circle_fill,
                                  color: Colors.white),
                              onPressed: () {
                                chewieController.play();
                                setState(() {
                                  showPlaceholder =
                                      false; // remove overlay when play pressed
                                });
                              },
                            ),
                          ),
                        ),
                    ],
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
