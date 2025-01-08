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
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
    )
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.context.read<DrawBloc>(),
      child: Builder(
        builder: (context) {
          return SimpleDialog(
            title: const Text('Video Tutorial'),
            children: [
              AspectRatio(
                aspectRatio: _controller.value.isInitialized
                    ? _controller.value.aspectRatio
                    : 1.0,
                child: _controller.value.isInitialized
                    ? Container(
                        padding: const EdgeInsets.all(25),
                        child: VideoPlayer(_controller))
                    : const Center(child: CircularProgressIndicator()),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
