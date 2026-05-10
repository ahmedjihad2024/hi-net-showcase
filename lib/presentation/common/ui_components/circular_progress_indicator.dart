import 'package:flutter/material.dart';
import 'package:hi_net/presentation/res/color_manager.dart';

class MyCircularProgressIndicator extends StatelessWidget {
  const MyCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 40,
        height: 40,
        child: CircularProgressIndicator(
          color: ColorM.primary,
          backgroundColor: ColorM.secondary.withValues(alpha: .1),
          strokeCap: StrokeCap.round,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
