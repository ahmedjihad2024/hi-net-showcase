import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/common/ui_components/custom_check_box.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/common/ui_components/gradient_border_side.dart'
    as gradient_border_side;

class PaymentMethodItem extends StatefulWidget {
  final String image;
  final bool isSelected;
  final bool isBlackAndWhite;
  final void Function(bool value) onChange;
  const PaymentMethodItem({
    super.key,
    required this.image,
    this.isSelected = false,
    required this.onChange,
    this.isBlackAndWhite = false,
  });

  @override
  State<PaymentMethodItem> createState() => _PaymentMethodItemState();
}

class _PaymentMethodItemState extends State<PaymentMethodItem> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  void _onChange(bool value) {
    setState(() {
      isSelected = value;
    });
  }

  @override
  void didUpdateWidget(PaymentMethodItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (mounted) {
      _onChange(widget.isSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomInkButton(
      onTap: () {
        var newValue = !isSelected;
        if (newValue != widget.isSelected && widget.isSelected == false) {
          _onChange(newValue);
          widget.onChange(newValue);
        }
      },
      alignment: Alignment.center,
      side: isSelected
          ? gradient_border_side.BorderSide(
              color: context.colorScheme.surface,
              width: 1.w,
            )
          : gradient_border_side.BorderSide(
              color: context.colorScheme.surface.withValues(alpha: 0.2),
              width: 1.w,
            ),
      width: 82.w,
      height: 64.w,
      borderRadius: 12.r,
      child: Image.asset(
        widget.image,
        height: 30.w,
        fit: BoxFit.contain,
        color: widget.isBlackAndWhite ? context.colorScheme.surface : null,
      ),
    );
  }
}
