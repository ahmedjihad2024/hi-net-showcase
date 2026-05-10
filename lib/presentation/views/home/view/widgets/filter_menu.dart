import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hi_net/presentation/common/ui_components/custom_popup_menu.dart';

class FilterPopupMenu<T> extends StatelessWidget {
  final Widget child;
  final List<FilterOption> options;
  final ValueNotifier<T>? selectedValue;
  final Function(T)? onFilterSelected;
  final Color backgroundColor;
  final BorderSide side;
  final double borderRadius;

  const   FilterPopupMenu(
      {Key? key,
      required this.child,
      required this.options,
      this.selectedValue,
      this.onFilterSelected,
      this.side = BorderSide.none,
      this.backgroundColor = Colors.white,
      this.borderRadius = 8})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedValue ?? ValueNotifier(null),
        builder: (context, selectedValueVal, _) {
          return CustomPopupMenu<T>(
            child: child,
            backgroundColor: backgroundColor,
            borderRadius: borderRadius,
            constraints: BoxConstraints(),
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 15.w,
            ),
            side: side,
            items: options
                .map((option) => CustomPopupMenuItem.create<T>(
                      value: option.value,
                      label: option.label,
                      isSelected: selectedValueVal == option.value,
                    ))
                .toList(),
            onSelected: onFilterSelected,
          );
        });
  }
}

// Filter option model
class FilterOption<T> {
  final T value;
  final String label;

  const FilterOption({
    required this.value,
    required this.label,
  });
}
