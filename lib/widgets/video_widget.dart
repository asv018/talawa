// ignore_for_file: talawa_api_doc
// ignore_for_file: talawa_good_doc_comments

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// This class creates a video widget.
class VideoWidget extends StatefulWidget {
  const VideoWidget({Key? key, required this.url, required this.play})
      : super(key: key);
  final String url;
  final bool play;

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  //Controls a platform video player, and provides updates when the state is changing.
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  //setting the mute variable to true initially
  bool mute = true;

  @override
  void initState() {
    super.initState();
    //Constructs a [VideoPlayerController] playing a video from obtained from the network.
    _controller = VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      if (widget.play) {
        _controller.play();
        _controller.setLooping(true);
        _controller.setVolume(0.0);
      }
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(VideoWidget oldWidget) {
    if (oldWidget.play != widget.play) {
      if (widget.play) {
        _controller.play();
        _controller.setLooping(true);
      } else {
        _controller.pause();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override

  /// This function returns a GestureDetector for controlling the volume.
  /// On tap, the volume is either set to 1 or 0 depending on the previous value.
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () {
              _controller
                  .setVolume(_controller.value.volume == 1.0 ? 0.0 : 1.0);
              setState(() {
                if (_controller.value.volume == 1.0) {
                  // Set mute variable as false when the volume is increased to 1.
                  mute = false;
                } else {
                  mute = true;
                }
              });
            },
            child: Stack(
              children: [
                VideoPlayer(_controller),
                Positioned(
                  bottom: 10.0,
                  right: 10.0,
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 15.0,
                    child: Icon(
                      mute ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
