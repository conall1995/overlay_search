import 'package:flutter/material.dart';

class OverlaySearchController<T> extends ChangeNotifier {
  OverlayEntry? entry;
  final FocusNode searchFocusNode = FocusNode();
  final LayerLink layerLink = LayerLink();
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  List<T>? itemList = <T>[];

  void hideOverlay() {
    entry?.remove();
    entry = null;
    searchFocusNode.unfocus();
  }
  // void show(BuildContext context) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     updateStocks(itemList);
  //     final overlayState = Overlay.of(context);
  //     final renderBox = context.findRenderObject() as RenderBox;
  //     final size = renderBox.size;
  //     entry = OverlayEntry(
  //       maintainState: true,
  //       builder: (context) => Positioned(
  //         width:  size.width,
  //         child: CompositedTransformFollower(
  //           link: layerLink,
  //           // showWhenUnlinked: showWhenUnlinked ?? false,
  //           offset: Offset( 0, size.height + 8),
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 16),
  //             child: OverlayContent<T>(
  //               // loadingWidget:widget.loadingWidget ,
  //               stocksTop: itemList?.cast<T>(),
  //               controller: this, onItemSelected: (T item) {  }, itemBuilder: (T value) =>SizedBox(),
  //               // itemBuilder:(value) =>  Text(value.toString()),
  //               // itemBuilder: widget.itemBuilder,
  //               // backgroundColor: widget.overlayBackgroundColor,
  //               // maxOverlayHeight: widget.overlayHeight,
  //               // notFoundTextStyle: widget.notFoundTextStyle,
  //               // onItemSelected: (item) {
  //               //   widget.onItemSelected?.call(item);
  //               // },
  //               // notFoundText: widget.notFoundText,
  //               // notFoundWidgetBuilder: widget.notFoundWidgetBuilder != null
  //               //     ? () => widget.notFoundWidgetBuilder!(
  //               //   widget.overlaySearchController.searchController.text,
  //               // )
  //               //     : null,
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //     overlayState.insert(entry!);
  //   });
  //
  // }

  void clearSearchQuery() {
    searchController.clear();
    itemList=null;
    notifyListeners();

  }

  void updateStocks(List<T>? stocks, {String? searchKey}) {
    itemList =stocks;
    notifyListeners();
  }

  void updateLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

}
