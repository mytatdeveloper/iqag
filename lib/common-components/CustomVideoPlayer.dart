import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytat/utilities/AppConstants.dart';
import 'package:video_player/video_player.dart';

// Get Assessor Documents List Online

class CustomVideoPlayer extends StatefulWidget {
  final String videoLink;

  const CustomVideoPlayer({Key? key, required this.videoLink})
      : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    print("Video URL RECEIVED: ${widget.videoLink}");
    super.initState();
    _videoPlayerController = AppConstants.isOnlineMode == true
        ? VideoPlayerController.networkUrl(Uri.parse(widget.videoLink))
        : VideoPlayerController.file(File(widget.videoLink));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 1 / 1, // Adjust as needed
      autoInitialize: true,
      looping: false,
      autoPlay: true,
      showControls: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    double playerWidth = Get.width * 0.9;
    double playerHeight = Get.height * 0.9;

    return Material(
      child: SizedBox(
        width: playerWidth,
        height: playerHeight,
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
