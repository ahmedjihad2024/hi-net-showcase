
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class HalfCircleProgress extends StatefulWidget {
  final double size;
  final double progress; // 0.0 to 1.0
  final double strokeWidth;
  final Color? progressColor;
  final Gradient? progressGradient;
  final Color backgroundColor;
  final Widget? child; // Custom widget for center content
  final Duration animationDuration;
  final Curve animationCurve;
  final Duration delay;
  const HalfCircleProgress({
    Key? key,
    this.size = 100,
    required this.progress,
    this.strokeWidth = 8,
    this.progressColor = Colors.blue,
    this.progressGradient,
    this.backgroundColor = Colors.grey,
    this.child,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.animationCurve = Curves.fastEaseInToSlowEaseOut,
    this.delay = const Duration(milliseconds: 0),
  }) : super(key: key);

  @override
  State<HalfCircleProgress> createState() => _HalfCircleProgressState();
}

class _HalfCircleProgressState extends State<HalfCircleProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousProgress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: widget.progress.clamp(0.0, 1.0))
        .animate(
          CurvedAnimation(parent: _controller, curve: widget.animationCurve),
        );

    _previousProgress = widget.progress;

    _timer = Timer(widget.delay, () {
     try{
      _controller.forward();
     }catch(e){
      print(e);
     }
    });
  }

  @override
  void didUpdateWidget(HalfCircleProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Animate when progress changes
    if (oldWidget.progress != widget.progress) {
      _animation =
          Tween<double>(
            begin: _previousProgress.clamp(0.0, 1.0),
            end: widget.progress.clamp(0.0, 1.0),
          ).animate(
            CurvedAnimation(parent: _controller, curve: widget.animationCurve),
          );

      _controller
        ..reset()
        ..forward();

      _previousProgress = widget.progress;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size / 2,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              CustomPaint(
                size: Size(widget.size, widget.size / 2),
                painter: HalfCircleProgressPainter(
                  progress: _animation.value,
                  strokeWidth: widget.strokeWidth,
                  progressColor: widget.progressColor,
                  progressGradient: widget.progressGradient,
                  backgroundColor: widget.backgroundColor,
                ),
              ),
              if (widget.child != null)
                Positioned(top: (widget.size * 0.95) * 0.25, child: widget.child!),
            ],
          ),
        );
      },
    );
  }
}

class HalfCircleProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color? progressColor;
  final Gradient? progressGradient;
  final Color backgroundColor;

  HalfCircleProgressPainter({
    required this.progress,
    required this.strokeWidth,
    this.progressColor,
    this.progressGradient,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.95);
    final radius = (size.width - strokeWidth) / 2;

    // Background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start from left (180 degrees)
      math.pi, // Draw half circle (180 degrees)
      false,
      backgroundPaint,
    );

    // Progress arc
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    if (progressGradient != null) {
      progressPaint.shader = progressGradient!.createShader(Rect.fromCircle(center: center, radius: radius));
    } else {
      progressPaint.color = progressColor!;
    }

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start from left (180 degrees)
      math.pi * progress, // Progress portion
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(HalfCircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
