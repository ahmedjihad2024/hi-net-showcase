import 'package:flutter/material.dart';

import 'animations_enum.dart';

class AnimatedOnScroll extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final int delay;
  final SlideDirection slideDirection;
  final RotationDirection rotationDirection;
  final double slideDistance;
  final double rotationAngle;
  final Duration animationDuration;
  final Duration? animationDelay;
  final Curve animationCurve;
  final Set<AnimationType> animationTypes;

  const AnimatedOnScroll({
    super.key,
    required this.child,
    required this.scrollController,
    this.delay = 0,
    this.slideDirection = SlideDirection.up,
    this.rotationDirection = RotationDirection.left,
    this.slideDistance = 50.0,
    this.rotationAngle = 5.0, // Default to 5 degrees
    this.animationDuration = const Duration(milliseconds: 800),
    this.animationDelay,
    this.animationCurve = Curves.easeOutCubic,
    this.animationTypes = const {AnimationType.slide, AnimationType.fade},
  });

  // Convert degrees to turns
  double get _rotationInTurns => rotationAngle / 360.0;

  @override
  State<AnimatedOnScroll> createState() => _AnimatedOnScrollState();
}

class _AnimatedOnScrollState extends State<AnimatedOnScroll>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  bool _isVisible = false;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Include the delay in the total animation duration
    final totalDuration = widget.animationDuration +
        (widget.animationDelay ?? Duration(milliseconds: widget.delay));

    _animationController = AnimationController(
      vsync: this,
      duration: totalDuration,
    );

    // Calculate the interval for the delayed animation
    final double delayFraction =
        (widget.animationDelay?.inMilliseconds ?? widget.delay) /
            totalDuration.inMilliseconds;
    final Interval delayedCurve = Interval(
      delayFraction, // Start after the delay
      1.0, // End at the end
      curve: widget.animationCurve,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: delayedCurve,
      ),
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: delayedCurve,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: delayedCurve,
      ),
    );

    // Initialize rotation animation
    final double startAngle = widget.rotationDirection == RotationDirection.left
        ? widget._rotationInTurns
        : -widget._rotationInTurns;
    _rotationAnimation = Tween<double>(
      begin: startAngle,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: delayedCurve,
      ),
    );

    // For pulse animation, adjust the interval to occur after the delay
    final pulseStart = delayFraction + ((1.0 - delayFraction) * 0.6);
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.08)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(pulseStart, 1.0),
      ),
    );

    // Add scroll listener to check visibility
    widget.scrollController.addListener(_checkVisibility);

    // Add post-frame callback to check initial visibility
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (!mounted) return;

    final RenderBox? renderBox =
        _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    // Get screen size
    final screenSize = MediaQuery.of(context).size;

    // Check if component is visible (at least 30% of it is on screen)
    final isVisible = position.dy + (size.height * 0.3) < screenSize.height &&
        position.dy + size.height > 0;

    if (isVisible && !_isVisible) {
      setState(() {
        _isVisible = true;
      });

      // Start animation immediately - the delay is now handled by the Interval
      if (mounted) {
        _animationController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget animatedWidget = widget.child;

    // Apply animations based on selected types
    if (widget.animationTypes.contains(AnimationType.pulse)) {
      animatedWidget = ScaleTransition(
        scale: _pulseAnimation,
        child: animatedWidget,
      );
    }

    if (widget.animationTypes.contains(AnimationType.scale)) {
      animatedWidget = ScaleTransition(
        scale: _scaleAnimation,
        child: animatedWidget,
      );
    }

    if (widget.animationTypes.contains(AnimationType.rotation)) {
      animatedWidget = RotationTransition(
        turns: _rotationAnimation,
        child: animatedWidget,
      );
    }

    if (widget.animationTypes.contains(AnimationType.slide)) {
      animatedWidget = AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          double offset = widget.slideDistance * _slideAnimation.value;
          Offset translation;

          switch (widget.slideDirection) {
            case SlideDirection.up:
              translation = Offset(0, offset);
              break;
            case SlideDirection.down:
              translation = Offset(0, -offset);
              break;
            case SlideDirection.left:
              translation = Offset(offset, 0);
              break;
            case SlideDirection.right:
              translation = Offset(-offset, 0);
              break;
          }

          return Transform.translate(
            offset: translation,
            child: child,
          );
        },
        child: animatedWidget,
      );
    }

    if (widget.animationTypes.contains(AnimationType.fade)) {
      animatedWidget = FadeTransition(
        opacity: _fadeAnimation,
        child: animatedWidget,
      );
    }

    return Container(
      key: _key,
      child: animatedWidget,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.scrollController.removeListener(_checkVisibility);
    super.dispose();
  }
}
