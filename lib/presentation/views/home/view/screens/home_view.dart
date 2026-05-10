import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hi_net/app/dependency_injection.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/app/services/app_preferences.dart';
import 'package:hi_net/domain/model/models.dart';
import 'package:hi_net/presentation/common/ui_components/animations/animations_enum.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/common/utils/after_layout.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/routes_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/views/checkout/view/widgets/rate_dialog.dart';
import 'package:hi_net/presentation/views/esim_details/view/widgets/plain_information_bottom_sheet.dart';
import 'package:hi_net/presentation/views/home/bloc/home_bloc.dart';
import 'package:hi_net/presentation/views/home/view/screens/home_taps/tap_destinations_view.dart';
import 'package:hi_net/presentation/views/home/view/screens/home_taps/tap_home_view.dart';
import 'package:hi_net/presentation/views/home/view/screens/home_taps/tap_my_esim_view.dart';
import 'package:hi_net/presentation/views/home/view/screens/home_taps/tap_profile_view.dart';
import 'package:hi_net/presentation/views/home/view/widgets/bottom_nav_bar.dart';
import 'package:hi_net/presentation/views/splash/screens/view/splash_view.dart';
import 'package:url_launcher/url_launcher.dart';

PlanDetails? LastSelectedPlanDetails;

ValueNotifier<int> BOTTOM_NAV_BAR_SELECTED_TAB = ValueNotifier<int>(0);
CarouselSliderController BOTTOM_NAV_BAR_SLIDER_CONTROLLER =
    CarouselSliderController();

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static HomeBloc? homeBloc;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin, AfterLayout {
  late double bottomNavHeight;
  late double totalBottomNavHeight;

  late List<BottomNavItem> bottomNavItems;

  @override
  void initState() {
    BOTTOM_NAV_BAR_SELECTED_TAB.value = 0;
    BOTTOM_NAV_BAR_SLIDER_CONTROLLER = CarouselSliderController();
    super.initState();
  }

  @override
  void dispose() {
    HomeView.homeBloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        bottomNavItems = [
          BottomNavItem(
            title: Translation.store.tr,
            svgPath: SvgM.home,
            selectedSvgPath: SvgM.home,
          ),
          BottomNavItem(
            title: Translation.destinations.tr,
            svgPath: SvgM.earth3,
            selectedSvgPath: SvgM.earth3,
          ),
          BottomNavItem(
            title: Translation.my_esim.tr,
            svgPath: SvgM.simcard,
            selectedSvgPath: SvgM.simcard,
          ),
          BottomNavItem(
            title: Translation.profile.tr,
            svgPath: SvgM.profile,
            selectedSvgPath: SvgM.profile,
          ),
        ];

        /// Bottom nav bar configration
        // Base dimensions

        bottomNavHeight = 55.h;

        totalBottomNavHeight = bottomNavHeight;

        return Scaffold(
          backgroundColor: context.isDark
              ? context.colorScheme.secondary
              : Color(0xFFF8F8F8),
          body: Stack(
            children: [
              Column(
                children: [
                  // page view
                  Expanded(
                    child: CarouselSlider(
                      items: [
                        TapHomeView(),
                        TapDestinationsView(),
                        TapMyEsimView(),
                        TapProfileView(),
                      ],
                      options: CarouselOptions(
                        viewportFraction: 1,
                        aspectRatio: 1,
                        height: double.infinity,
                        enableInfiniteScroll: false,
                        padEnds: false,
                        animateToClosest: false,
                        onPageChanged: (tapIndex, carouselPageChangedReason) {
                          if (carouselPageChangedReason ==
                              CarouselPageChangedReason.manual) {
                            BOTTOM_NAV_BAR_SELECTED_TAB.value = tapIndex;
                          }
                        },
                      ),
                      carouselController: BOTTOM_NAV_BAR_SLIDER_CONTROLLER,
                    ),
                  ),

                  // bottom navigation bar
                  BottomNavBar(
                    selectedTap: BOTTOM_NAV_BAR_SELECTED_TAB,
                    bottomNavHeight: bottomNavHeight,
                    bottomNavWidth: 0,
                    bottomNavMargin: 0,
                    bottomNavPadding: 0,
                    bottomItemWidth: 0,
                    bottomNavItems: bottomNavItems,
                    spaceBetweenItems: 0,
                    onTap: (tapIndex) {
                      BOTTOM_NAV_BAR_SELECTED_TAB.value = tapIndex;
                      BOTTOM_NAV_BAR_SLIDER_CONTROLLER.animateToPage(
                        tapIndex,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    },
                  ).animatedOnAppear(2, SlideDirection.up),
                ],
              ),

              WhatsappButton(),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> afterLayout(BuildContext context) async {
    HomeView.homeBloc = context.read<HomeBloc>();
    if (LastSelectedPlanDetails != null &&
        instance<AppPreferences>().isUserRegistered) {
      await PlainInformationBottomSheet.show(
        context,
        networkDtoList: LastSelectedPlanDetails!.networkDtoList,
        note: LastSelectedPlanDetails!.note,
        coveredCountries: LastSelectedPlanDetails!.coveredCountries,
        dataAmount: LastSelectedPlanDetails!.dataAmount,
        dataUnit: LastSelectedPlanDetails!.dataUnit,
        days: LastSelectedPlanDetails!.days,
        price: LastSelectedPlanDetails!.price,
        currency: LastSelectedPlanDetails!.currency,
        fupPolicy: LastSelectedPlanDetails!.fupPolicy,
        isRenewable: LastSelectedPlanDetails!.isRenewable,
        isDayPass: LastSelectedPlanDetails!.isDayPass,
        type: LastSelectedPlanDetails!.esimType,
        packageId: LastSelectedPlanDetails!.packageId,
        buttonLabel: LastSelectedPlanDetails!.buttonLabel,
        onButtonTapped: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(
            RoutesManager.checkout.route,
            arguments: {
              'package-id': LastSelectedPlanDetails!.packageId,
              'esim-type': LastSelectedPlanDetails!.esimType,
              'country-code': LastSelectedPlanDetails!.countryCode,
              'region-code': LastSelectedPlanDetails!.regionCode,
            },
          );
        },
      );
      LastSelectedPlanDetails = null;
    }
  }



  
}

class WhatsappButton extends StatefulWidget {
  const WhatsappButton({super.key});

  @override
  State<WhatsappButton> createState() => _WhatsappButtonState();
}

class _WhatsappButtonState extends State<WhatsappButton> {
  double xValue = -1 + ((SizeM.pagePadding.dg * 2) / 1.sw);

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 500),
      alignment: Alignment(xValue, .7),
      curve: Curves.fastLinearToSlowEaseIn,
      child: CustomInkButton(
        width: 44.w,
        height: 44.w,
        borderRadius: 99999,
        backgroundColor: Color(0xFF09973E),
        onTap: () async {
          await launchUrl(
            Uri.parse('https://wa.me/${APP_SETTINGS.instance.whatsappSupportNumber}'),
            mode: LaunchMode.externalApplication,
          );
        },
        alignment: Alignment.center,
        child: SvgPicture.asset(SvgM.whatsapp, width: 24.w, height: 24.w),
      ),
    );
  }
}
