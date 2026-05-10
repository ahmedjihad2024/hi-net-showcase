import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/data/responses/responses.dart';
import 'package:hi_net/presentation/common/ui_components/custom_cached_image.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/views/esim_details/view/screens/esim_details_view.dart';
import 'package:hi_net/presentation/views/esim_details/view/widgets/covered_countries_bottom_sheet.dart';
import 'package:hi_net/presentation/views/esim_details/view/widgets/networks_bottom_sheet.dart';
import 'package:hi_net/presentation/views/esim_details/view/widgets/plan_item.dart';
import 'package:hi_net/presentation/views/esim_details/view/widgets/text_info_buttom_sheet.dart';
import 'package:smooth_corner/smooth_corner.dart';

import '../../../../common/ui_components/gradient_border_side.dart'
    as gradient_border_side;

class PlainInformationBottomSheet extends StatefulWidget {
  const PlainInformationBottomSheet({
    super.key,
    required this.coveredCountries,
    this.dataAmount,
    this.dataUnit,
    required this.days,
    required this.price,
    required this.currency,
    required this.isRenewable,
    required this.isDayPass,
    required this.type,
    required this.packageId,
    required this.onButtonTapped,
    required this.buttonLabel,
    this.note,
    this.fupPolicy,
    required this.networkDtoList,
    this.isUnlimited = false,
  });

  final List<CoveredCountry> coveredCountries;
  final double? dataAmount;
  final DataUnit? dataUnit;
  final int days;
  final double price;
  final Currency currency;
  final bool? isRenewable;
  final bool isUnlimited;
  final bool isDayPass;
  final EsimsType type;
  final String packageId;
  final String buttonLabel;
  final Function() onButtonTapped;
  final String? note;
  final String? fupPolicy;
  final List<NetworkDto> networkDtoList;

  @override
  State<PlainInformationBottomSheet> createState() =>
      _PlainInformationBottomSheetState();

  static Future<void> show(
    BuildContext context, {
    required List<CoveredCountry> coveredCountries,
    double? dataAmount,
    DataUnit? dataUnit,
    required int days,
    required double price,
    required Currency currency,
    bool? isRenewable,
    required bool isDayPass,
    required EsimsType type,
    required String packageId,
    required String buttonLabel,
    required Function() onButtonTapped,
    required List<NetworkDto> networkDtoList,
    String? note,
    String? fupPolicy,
    bool isUnlimited = false,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => PlainInformationBottomSheet(
        coveredCountries: coveredCountries,
        dataAmount: dataAmount,
        dataUnit: dataUnit,
        days: days,
        price: price,
        currency: currency,
        isRenewable: isRenewable,
        isDayPass: isDayPass,
        type: type,
        packageId: packageId,
        buttonLabel: buttonLabel,
        onButtonTapped: onButtonTapped,
        note: note,
        fupPolicy: fupPolicy,
        networkDtoList: networkDtoList,
        isUnlimited: isUnlimited,
      ),
    );
  }
}

