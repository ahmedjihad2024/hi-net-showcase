import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hi_net/app/dependency_injection.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/app/services/app_preferences.dart';
import 'package:hi_net/app/supported_locales.dart';
import 'package:hi_net/presentation/common/ui_components/animations/animations_enum.dart';
import 'package:hi_net/presentation/common/ui_components/custom_cached_image.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/common/ui_components/custom_switch.dart';
import 'package:hi_net/presentation/common/ui_components/customized_smart_refresh.dart';
import 'package:hi_net/presentation/common/ui_components/gradient_border_side.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/routes_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/views/edit_account/screens/widgets/delete_account_sheet.dart';
import 'package:hi_net/presentation/views/home/view/widgets/settings_group_items.dart';
import 'package:hi_net/presentation/views/home/view/widgets/sign_in_button.dart';
import 'package:hi_net/presentation/views/splash/screens/view/splash_view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hi_net/presentation/views/checkout/view/widgets/rate_dialog.dart';
import '../../../../../../app/services/app_rate_services.dart';
import '../../../bloc/home_bloc.dart';
import 'package:money2/money2.dart' as money;

class TapProfileView extends StatefulWidget {
  const TapProfileView({super.key});

  @override
  State<TapProfileView> createState() => _TapProfileViewState();
}

class _TapProfileViewState extends State<TapProfileView> {
  Future<void> toggleLanguage(BuildContext con) async {
    if (con.locale == SupportedLocales.EN.locale) {
      await context.setLocale(SupportedLocales.AR.locale);
    } else {
      await context.setLocale(SupportedLocales.EN.locale);
    }
  }

  HomeState get state => context.read<HomeBloc>().state;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            (20 +
                    (View.of(context).viewPadding.top /
                        View.of(context).devicePixelRatio))
                .verticalSpace,
            topAppBar().animatedOnAppear(1, SlideDirection.down),
            18.verticalSpace,
            if (instance<AppPreferences>().isUserRegistered) ...[
              userInformation().animatedOnAppear(0, SlideDirection.down),
              14.verticalSpace,
            ],

