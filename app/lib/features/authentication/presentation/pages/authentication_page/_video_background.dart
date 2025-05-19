part of 'authentication_page.dart';

class _VideoBackground extends StatefulWidget {
  const _VideoBackground();

  @override
  State<_VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<_VideoBackground>
    with SingleTickerProviderStateMixin {
  static const _transitionDuration = Duration(milliseconds: 3000);
  static const String _videoPath = 'assets/videos/forest_aerial.mp4';

  late AnimationController _fadeInController;
  late Animation<double> _fadeInAnimation;
  late VideoPlayerController _videoController;
  late VideoPlayerController _videoController2;

  bool isShowingSecondVideo = false;

  @override
  void initState() {
    super.initState();
    _initAndStartFade();
    _initVideoControllers();
    _setUpVideoListeners();
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    _videoController.dispose();
    _videoController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: FadeTransition(
        opacity: _fadeInAnimation,
        child: Stack(
          children: [
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  height: _videoController.value.size.height,
                  width: _videoController.value.size.width,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  height: _videoController2.value.size.height,
                  width: _videoController2.value.size.width,
                  child: AnimatedOpacity(
                    opacity: isShowingSecondVideo ? 1 : 0,
                    duration: _transitionDuration,
                    child: VideoPlayer(_videoController2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _initAndStartFade() {
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeInAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeInController, curve: Curves.easeIn));

    _fadeInController.forward();
  }

  void _initVideoControllers() {
    _videoController =
        VideoPlayerController.asset(
            _videoPath,
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
          )
          ..setVolume(0)
          ..initialize().then((_) {
            setState(() {});
            _videoController.play();
          });

    _videoController2 =
        VideoPlayerController.asset(
            _videoPath,
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
          )
          ..setVolume(0)
          ..initialize();
  }

  void _setUpVideoListeners() {
    _videoController.addListener(() {
      if (!isShowingSecondVideo && _isControllerAtEnd(_videoController)) {
        setState(() {
          isShowingSecondVideo = true;
        });
        _videoController2.play();

        Future.delayed(_transitionDuration).then((_) {
          _videoController.seekTo(Duration.zero);
          _videoController.pause();
        });
      }
    });

    _videoController2.addListener(() {
      if (isShowingSecondVideo && _isControllerAtEnd(_videoController2)) {
        setState(() {
          isShowingSecondVideo = false;
        });
        _videoController.play();

        Future.delayed(_transitionDuration).then((_) {
          _videoController2.seekTo(Duration.zero);
          _videoController2.pause();
        });
      }
    });
  }

  bool _isControllerAtEnd(VideoPlayerController controller) {
    return controller.value.position.inSeconds != 0 &&
        controller.value.position.inSeconds >=
            controller.value.duration.inSeconds - _transitionDuration.inSeconds;
  }
}
