import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/common/ui_components/custom_form_field/simple_form.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';

class SearchField extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String)? onChange;
  const SearchField({super.key, required this.searchController, this.onChange});

  @override
  Widget build(BuildContext context) {
    return SimpleForm(
      height: 52.h,
      hintText: Translation.search.tr,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      controller: searchController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onChanged: onChange,
      backgroundColor: context.isDark ? Colors.black : Colors.transparent,
      prefixWidget: SvgPicture.asset(
        SvgM.search,
        colorFilter: ColorFilter.mode(
          context.labelLarge.color!.withValues(alpha: .8),
          BlendMode.srcIn,
        ),
        width: 16.w,
        height: 16.w,
      ),
    );
  }
}
