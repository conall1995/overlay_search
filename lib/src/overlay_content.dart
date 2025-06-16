
import 'package:flutter/material.dart';

import 'overlay_search_controller.dart';

class OverlayContent<T> extends StatelessWidget {
  const OverlayContent({
    super.key,
    required this.stocksTop,
    required this.controller,
    this.titleStyle,
    this.contentStyle,
    this.backgroundColor,
    this.maxOverlayHeight,
    required this.onItemSelected,
    this.notFoundText,
    this.notFoundWidgetBuilder,
    this.notFoundTextStyle,
    required this.itemBuilder,
    this.loadingWidget
  });

  final List<T>? stocksTop;
  final OverlaySearchController controller;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final Color? backgroundColor;
  final double? maxOverlayHeight;
  final Function(T item) onItemSelected;
  final String? notFoundText;
  final Widget? Function()? notFoundWidgetBuilder;
  final TextStyle? notFoundTextStyle;
  final Widget Function(T value) itemBuilder;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final value = controller.itemList;
        final size = MediaQuery.of(context).size;
        final double calculatedHeight = ((value?.length??1) * 55 + 20);
        final double maxHeight = maxOverlayHeight ?? size.height * .2;
        return AnimatedContainer(
          constraints: BoxConstraints(
            maxHeight: value?.isEmpty??true
                ? 75
                : (calculatedHeight > maxHeight ? maxHeight : calculatedHeight),
          ),
          duration: const Duration(milliseconds: 200),
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: backgroundColor,
            child: controller.isLoading
                ? Center(child: loadingWidget?? const CircularProgressIndicator())
                : value?.isNotEmpty??true
                    ? ListView.separated(
              separatorBuilder: (context, index) => Divider(color: Color(0xfff5f5f5),),
                        padding: EdgeInsets.zero,
                        itemCount: value?.length??0,
                        itemBuilder: (context, index) {
                          return InkWell(child: itemBuilder.call(value?[index]),onTap: () => onItemSelected.call(value?[index]),);
                        },
                      )
                    : notFoundWidgetBuilder!=null?notFoundWidgetBuilder?.call(): Center(
                        child: Text(
                          notFoundText ?? "No Results Found",
                          style: notFoundTextStyle,
                        ),
                      ),
          ),
        );
      },
    );
  }
}
