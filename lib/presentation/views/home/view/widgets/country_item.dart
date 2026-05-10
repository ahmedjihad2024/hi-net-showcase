import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/common/ui_components/custom_cached_image.dart';
import 'package:hi_net/presentation/common/ui_components/custom_check_box.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';

class CountryItem extends StatefulWidget {
  final String imageUrl;
  final String countryName;
  final bool isSelected;
  final void Function(bool value) onChange;
  const CountryItem({
    super.key,
    required this.imageUrl,
    required this.countryName,
    required this.isSelected,
    required this.onChange,
  });

  @override
  State<CountryItem> createState() => _CountryItemState();
}

class _CountryItemState extends State<CountryItem> {
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
    widget.onChange(value);
  }

  @override
  Widget build(BuildContext context) {
    return CustomInkButton(
      onTap: () {
        _onChange(!isSelected);
      },
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      backgroundColor: context.colorScheme.onSurface,
      borderRadius: 99999,
      child: Row(
        spacing: 14.w,
        children: [
          CustomCachedImage(
            imageUrl: widget.imageUrl,
            width: 24.w,
            height: 24.w,
            borderRadius: BorderRadius.circular(999999),
          ),
          Expanded(
            child: Text(
              widget.countryName,
              maxLines: 2,
              style: context.labelLarge.copyWith(height: 1.1),
            ),
          ),
          CustomCheckBox(
            value: isSelected,
            onChange: (value) {
              _onChange(value);
            },
            width: 24.w,
            height: 24.w,
            borderRadius: 999999,
          ),
        ],
      ),
    );
  }
}

class CountryItem2 extends StatefulWidget {
  final String imageUrl;
  final String countryName;
  final bool circleIcon;
  final void Function() onTap;
  const CountryItem2({
    super.key,
    required this.imageUrl,
    required this.countryName,
    required this.onTap,
    this.circleIcon = false,
  });

  @override
  State<CountryItem2> createState() => _CountryItem2State();
}

class _CountryItem2State extends State<CountryItem2> {
  @override
  Widget build(BuildContext context) {
    return CustomInkButton(
      onTap: widget.onTap,
      width: double.infinity,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: SizeM.pagePadding.dg,
        vertical: 12.w,
      ),
      borderRadius: 0,
      child: Row(
        spacing: 14.w,
        children: [
          CustomCachedImage(
            imageUrl: widget.imageUrl,
            width: 24.w,
            height: 24.w,
            borderRadius: widget.circleIcon
                ? BorderRadius.circular(999999)
                : BorderRadius.circular(6.r),
          ),
          Expanded(
            child: Text(
              widget.countryName,
              style: context.labelLarge.copyWith(height: 1.1),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16.w,
            color: context.colorScheme.surface.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
