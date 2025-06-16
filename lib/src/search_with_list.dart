//TODO: ADD ENABLE LAYERLINK

import 'package:flutter/material.dart';
import 'package:overlay_search/src/overlay_content.dart';

import 'package:overlay_search/src/search_text_field.dart';

import 'debounce.dart';
import 'overlay_search_controller.dart';

class SearchWithList<T> extends StatefulWidget {
  const SearchWithList({
    super.key,
    required this.list,
    this.isLoading,
    required this.overlaySearchController,
    this.suffixAction,
    this.onTap,
    this.disableComponentSearch,
    this.onChanged,
    this.enableDebounce,
    this.hint = "Search",
    this.label="Search",
    this.focusedHint,
    this.hintStyle,
    this.showWhenUnlinked,
    this.iconColor,
    this.searchBackgroundColor,
    this.overlayBackgroundColor,
    this.overlayHeight,
    this.overlayWidth,
    this.shiftOverlayFromLeft,
    this.cursorColor,
    this.searchTextStyle,
    this.notFoundText,
    this.notFoundWidgetBuilder,
    this.onItemSelected,
    this.debounceDuration,
    this.notFoundTextStyle,
    required this.itemBuilder,
    this.loadingWidget,
    this.prefixIcon,
  });

  final Widget Function(T value) itemBuilder;
  final List<T>? list;
  final bool? isLoading;
  final OverlaySearchController<T> overlaySearchController;
  final VoidCallback? suffixAction;
  final IconData? prefixIcon;
  final VoidCallback? onTap;
  final bool? disableComponentSearch;
  final Function(String)? onChanged;
  final bool? enableDebounce;
  final String? hint;
  final String? label;
  final String? focusedHint;
  final TextStyle? hintStyle;
  final bool? showWhenUnlinked;
  final TextStyle? searchTextStyle;
  final TextStyle? notFoundTextStyle;
  final Widget? loadingWidget;
  final Color? iconColor;
  final Color? searchBackgroundColor;
  final Color? overlayBackgroundColor;
  final double? overlayHeight;
  final double? overlayWidth;
  final double? shiftOverlayFromLeft;
  final Color? cursorColor;
  final String? notFoundText;
  final Widget Function(String searchText)? notFoundWidgetBuilder;
  final Function(T item)? onItemSelected;
  final Duration? debounceDuration;


  @override
  State<SearchWithList<T>> createState() => _SearchWithListState();
}

class _SearchWithListState<T> extends State<SearchWithList<T>> {
  @override
  void didUpdateWidget(covariant SearchWithList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (oldWidget.isLoading != widget.isLoading && widget.isLoading != null) {
        widget.overlaySearchController.updateLoading(widget.isLoading!);
      }
      widget.overlaySearchController.updateStocks(widget.list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: widget.overlaySearchController.layerLink,
      child: SearchTextField(
        focusNode: widget.overlaySearchController.searchFocusNode,
        controller: widget.overlaySearchController.searchController,
        hint: widget.hint,
        suffixIcon: widget.prefixIcon,
        focusedHint: widget.focusedHint,
        hintStyle: widget.hintStyle,
        label:widget.label,
        backgroundColor: widget.searchBackgroundColor,
        iconColor: widget.iconColor,
        cursorColor: widget.cursorColor,
        style: widget.searchTextStyle,
        onChanged: (value) {
          _onChanged(value);
        },
        suffixAction: (value) {
          widget.suffixAction?.call();
        },
        onTap: _onTap,
      ),
    );
  }
  void show(){
    showOverlay(
      context,
      (widget.list as List?)?.cast<T>(),
    );
  }
  void _onTap() {
    widget.onTap?.call();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.overlaySearchController.entry == null) {
        showOverlay(
          context,
          (widget.list as List?)?.cast<T>(),
        );
      } else {
        widget.overlaySearchController.hideOverlay();
      }
    });
  }

  void _debounceSearch(String value) {
    Debounce debounce =
        Debounce(widget.debounceDuration ?? const Duration(milliseconds: 1000));
    debounce.add(value);
    debounce.call((value) {
      widget.onChanged!.call(value);
    });
  }

  void _onChanged(String value) {
    if (widget.onChanged != null) {
      if (widget.enableDebounce == true) {
        _debounceSearch(value);
      } else {
        widget.onChanged!.call(value);
      }
    }
    if (widget.disableComponentSearch != true) {
      widget.overlaySearchController.updateStocks(widget.list);
    }
  }

  void showOverlay(
    BuildContext context,
    List<T>? stocks,
  ) {
    widget.overlaySearchController.updateStocks(widget.list);
    final overlayState = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    widget.overlaySearchController.entry = OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        width: widget.overlayWidth ?? size.width,
        child: CompositedTransformFollower(
          link: widget.overlaySearchController.layerLink,
          showWhenUnlinked: widget.showWhenUnlinked ?? false,
          offset: Offset(widget.shiftOverlayFromLeft ?? 0, size.height + 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OverlayContent<T>(
              loadingWidget:widget.loadingWidget ,
              stocksTop: widget.overlaySearchController.itemList?.cast<T>(),
              controller: widget.overlaySearchController,
              // itemBuilder:(value) =>  Text(value.toString()),
              itemBuilder: widget.itemBuilder,
              backgroundColor: widget.overlayBackgroundColor,
              maxOverlayHeight: widget.overlayHeight,
              notFoundTextStyle: widget.notFoundTextStyle,
              onItemSelected: (item) {
                widget.onItemSelected?.call(item);
              },
              notFoundText: widget.notFoundText,
              notFoundWidgetBuilder: widget.notFoundWidgetBuilder != null
                  ? () => widget.notFoundWidgetBuilder!(
                        widget.overlaySearchController.searchController.text,
                      )
                  : null,
            ),
          ),
        ),
      ),
    );
    overlayState.insert(widget.overlaySearchController.entry!);
  }
}
