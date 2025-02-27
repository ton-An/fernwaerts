// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of in_app_notification;

const double _kMinFlingVelocity = 700.0;
const double _kMinFlingVelocityDelta = 400.0;
const double _kFlingVelocityScale = 1.0 / 300.0;

enum _FlingGestureKind { none, forward, reverse }

/// This is a cut down version of the Dismissible widget from Flutter.
class _Dismissible extends StatefulWidget {
  const _Dismissible({
    required Key key,
    required this.child,
    this.onDismissed,
    this.dismissThreshold = 0.4,
    this.movementDuration = const Duration(milliseconds: 200),
    this.reverseMovementDuration = const Duration(milliseconds: 200),
    this.entryDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  final Widget child;

  final VoidCallback? onDismissed;

  final double dismissThreshold;

  final Duration movementDuration;

  final Duration reverseMovementDuration;

  final Duration entryDuration;

  @override
  State<_Dismissible> createState() => _DismissibleState();
}

class _DismissibleState extends State<_Dismissible>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(
        duration: widget.movementDuration,
        reverseDuration: widget.reverseMovementDuration,
        vsync: this)
      ..addStatusListener(_handleDismissStatusChanged);
    _updateMoveAnimation();

    _entryController = AnimationController(
        duration: widget.entryDuration, vsync: this)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.read<InAppNotificationCubit>().confirmNotificationDelivered();
        }
      });

    _entryAnimation = _entryController!.drive(Tween<Offset>(
      end: Offset.zero,
      begin: const Offset(
        0,
        -1,
      ),
    ).chain(CurveTween(curve: Curves.easeOutCubic)));

    // ToDo: might restart if init state is called again? during the animation. Might not be a problem tho because of wantKeepAlive ??
    if (context.read<InAppNotificationCubit>().state
        is InAppNotificationDelivering) {
      _entryController!.forward();
    }
  }

  AnimationController? _moveController;
  late Animation<Offset> _moveAnimation;

  AnimationController? _entryController;
  late Animation<Offset> _entryAnimation;

  double _dragExtent = 0.0;
  bool _dragUnderway = false;

  final GlobalKey _contentKey = GlobalKey();

  @override
  bool get wantKeepAlive =>
      (_moveController?.isAnimating ?? false) ||
      (_entryController?.isAnimating ?? false);

  @override
  void dispose() {
    _moveController!.dispose();
    _entryController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

    return GestureDetector(
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: BlocBuilder<InAppNotificationCubit, InAppNotificationState>(
        builder: (context, state) {
          return SlideTransition(
            position: state is InAppNotificationDelivering
                ? _entryAnimation
                : _moveAnimation,
            child: KeyedSubtree(key: _contentKey, child: widget.child),
          );
        },
      ),
    );
  }

  bool get _isActive {
    return _dragUnderway || _moveController!.isAnimating;
  }

  double get _overallDragAxisExtent {
    final Size size = context.size!;
    return size.height;
  }

  void _handleDragStart(DragStartDetails details) {
    _dragUnderway = true;
    if (_moveController!.isAnimating) {
      _dragExtent =
          _moveController!.value * _overallDragAxisExtent * _dragExtent.sign;
      _moveController!.stop();
    } else {
      _dragExtent = 0.0;
      _moveController!.value = 0.0;
    }
    setState(() {
      _updateMoveAnimation();
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isActive || _moveController!.isAnimating) {
      return;
    }

    final double delta = details.primaryDelta!;
    final double oldDragExtent = _dragExtent;

    if (_dragExtent + delta < 0) {
      _dragExtent += delta;
    }

    if (oldDragExtent.sign != _dragExtent.sign) {
      setState(() {
        _updateMoveAnimation();
      });
    }
    if (!_moveController!.isAnimating) {
      _moveController!.value = _dragExtent.abs() / _overallDragAxisExtent;
    }
  }

  void _updateMoveAnimation() {
    final double end = _dragExtent.sign;
    _moveAnimation = _moveController!.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: Offset(0, end),
      ),
    );
  }

  _FlingGestureKind _describeFlingGesture(Velocity velocity) {
    if (_dragExtent == 0.0) {
      // If it was a fling, then it was a fling that was let loose at the exact
      // middle of the range (i.e. when there's no displacement). In that case,
      // we assume that the user meant to fling it back to the center, as
      // opposed to having wanted to drag it out one way, then fling it past the
      // center and into and out the other side.
      return _FlingGestureKind.none;
    }
    final double vx = velocity.pixelsPerSecond.dx;
    final double vy = velocity.pixelsPerSecond.dy;
    final bool isDismissDirection = vy < 0;

    // Verify that the fling is in the generally right direction and fast enough.

    if (vy.abs() - vx.abs() < _kMinFlingVelocityDelta ||
        vy.abs() < _kMinFlingVelocity) {
      return _FlingGestureKind.none;
    }
    assert(vy != 0.0);
    if (isDismissDirection) {
      return _FlingGestureKind.forward;
    }
    return _FlingGestureKind.reverse;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isActive || _moveController!.isAnimating) {
      return;
    }
    _dragUnderway = false;
    if (_moveController!.isCompleted) {
      _handleMoveCompleted();
      return;
    }
    final double flingVelocity = details.velocity.pixelsPerSecond.dy;

    switch (_describeFlingGesture(details.velocity)) {
      case _FlingGestureKind.forward:
        assert(_dragExtent != 0.0);
        assert(!_moveController!.isDismissed);
        if ((widget.dismissThreshold) >= 1.0) {
          _moveController!.reverse();
          break;
        }
        _dragExtent = flingVelocity.sign;
        _moveController!
            .fling(velocity: flingVelocity.abs() * _kFlingVelocityScale);
      case _FlingGestureKind.reverse:
        assert(_dragExtent != 0.0);
        assert(!_moveController!.isDismissed);
        _dragExtent = flingVelocity.sign;
        _moveController!
            .fling(velocity: -flingVelocity.abs() * _kFlingVelocityScale);
      case _FlingGestureKind.none:
        if (!_moveController!.isDismissed) {
          // we already know it's not completed, we check that above
          if (_moveController!.value > (widget.dismissThreshold)) {
            _moveController!.forward();
          } else {
            _moveController!.reverse();
          }
        }
    }
  }

  Future<void> _handleDismissStatusChanged(AnimationStatus status) async {
    if (status == AnimationStatus.completed && !_dragUnderway) {
      await _handleMoveCompleted();
    }
    if (mounted) {
      updateKeepAlive();
    }
  }

  Future<void> _handleMoveCompleted() async {
    if ((widget.dismissThreshold) >= 1.0) {
      _moveController!.reverse();
      return;
    }

    await _moveController!.forward();

    if (widget.onDismissed != null) {
      widget.onDismissed!();
    }
  }
}
