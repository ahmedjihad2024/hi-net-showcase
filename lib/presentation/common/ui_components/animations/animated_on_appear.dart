import 'dart:ui';

import 'package:flutter/material.dart';

import 'animations_enum.dart';

enum BlurAnimationDirection { x, y, both }

/// A widget that animates its child when it first appears on screen.
///
/// Unlike [AnimatedOnScroll], this widget automatically animates when it is built,
/// making it ideal for page transitions or initial animations.
///
/// Supports both enter and exit animations for list items.
class AnimatedOnAppear extends StatefulWidget {
  final Widget child;
  final int delay;
  final SlideDirection slideDirection;
  final RotationDirection rotationDirection;
  final double slideDistance;
  final double rotationAngle; // Now in degrees
  final Duration animationDuration;
  final Curve animationCurve;
  final Set<AnimationType> animationTypes;
  final bool animate;
  final VoidCallback? onAnimationComplete;
  final double scaleSize;
  final ShaderRevealDirection shaderDirection;
  final Color shaderRevealColor;
  final double shaderSoftness;
  final BlendMode shaderBlendMode;

  // Exit animation properties
  final bool animateExit;
  final Duration exitDuration;
  final Curve exitCurve;
  final VoidCallback? onExitComplete;

  // Blur animation
  final Curve blurAnimationCurve;
  final double blurIntensity;
  final bool blurEnabled;
  final BlurAnimationDirection blurDirection;

  const AnimatedOnAppear({
    super.key,
    required this.child,
    this.delay = 0,
    this.slideDirection = SlideDirection.up,
    this.rotationDirection = RotationDirection.left,
    this.slideDistance = 50.0,
    this.rotationAngle = 5.0, // Default to 45 degrees
    this.animationDuration = const Duration(milliseconds: 800),
    this.animationCurve = Curves.easeOutCubic,
    this.animationTypes = const {AnimationType.slide, AnimationType.fade},
    this.animate = true,
    this.onAnimationComplete,
    this.scaleSize = 0.9,
    this.shaderDirection = ShaderRevealDirection.bottomToTop,
    this.shaderRevealColor = Colors.white,
    this.shaderSoftness = 0.2,
    this.shaderBlendMode = BlendMode.dstIn,
    this.animateExit = false,
    this.exitDuration = const Duration(milliseconds: 300),
    this.exitCurve = Curves.easeInCubic,
    this.onExitComplete,
    this.blurDirection = BlurAnimationDirection.y,
    this.blurEnabled = false,
    this.blurIntensity = 7.0,
    this.blurAnimationCurve = Curves.fastEaseInToSlowEaseOut,
  }) : assert(
         shaderSoftness >= 0 && shaderSoftness <= 1,
         'shaderSoftness must be between 0 and 1',
       );

  // Convert degrees to turns
  double get _rotationInTurns => rotationAngle / 360.0;

  @override
  State<AnimatedOnAppear> createState() => _AnimatedOnAppearState();
}