            settingsSection(),
          ],
        );
      },
    );
  }

  Widget topAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Translation.my_profile.tr,
            style: context.titleMedium.copyWith(
              fontWeight: FontWeightM.semiBold,
            ),
          ),

          if (instance<AppPreferences>().isUserRegistered)
            CustomInkButton(
              onTap: () {
                ConfirmationSheet.show(
                  context,
                  onConfirm: () {
                    context.read<HomeBloc>().add(
                      LogoutEvent(() {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          RoutesManager.signIn.route,
                          (route) => false,
                        );
                      }),
                    );
                  },
                  onCancel: () {
                    Navigator.pop(context);
                  },
                  title: Translation.logout.tr,
                  message: Translation.logout_message.tr,
                  confirmText: Translation.yes.tr,
                  cancelText: Translation.no.tr,
                );
              },
              width: 50.w,
              height: 50.w,
              borderRadius: 10000,
              backgroundColor: context.colorScheme.onSurface,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                SvgM.turnOffScreen,
                width: 20.w,
                height: 20.w,
              ),
            ),
        ],
      ),
    );
  }

  Widget userInformation() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      child: Row(
        spacing: 10.w,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              spacing: 14.w,
              children: [
                // user image
                CustomCachedImage(
                  imageUrl: state.profileImage ?? '',
                  width: 50.w,
                  height: 50.w,
                  isCircle: true,
                ),

                // user name
                Flexible(
                  child: Column(
                    spacing: 4.w,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.userName,
                        softWrap: true,
                        style: context.titleLarge.copyWith(
                          fontWeight: FontWeightM.medium,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RoutesManager.editAccount.route,
                          ).then((isUpdated) {
                            if ((isUpdated is bool) && isUpdated) {
                              context.read<HomeBloc>().add(InitUserDetails());
                            }
                          });
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [ColorM.primary, ColorM.secondary],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds);
                          },
                          child: Row(
                            spacing: 1.w,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                SvgM.edit,
                                width: 16.w,
                                height: 16.w,
                                colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              Text(
                                Translation.edit_profile.tr,
                                style: context.labelMedium.copyWith(
                                  fontWeight: FontWeightM.regular,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

         
          // user level
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.w),
            decoration: ShapeDecoration(
              shape: SmoothRectangleBorder(
                smoothness: 1,
                borderRadius: BorderRadius.circular(14.r),
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xFFAD46FF),
                  Color(0xFF9810FA),
                  Color(0xFFF6339A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 6.w,
              children: [
                Image.asset(state.userLevel.image, width: 30.w, height: 30.w),
                Text(
                  state.userLevel.tr,
                  style: context.titleMedium.copyWith(
                    fontWeight: FontWeightM.regular,
                    fontSize: 8.sp,
                    height: 0.8,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget settingsSection() {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: context.colorScheme.onSurface,
        child: CustomizedSmartRefresh(
          controller: context.read<HomeBloc>().profileRefreshController,
          enableRefresh: instance<AppPreferences>().isUserRegistered,
          onRefresh: () {
            context.read<HomeBloc>().add(GetUserDetailsEvent());
            context.read<HomeBloc>().add(GetPagesEvent());
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: SizeM.pagePadding.dg,
              vertical: 18.w,
            ),
            child: Column(
              children: [
                SettingsGroupItems(
                  title: Translation.general.tr,
                  items: [
                    if (instance<AppPreferences>().isUserRegistered)
                      SettingItem(
                        title: Translation.order_history.tr,
                        svg: SvgM.bagTick,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RoutesManager.orderHistory.route,
                          );
                        },
                      ),
                    SettingItem(
                      title: Translation.languages.tr,
                      svg: SvgM.languageCircle,
                      suffix: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: context.colorScheme.surface.withValues(
                              alpha: .1,
                            ),
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Row(
                          spacing: 3.w,
                          children: [
                            LanguageButton(
                              title: Translation.ar.tr,
                              onTap: () async {
                                if (context.locale !=
                                    SupportedLocales.AR.locale) {
                                  context.read<HomeBloc>().add(
                                    UpdateSettingsEvent(
                                      SupportedLocales.AR.locale.languageCode,
                                      null,
                                      () async {
                                        await toggleLanguage(context);
                                      },
                                    ),
                                  );
                                }
                              },
                              isSelected:
                                  context.locale == SupportedLocales.AR.locale,
                            ),
                            LanguageButton(
                              title: Translation.en.tr,
                              onTap: () async {
                                if (context.locale !=
                                    SupportedLocales.EN.locale) {
                                  context.read<HomeBloc>().add(
                                    UpdateSettingsEvent(
                                      SupportedLocales.EN.locale.languageCode,
                                      null,
                                      () async {
                                        await toggleLanguage(context);
                                      },
                                    ),
                                  );
                                }
                              },
                              isSelected:
                                  context.locale == SupportedLocales.EN.locale,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (instance<AppPreferences>().isUserRegistered)
                      SettingItem(
                        title: Translation.currency.tr,
                        svg: SvgM.coin,
                        lable: money.Money.fromNum(
                          0,
                          isoCode: state.globalCurrency!.name,
                        ).format("S").replaceAll(RegExp("^[0-9]"), ''),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RoutesManager.currency.route,
                            arguments: {
                              'on-selected-currency': (currency) {
                                context.read<HomeBloc>().add(
                                  UpdateUserCurrencyEvent(currency),
                                );
                              },
                            },
                          );
                        },
                      ),
                    if (instance<AppPreferences>().isUserRegistered)
                      ValueListenableBuilder(
                        valueListenable: context
                            .read<HomeBloc>()
                            .currentBalance,
                        builder: (context, balance, child) {
                          return SettingItem(
                            title: Translation.my_wallet.tr,
                            svg: SvgM.emptyWallet,
                            lable: money.Money.fromNum(
                              balance,
                              isoCode: state.globalCurrency?.name ?? "SAR",
                            ).format("#.## S"),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RoutesManager.wallet.route,
                              );
                            },
                          );
                        },
                      ),
                    if (instance<AppPreferences>().isUserRegistered)
                      SettingItem(
                        title: Translation.share_and_win.tr,
                        svg: SvgM.programmingArrows,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RoutesManager.shareAndWin.route,
                          );
                        },
                      ),
                    SettingItem(
                      title: Translation.dark_theme.tr,
                      svg: SvgM.moon,
                      suffix: CustomSwitch(
                        width: 44.w,
                        height: 22.w,
                        thumbSizeRatio: .8,
                        value: context.isLight,
                        trackBorderRadius: BorderRadius.circular(9999),
                        inactiveTrackWidget: Opacity(
                          opacity: .6,
                          child: SvgPicture.asset(
                            SvgM.darkModeIcon,
                            fit: BoxFit.cover,
                          ),
                        ),
                        activeTrackWidget: Opacity(
                          opacity: .6,
                          child: SvgPicture.asset(
                            SvgM.lightModeIcon,
                            fit: BoxFit.cover,
                          ),
                        ),
                        onChanged: (value) {
                          context.read<HomeBloc>().add(
                            UpdateSettingsEvent(
                              null,
                              value ? 'dark' : 'light',
                              () async {
                                context.setTheme = (value
                                    ? ThemeMode.light
                                    : ThemeMode.dark);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    if (instance<AppPreferences>().isUserRegistered)
                      SettingItem(
                        title: Translation.live_activity.tr,
                        svg: SvgM.usage,
                        suffix: CustomSwitch(
                          width: 44.w,
                          height: 22.w,
                          thumbSizeRatio: .8,
                          value: state.isLiveActivityEnabled,
                          inactiveTrackColor: Colors.black.withValues(
                            alpha: .1,
                          ),
                          activeTrackColor: ColorM.primary.withValues(
                            alpha: .7,
                          ),
                          trackBorderRadius: BorderRadius.circular(9999),
                          onChanged: (value) {
                            context.read<HomeBloc>().add(
                              ShowHideNotificationEvent(),
                            );
                          },
                        ),
                      ),
                  ],
                ),
                14.verticalSpace,

                SettingsGroupItems(
                  title: Translation.support.tr,
                  items: [
                    // Dynamic pages from API
                    ...state.pages.where((page) => page.isActive).map((page) {
                      return SettingItem(
                        title: page.title(context.locale),
                        svg: SvgM.shieldTick,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RoutesManager.legalAndPolices.route,
                            arguments: {'pageId': page.id},
                          );
                        },
                      );
                    }).toList(),
                    SettingItem(
                      title: Translation.rate_hi_net.tr,
                      svg: SvgM.stars,
                      gradientTitleAndSvg: true,
                      onTap: () async {
                        await AppRateServices.instance.openStoreListing();
                      },
                    ),
                    SettingItem(
                      title: Translation.help_and_support.tr,
                      svg: SvgM.messageQuestion,
                      onTap: () async {
                        await launchUrl(
                          Uri.parse(
                            'https://wa.me/${APP_SETTINGS.instance.whatsappSupportNumber}',
                          ),
                          mode: LaunchMode.externalApplication,
                        );
                        // Navigator.pushNamed(
                        //   context,
                        //   RoutesManager.helpAndSupport.route,
                        // );
                      },
                    ),
                    // SettingItem(
                    //   title: Translation.esim_supported_devices.tr,
                    //   svg: SvgM.mobile,
                    //   onTap: () {},
                    // ),
                  ],
                ),
                14.verticalSpace,
                if (!instance<AppPreferences>().isUserRegistered)
                  PleaseSignInButton(noLable: true),

                14.verticalSpace,
                AppVersion(version: state.appVersion),
              ],
            ),
          ),
        ),
      ).animatedOnAppear(1, SlideDirection.up),
    );
  }

  bool isDark = false;
}

class LanguageButton extends StatelessWidget {
  const LanguageButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.isSelected,
  });

  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return CustomInkButton(
      onTap: onTap,
      backgroundColor: isSelected
          ? context.isDark
                ? Colors.white
                : Colors.white.withValues(alpha: .05)
          : Colors.transparent,
      borderRadius: 9999,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
      child: Text(
        title,
        style: context.labelSmall.copyWith(
          fontSize: 10.sp,
          height: 1,
          color: isSelected
              ? ColorM.primary
              : context.colorScheme.surface.withValues(alpha: .5),
        ),
      ),
    );
  }
}

class AppVersion extends StatelessWidget {
  const AppVersion({super.key, required this.version});

  final String version;

  @override
  Widget build(BuildContext context) {
    return Text(
      version,
      style: context.labelLarge.copyWith(
        color: context.colorScheme.surface.withValues(alpha: .5),
      ),
    );
  }
}
