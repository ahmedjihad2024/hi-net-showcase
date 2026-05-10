import 'package:flutter/material.dart';

import 'package:nice_text_form/nice_text_form.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/app/extensions.dart';

import 'custom_form_field.dart';
import '../../../res/color_manager.dart';

class PhoneForm extends StatelessWidget {
  final TextEditingController controller;
  final Function(CountryCode) countryCode;
  final String? Function(String)? validator;
  final FocusNode? focusNode;
  final Widget? label;
  final int? textLength;
  final bool showCountryCode;

  const PhoneForm(
      {super.key,
      required this.controller,
      required this.countryCode,
      this.focusNode,
      this.validator,
      this.label,
      this.textLength,
      this.showCountryCode = true});

  @override
  Widget build(BuildContext context) {
    return NiceTextForm(
      height: 50.w,
      isPhoneForm: true,
      width: double.infinity,
      showCountryCode: showCountryCode,
      textLength: textLength,
      initialSelectionFlag: "EG",
      cursorColor: Colors.black,
      focusNode: focusNode,
      label: label,
      boxDecoration: BoxDecoration(
          color: context.colorScheme.onPrimaryContainer,
          borderRadius: BorderRadius.circular(13.r),
          border: Border.all(
              color: context.colorScheme.onPrimary.withOpacity(.2), width: .5)),
      activeBoxDecoration: BoxDecoration(
        color: context.colorScheme.onPrimaryContainer,
        borderRadius: BorderRadius.circular(13.r),
        border: Border.all(color: context.colorScheme.onPrimary, width: .5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      keyboardType: TextInputType.number,
      hintText: "123 456-7890",
      validator: validator,
      validatorStyle: context.titleSmall.copyWith(
        fontSize: 15.sp,
        color: Colors.red,
      ),
      textStyle: context.titleSmall.copyWith(
        fontSize: 16.sp,
        color: Colors.black,
      ),
      hintStyle: context.titleSmall.copyWith(
        fontSize: 16.sp,
        color: Colors.black.withOpacity(.4),
      ),

      textEditingController: controller,
      countryCode: countryCode,
      // sufixWidget: SvgPicture.asset(
      //   AppSvg.call,
      //   width:  25.w,
      // ),
    );
  }
}