class _AnimatedOnAppearState extends State<AnimatedOnAppear>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _shaderAnimation;
  late Animation<double> _blurAnimation;

  bool _isExiting = false;
  bool _exitAnimationComplete = false;

  @override
  void initState() {
    super.initState();

    // Include the delay in the total animation duration
    final totalDuration =
        widget.animationDuration + Duration(milliseconds: widget.delay);

    _animationController = AnimationController(
      vsync: this,
      duration: totalDuration,
    );

    // Calculate the interval for the delayed animation
    final double delayFraction = widget.delay / totalDuration.inMilliseconds;
    final Interval delayedCurve = Interval(
      delayFraction, // Start after the delay
      1.0, // End at the end
      curve: widget.animationCurve,
    );

    // Apply the delayed curve to all animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: delayedCurve),
    );

    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: delayedCurve),
    );

    _scaleAnimation = Tween<double>(begin: widget.scaleSize, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: delayedCurve),
    );

    _blurAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: delayedCurve),
    );

    // Initialize rotation animation with degrees converted to turns
    final double startAngle = widget.rotationDirection == RotationDirection.left
        ? widget._rotationInTurns
        : -widget._rotationInTurns;
    _rotationAnimation = Tween<double>(begin: startAngle, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: delayedCurve),
    );

    _shaderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: widget.blurAnimationCurve),
    );

    // For pulse animation, we need to adjust the interval to occur after the delay
    final pulseStart = delayFraction + ((1.0 - delayFraction) * 0.6);
    _pulseAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 1.0,
              end: 1.08,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 1.08,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 50,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(pulseStart, 1.0),
          ),
        );

    // Add listener for animation completion
    _animationController.addStatusListener(_animationStatusListener);

    // Start animation immediately - the delay is now handled by the Interval
    if (widget.animate) {
      _animationController.forward();
    }
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (_isExiting) {
        // Exit animation completed
        _exitAnimationComplete = true;
        widget.onExitComplete?.call();
      } else {
        // Enter animation completed
        widget.onAnimationComplete?.call();
      }
    } else if (status == AnimationStatus.dismissed && _isExiting) {
      // Exit animation dismissed/completed
      _exitAnimationComplete = true;
      widget.onExitComplete?.call();
    }
  }

  Alignment _shaderBeginAlignment(
    ShaderRevealDirection direction,
    TextDirection textDirection,
  ) {
    switch (direction) {
      case ShaderRevealDirection.bottomToTop:
        return Alignment.bottomCenter;
      case ShaderRevealDirection.topToBottom:
        return Alignment.topCenter;
      case ShaderRevealDirection.leftToRight:
        return Alignment.centerLeft;
      case ShaderRevealDirection.rightToLeft:
        return Alignment.centerRight;
      case ShaderRevealDirection.startToEnd:
        return textDirection == TextDirection.rtl
            ? Alignment.centerRight
            : Alignment.centerLeft;
      case ShaderRevealDirection.endToStart:
        return textDirection == TextDirection.rtl
            ? Alignment.centerLeft
            : Alignment.centerRight;
    }
  }

  Alignment _shaderEndAlignment(
    ShaderRevealDirection direction,
    TextDirection textDirection,
  ) {
    switch (direction) {
      case ShaderRevealDirection.bottomToTop:
        return Alignment.topCenter;
      case ShaderRevealDirection.topToBottom:
        return Alignment.bottomCenter;
      case ShaderRevealDirection.leftToRight:
        return Alignment.centerRight;
      case ShaderRevealDirection.rightToLeft:
        return Alignment.centerLeft;
      case ShaderRevealDirection.startToEnd:
        return textDirection == TextDirection.rtl
            ? Alignment.centerLeft
            : Alignment.centerRight;
      case ShaderRevealDirection.endToStart:
        return textDirection == TextDirection.rtl
            ? Alignment.centerRight
            : Alignment.centerLeft;
    }
  }

  List<double> _shaderStops(double progress) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final transitionEnd = (clampedProgress + widget.shaderSoftness).clamp(
      0.0,
      1.0,
    );

    if (transitionEnd <= 0) {
      return const [0.0, 0.0, 0.0];
    }

    if (clampedProgress <= 0.0) {
      return [0.0, 0.0, transitionEnd];
    }

    return [0.0, clampedProgress, transitionEnd];
  }

  /// Triggers the exit animation
  void exit() {
    if (widget.animateExit && !_isExiting) {
      setState(() {
        _isExiting = true;
      });

      // Update controller duration for exit animation
      _animationController.duration = widget.exitDuration;

      // Reverse the animation for exit
      _animationController.reverse();
    } else {
      // If exit animation is not enabled, call callback immediately
      widget.onExitComplete?.call();
    }
  }

  @override
  void didUpdateWidget(AnimatedOnAppear oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update exit duration if changed
    if (widget.exitDuration != oldWidget.exitDuration && _isExiting) {
      _animationController.duration = widget.exitDuration;
    }

    // Handle animate property changes
    if (widget.animate && !oldWidget.animate && !_isExiting) {
      _animationController.duration =
          widget.animationDuration + Duration(milliseconds: widget.delay);
      _animationController.forward();
    } else if (!widget.animate && oldWidget.animate && !_isExiting) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_animationStatusListener);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    // If exit animation is complete, return empty container
    if (_exitAnimationComplete) {
      return const SizedBox.shrink();
    }

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

    if (widget.animationTypes.contains(AnimationType.shader)) {
      animatedWidget = AnimatedBuilder(
        animation: _shaderAnimation,
        builder: (context, child) {
          final progress = (widget.animate || _isExiting)
              ? _shaderAnimation.value
              : 1.0;
          final textDirection = Directionality.of(context);

          return ShaderMask(
            shaderCallback: (Rect bounds) {
              if (progress <= 0.0) {
                return LinearGradient(
                  begin: _shaderBeginAlignment(
                    widget.shaderDirection,
                    textDirection,
                  ),
                  end: _shaderEndAlignment(
                    widget.shaderDirection,
                    textDirection,
                  ),
                  colors: [
                    widget.shaderRevealColor.withOpacity(0.0),
                    widget.shaderRevealColor.withOpacity(0.0),
                  ],
                  stops: const [0.0, 1.0],
                ).createShader(bounds);
              }

              final stops = _shaderStops(progress);
              return LinearGradient(
                begin: _shaderBeginAlignment(
                  widget.shaderDirection,
                  textDirection,
                ),
                end: _shaderEndAlignment(widget.shaderDirection, textDirection),
                colors: [
                  widget.shaderRevealColor,
                  widget.shaderRevealColor,
                  widget.shaderRevealColor.withOpacity(0.0),
                ],
                stops: stops,
              ).createShader(bounds);
            },
            blendMode: widget.shaderBlendMode,
            child: child,
          );
        },
        child: animatedWidget,
      );
    }

    if (widget.animationTypes.contains(AnimationType.slide)) {
      animatedWidget = AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          // Enter: slideAnimation goes from 1.0 to 0.0
          // Exit: slideAnimation goes from 0.0 to 1.0 (when reversed)
          double offset = widget.slideDistance * _slideAnimation.value;
          Offset translation;

          switch (widget.slideDirection) {
            case SlideDirection.up:
              // Enter: slides up from bottom (offset: slideDistance -> 0)
              // Exit: slides down to bottom (offset: 0 -> slideDistance)
              translation = Offset(0, offset);
              break;
            case SlideDirection.down:
              // Enter: slides down from top (offset: -slideDistance -> 0)
              // Exit: slides up to top (offset: 0 -> -slideDistance)
              translation = Offset(0, -offset);
              break;
            case SlideDirection.left:
              // Enter: slides from left (offset: slideDistance -> 0)
              // Exit: slides to left (offset: 0 -> slideDistance)
              translation = Offset(offset, 0);
              break;
            case SlideDirection.right:
              // Enter: slides from right (offset: -slideDistance -> 0)
              // Exit: slides to right (offset: 0 -> -slideDistance)
              translation = Offset(-offset, 0);
              break;
          }

          return Transform.translate(offset: translation, child: child);
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

    if (widget.blurEnabled) {
      animatedWidget = AnimatedBuilder(
        animation: _blurAnimation,
        child: animatedWidget,
        builder: (context, child) {
          return ImageFiltered(
            imageFilter: switch (widget.blurDirection) {
              BlurAnimationDirection.x => ImageFilter.blur(
                sigmaX: widget.blurIntensity * _blurAnimation.value,
                sigmaY: 0,
              ),
              BlurAnimationDirection.y => ImageFilter.blur(
                sigmaX: 0,
                sigmaY: widget.blurIntensity * _blurAnimation.value,
              ),
              BlurAnimationDirection.both => ImageFilter.blur(
                sigmaX: widget.blurIntensity * _blurAnimation.value,
                sigmaY: widget.blurIntensity * _blurAnimation.value,
              ),
            },
            child: child,
          );
        },
      );
    }

    return animatedWidget;
  }

  @override
  bool get wantKeepAlive => true;
}

/// Extension to easily trigger exit animations
extension AnimatedOnAppearExtension on GlobalKey<_AnimatedOnAppearState> {
  /// Triggers the exit animation for this widget
  void exit() {
    currentState?.exit();
  }
}