class _PlainInformationBottomSheetState
    extends State<PlainInformationBottomSheet> {
  List<CoveredCountry> _supportedCountries = [];
  @override
  void initState() {
    super.initState();
    _supportedCountries = widget.coveredCountries.sublist(
      0,
      widget.coveredCountries.length > 8 ? 8 : widget.coveredCountries.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 20.w,
        bottom:
            (View.of(context).padding.bottom /
                View.of(context).devicePixelRatio) +
            SizeM.pagePadding.dg,
      ),
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
          smoothness: 1,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        color: context.colorScheme.secondary,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80.w,
            height: 5.w,
            decoration: BoxDecoration(
              color: context.colorScheme.surface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(100000),
            ),
          ),

          12.verticalSpace,

          Text(
            Translation.plans_info.tr,
            style: context.titleLarge.copyWith(fontWeight: FontWeightM.medium),
          ),

          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  16.verticalSpace,
                  if (widget.note != null && widget.note!.trim().isNotEmpty) ...[
                    NoteCard(message: widget.note!),
                    12.verticalSpace,
                  ],
                  // Supported countries
                  if (widget.coveredCountries.isNotEmpty) ...[
                    PlainInfoItem(
                      onTap: () async {
                        await CoveredCountriesBottomSheet.show(
                          context,
                          coveredCountries: widget.coveredCountries,
                        );
                      },
                      title: Translation.supported_countries.tr,
                      widget: SizedBox(
                        height: 24.w,
                        width: ((_supportedCountries.length - 1) * 10.w) + 24.w,
                        child: Stack(
                          children: List.generate(_supportedCountries.length, (
                            index,
                          ) {
                            return PositionedDirectional(
                              start: index * 10.w,
                              child: DecoratedBox(
                                position: DecorationPosition.foreground,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: context.colorScheme.surface
                                        .withValues(alpha: 0.3),
                                    width: 1.w,
                                  ),
                                ),
                                child: CustomCachedImage(
                                  imageUrl: _supportedCountries[index].flag,
                                  width: 24.w,
                                  height: 24.w,
                                  isCircle: true,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    12.verticalSpace,
                  ],

                  if (widget.networkDtoList.isNotEmpty) ...[
                    // Networks
                    PlainInfoItem(
                      onTap: () async {
                        await NetworksBottomSheet.show(
                          context,
                          networks: widget.networkDtoList,
                        );
                      },
                      title: Translation.networks.tr,
                      widget: SizedBox(
                        width: .5.sw,
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(
                            widget.networkDtoList.length == 1
                                ? Translation.one_network.tr
                                : widget.networkDtoList.length == 2
                                ? Translation.two_networks.tr
                                : Translation.networks_count.trNamed({
                                    'count': widget.networkDtoList.length
                                        .toString(),
                                  }),
                          ).mask(false),
                        ),
                      ),
                    ),
                    12.verticalSpace,
                  ],

                  // Flows
                  PlainInfoItem(
                    title: Translation.flows.tr,
                    text: widget.isUnlimited
                        ? Translation.unlimited.tr
                        : switch (widget.dataUnit!) {
                            DataUnit.MB =>
                              '${Translation.mb.trNamed({'mb': widget.dataAmount! % 1 == 0 ? widget.dataAmount!.toInt().toString() : widget.dataAmount.toString()})}',
                            DataUnit.GB =>
                              '${Translation.gb.trNamed({'gb': widget.dataAmount! % 1 == 0 ? widget.dataAmount!.toInt().toString() : widget.dataAmount.toString()})}',
                            DataUnit.TB =>
                              '${Translation.tb.trNamed({'tb': widget.dataAmount! % 1 == 0 ? widget.dataAmount!.toInt().toString() : widget.dataAmount.toString()})}',
                          },
                  ),

                  if (widget.fupPolicy != null) ...[
                    12.verticalSpace,
                    PlainInfoItem(
                      onTap: () {
                        TextInfoBottomSheet.show(
                          context,
                          text: widget.fupPolicy!,
                        );
                      },
                      title: Translation.fup_policy.tr,
                      widget: RotatedBox(
                        quarterTurns:
                            Directionality.of(context) == TextDirection.rtl
                            ? 0
                            : 2,
                        child: SvgPicture.asset(
                          SvgM.arrowLeft,
                          width: 14.w,
                          height: 14.w,
                          colorFilter: ColorFilter.mode(
                            context.colorScheme.surface.withValues(alpha: 0.5),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                  12.verticalSpace,
                  PlainInfoItem(
                    title: Translation.validity.tr,
                    text: switch (widget.days) {
                      1 => Translation.one_day.tr,
                      2 => Translation.two_days.tr,
                      _ => Translation.days.trNamed({
                        'days': widget.days.toString(),
                      }),
                    },
                  ),
                  if (widget.isRenewable != null) ...[
                    12.verticalSpace,
                    PlainInfoItem(
                      title: Translation.renewable_title.tr,
                      info: Translation.renewal_desc.tr,
                      text: widget.isRenewable!
                          ? Translation.yes.tr
                          : Translation.no.tr,
                    ),
                  ],
                  24.verticalSpace,
                ],
              ),
            ),
          ),
          PayButton(
            packageId: widget.packageId,
            type: widget.type,
            price: widget.price,
            currency: widget.currency,
            buttonLabel: widget.buttonLabel,
            onButtonTapped: widget.onButtonTapped,
          ),
        ],
      ),
    );
  }
}

class PayButton extends StatelessWidget {
  final String packageId;
  final EsimsType type;
  final double price;
  final Currency currency;
  final String buttonLabel;
  final Function() onButtonTapped;
  const PayButton({
    super.key,
    required this.packageId,
    required this.type,
    required this.price,
    required this.currency,
    required this.buttonLabel,
    required this.onButtonTapped,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkButton(
      onTap: onButtonTapped,
      gradient: LinearGradient(
        colors: [ColorM.primary, ColorM.secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.dg),
      margin: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      borderRadius: SizeM.commonBorderRadius.r,
      height: 54.h,
      alignment: Alignment.center,
      child: Text(
        Translation.order_completion.tr,
        style: context.labelLarge.copyWith(
          fontWeight: FontWeightM.semiBold,
          height: 1,
          color: Colors.white,
        ),
      ),
    );
  }
}

class PlainInfoItem extends StatelessWidget {
  final String title;
  final Widget? widget;
  final String? text;
  final VoidCallback? onTap;
  final String? info;
  const PlainInfoItem({
    super.key,
    required this.title,
    this.widget,
    this.text,
    this.onTap,
    this.info,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkButton(
      borderRadius: 14.r,
      margin: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      padding: EdgeInsets.symmetric(vertical: 13.w, horizontal: 13.w),
      smoothness: 1,
      side: gradient_border_side.BorderSide(
        color: context.colorScheme.surface.withValues(alpha: 0.1),
        width: 1.w,
      ),
      onTap: onTap,
      child: Tooltip(
        message: info ?? "",
        waitDuration: const Duration(milliseconds: 0),
        showDuration: const Duration(seconds: 4),
        triggerMode: TooltipTriggerMode.tap,
        textStyle: context.labelMedium,
        verticalOffset: -60.w,
        ignorePointer: info == null,
        decoration: BoxDecoration(
          color: context.colorScheme.secondary,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: ColorM.primary.withValues(alpha: 0.2),
            width: 1.w,
          ),
        ),
        constraints: BoxConstraints(maxWidth: .6.sw),
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8.w,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: context.bodyLarge.copyWith(
                        fontWeight: FontWeightM.medium,
                      ),
                    ),
                  ),
                  if (info != null)
                    Icon(
                      Icons.info,
                      size: 16.sp,
                      color: context.colorScheme.surface.withValues(alpha: 0.4),
                    ),
                ],
              ),
            ),
            if (widget != null) widget!,
            if (text != null)
              FittedBox(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  text!,

                  style: context.bodyLarge.copyWith(
                    color: Colors.white,
                    height: 2,
                    fontWeight: FontWeightM.medium,
                  ),
                ),
              ).mask(false),
          ],
        ),
      ),
    );
  }
}
