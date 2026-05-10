import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/routes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:nice_text_form/common/custom_ink_button.dart';
import '../../../../common/utils/zesty_snack.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomInkButton(
      onTap: () {
        ZestySnack.instance.hide();
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(RoutesManager.signIn.route, (route) => false);
      },
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.w),
      alignment: Alignment.center,
      smoothness: 1,
      borderRadius: 10.r,
      backgroundColor: context.colorScheme.secondary,
      child: ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.2, .6],
            colors: [ColorM.primary, ColorM.secondary],
          ).createShader(bounds);
        },
        child: Text(
          Translation.sign_in.tr,
          style: context.labelMedium.copyWith(fontWeight: FontWeightM.regular),
        ),
      ),
    );
  }
}

class PleaseSignInButton extends StatelessWidget {
  final bool noLable;
  const PleaseSignInButton({super.key, this.noLable = false});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 13.w,
      children: [
        if (!noLable)
          Text(
            Translation.please_sign_in.tr,
            style: context.titleMedium.copyWith(
              fontWeight: FontWeightM.regular,
            ),
          ),
        CustomInkButton(
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              RoutesManager.signIn.route,
              (route) => false,
            );
          },
          width: 130.w,
          height: 40.h,
          alignment: Alignment.center,
          smoothness: 1,
          borderRadius: 12.r,
          backgroundColor: ColorM.primary.withValues(alpha: .03),
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.2, .6],
                colors: [ColorM.primary, ColorM.secondary],
              ).createShader(bounds);
            },
            child: Text(
              Translation.sign_in.tr,
              style: context.labelLarge.copyWith(
                fontWeight: FontWeightM.regular,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
