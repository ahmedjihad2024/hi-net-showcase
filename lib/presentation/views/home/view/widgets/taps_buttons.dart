import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/presentation/common/utils/state_render.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/views/home/bloc/home_bloc.dart';
import 'package:hi_net/presentation/views/home/view/widgets/tap_button.dart';

class TapsButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeState state = context.read<HomeBloc>().state;

    return Row(
      spacing: 10.w,
      children: [
        TapButton(
          title: Translation.countries.tr,
          isSelected: state.selectedDestinationTap.isCountry,
          onTap: () {
            context.read<HomeBloc>().add(
              SelectDestinationTapEvent(DestinationTap.country),
            );
          },
        ),
        TapButton(
          title: Translation.regional.tr,
          isSelected: state.selectedDestinationTap.isRegion,
          onTap: () {
            context.read<HomeBloc>().add(
              SelectDestinationTapEvent(DestinationTap.region),
            );
          },
        ),
        TapButton(
          title: Translation.global.tr,
          isSelected: state.selectedDestinationTap.isGlobal,
          onTap: () {
            context.read<HomeBloc>().add(
              SelectDestinationTapEvent(DestinationTap.global),
            );
          },
        ),
      ],
    );
  }
}
