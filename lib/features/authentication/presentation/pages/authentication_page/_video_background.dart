part of 'authentication_page.dart';

class _VideoBackground extends StatefulWidget {
  const _VideoBackground();

  @override
  State<_VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<_VideoBackground> {
  late VideoPlayerController _videoController;
  late VideoPlayerController _videoController2;

  static const transitionDuration = Duration(milliseconds: 3000);

  bool isShowingSecondVideo = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(
      "assets/videos/earth2.mp4",
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
      ),
    )
      ..setVolume(0)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
      });
    _videoController2 = VideoPlayerController.asset(
      "assets/videos/earth2.mp4",
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
      ),
    )
      ..setVolume(0)
      ..initialize();

    _videoController.addListener(() {
      if (!isShowingSecondVideo &&
          _videoController.value.position.inSeconds != 0 &&
          _videoController.value.position.inSeconds >=
              _videoController.value.duration.inSeconds -
                  transitionDuration.inSeconds) {
        setState(() {
          isShowingSecondVideo = true;
        });
        _videoController2.play();

        Future.delayed(transitionDuration).then((_) {
          _videoController.seekTo(Duration.zero);
          _videoController.pause();
        });
      }
    });

    _videoController2.addListener(() {
      if (isShowingSecondVideo &&
          _videoController2.value.position.inSeconds != 0 &&
          _videoController2.value.position.inSeconds >=
              _videoController2.value.duration.inSeconds -
                  transitionDuration.inSeconds) {
        setState(() {
          isShowingSecondVideo = false;
        });
        _videoController.play();

        Future.delayed(transitionDuration).then((_) {
          _videoController2.seekTo(Duration.zero);
          _videoController2.pause();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: AnimatedCrossFade(
        duration: transitionDuration,
        crossFadeState: isShowingSecondVideo
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: SizedBox(
          height: _videoController.value.size.height,
          width: _videoController.value.size.width,
          child: VideoPlayer(
            _videoController,
          ),
        ),
        secondChild: SizedBox(
          height: _videoController2.value.size.height,
          width: _videoController2.value.size.width,
          child: VideoPlayer(
            _videoController2,
          ),
        ),
      ),
    );
  }
}
