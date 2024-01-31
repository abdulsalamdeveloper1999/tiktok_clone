import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

// import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController _videoPlayerController;
  late bool isPlaying;

  @override
  void initState() {
    _videoPlayerController =
        CachedVideoPlayerController.network(widget.videoUrl)
          ..initialize().then((value) {
            _videoPlayerController.pause();
            // _videoPlayerController.play();
            _videoPlayerController.setLooping(true);
            _videoPlayerController.setVolume(1);
            isPlaying = true;
          });
    super.initState();
    // Listen to the video playback position to determine when it's finished
    // _videoPlayerController.addListener(() {
    //   if (_videoPlayerController.value.position ==
    //       _videoPlayerController.value.duration) {
    //     // Video finished, loop it
    //     _videoPlayerController.seekTo(Duration.zero);
    //     _videoPlayerController.play();
    //   }
    // });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (isPlaying) {
        _videoPlayerController.pause();
      } else {
        _videoPlayerController.play();
      }
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: CachedVideoPlayer(_videoPlayerController),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';

// import '../../controllers/add_video_controller/video_player_controller.dart';

// final VideoController videoController = Get.put(VideoController());

// class VideoPlayerItem extends StatelessWidget {
//   final String videoUrl;

//   const VideoPlayerItem({Key? key, required this.videoUrl}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     videoController.initializeVideoPlayer(videoUrl);

//     return GestureDetector(
//       onTap: () => videoController.togglePlayPause(),
//       child: VideoPlayer(videoController.videoPlayerController),
//     );
//   }
// }
