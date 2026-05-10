import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hi_net/app/dependency_injection.dart';
import 'package:hi_net/app/enums.dart';
import 'package:hi_net/app/extensions.dart';
import 'package:hi_net/app/services/app_preferences.dart';
import 'package:hi_net/domain/model/models.dart';
import 'package:hi_net/presentation/common/ui_components/circular_progress_indicator.dart';
import 'package:hi_net/presentation/common/ui_components/custom_form_field/simple_form.dart';
import 'package:hi_net/presentation/common/ui_components/custom_ink_button.dart';
import 'package:hi_net/presentation/common/ui_components/error_widget.dart';
import 'package:hi_net/presentation/common/utils/after_layout.dart';
import 'package:hi_net/presentation/common/utils/state_render.dart';
import 'package:hi_net/presentation/res/assets_manager.dart';
import 'package:hi_net/presentation/res/color_manager.dart';
import 'package:hi_net/presentation/res/fonts_manager.dart';
import 'package:hi_net/presentation/res/routes_manager.dart';
import 'package:hi_net/presentation/res/sizes_manager.dart';
import 'package:hi_net/presentation/res/translations_manager.dart';
import 'package:hi_net/presentation/views/esim_details/view/widgets/plain_information_bottom_sheet.dart';
import 'package:hi_net/presentation/views/home/view/screens/home_view.dart';
import 'package:hi_net/presentation/views/home/view/widgets/country_item.dart';
import 'package:hi_net/presentation/views/home/view/widgets/destinations_list.dart';
import 'package:hi_net/presentation/views/home/view/widgets/global_item.dart';
import 'package:hi_net/presentation/views/home/view/widgets/regional_item.dart';
import 'package:hi_net/presentation/views/home/view/widgets/search_field.dart';
import 'package:hi_net/presentation/views/home/view/widgets/tap_button.dart';
import 'package:hi_net/presentation/views/home/view/widgets/taps_buttons.dart';
import '../../../bloc/home_bloc.dart';
import '../../../../../common/ui_components/gradient_border_side.dart' as s;

class TapDestinationsView extends StatefulWidget {
  const TapDestinationsView({super.key});

  @override
  State<TapDestinationsView> createState() => _TapDestinationsViewState();
}

class _TapDestinationsViewState extends State<TapDestinationsView>
    with AutomaticKeepAliveClientMixin, AfterLayout {
  HomeState get state => context.read<HomeBloc>().state;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (20 +
                    (View.of(context).viewPadding.top /
                        View.of(context).devicePixelRatio))
                .verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
              child: Row(
                children: [
                  Text(
                    Translation.destinations.tr,
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeightM.semiBold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ScreenState.setState(
                reqState: state.destinationsReqState,
                loading: () {
                  return MyCircularProgressIndicator();
                },
                error: () {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeM.pagePadding.dg,
                    ),
                    child: MyErrorWidget(
                      errorType: state.destinationsErrorType,
                      onRetry: () {
                        context.read<HomeBloc>().add(GetDestinationsEvent());
                      },
                      titleMessage: state.destinationsErrorMessage,
                    ),
                  );
                },
                empty: () {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeM.pagePadding.dg,
                    ),
                    child: MyErrorWidget(
                      errorType: ErrorType.noResults,
                      onRetry: () {
                        context.read<HomeBloc>().add(GetDestinationsEvent());
                      },
                      titleMessage: "",
                    ),
                  );
                },
                online: () {
                  return Column(
                    children: [
                      10.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeM.pagePadding.dg,
                        ),
                        child: SearchField(
                          searchController: searchController,
                          onChange: (value) {
                            context.read<HomeBloc>().add(
                              FilterDestinationsEvent(
                                value,
                                state.selectedDestinationTap,
                              ),
                            );
                          },
                        ),
                      ),
                      if (!state.isFilterApplied) ...[
                        10.verticalSpace,
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeM.pagePadding.dg,
                          ),
                          child: TapsButtons(),
                        ),
                      ],
                      10.verticalSpace,
                      Expanded(child: DestinationsList()),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> afterLayout(BuildContext context) async {
    if (!state.globalReqState.isSuccess) {
      context.read<HomeBloc>().add(GetGlobalPlansEvent());
    }
    context.read<HomeBloc>().add(GetDestinationsEvent());
  }
}
