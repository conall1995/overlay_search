import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({
    super.key,
    this.hint,
    this.hintStyle,
    this.foregroundColor,
    this.backgroundColor,
    this.suffixAction,
    this.onChanged,
    this.searchKey,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.prefixAction,
    this.isAnimatedSuffix = true,
    required this.focusNode,
    this.onTap,
    this.iconColor,
    this.style,
    this.cursorColor,
    this.focusedHint,
    this.label,
  });
  final String? hint;
  final String? label;
  final TextStyle? hintStyle;
  final String? focusedHint;

  final TextStyle? style;
  final Color? cursorColor;

  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? iconColor;
  final Function(String)? onChanged;
  final Function(String)? suffixAction;
  final Function(String)? prefixAction;
  final FocusNode focusNode;

  final GlobalKey? searchKey;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final bool isAnimatedSuffix;
  final VoidCallback? onTap;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;
  late final TextEditingController _internalController;
  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    _effectiveController.addListener(() {
      setState(() {});
    });
    widget.focusNode.addListener(() {
      setState(() {});
    });

  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    widget.focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: TextFormField(
        focusNode: widget.focusNode,
        decoration: _inputDecoration,
        key: widget.searchKey,

        onTap: () {
          widget.onTap?.call();
          setState(() {});
        },
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        controller: _effectiveController,
        style: widget.style,
        onChanged: (value) {
          widget.onChanged?.call(value);
        },
        cursorColor: widget.cursorColor,
      ),
    );
  }

  InputDecoration get _inputDecoration => InputDecoration(
        hintText: widget.focusNode.hasFocus ? widget.focusedHint : widget.hint,
        hintStyle: widget.hintStyle,
        labelText: widget.label,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        prefixIcon: IconButton(
          icon: Icon(
            widget.prefixIcon,
          ),
          color: widget.iconColor,
          onPressed: () {
            widget.suffixAction?.call(_effectiveController.text.trim());
          },
        ),
        suffixIcon: widget.isAnimatedSuffix
            ? AnimatedOpacity(
                opacity: _effectiveController.text.isEmpty ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 400),
                child: IconButton(
                  onPressed: () {
                    widget.suffixAction?.call(_effectiveController.text.trim());
                    _effectiveController.clear();
                    FocusScope.of(context).unfocus();
                  },
                  icon: Icon(
                    widget.suffixIcon ?? Icons.close,
                    color: widget.iconColor,
                  ),
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                ),
              )
            : IconButton(
                onPressed: () {
                  widget.suffixAction?.call(_effectiveController.text.trim());
                  _effectiveController.clear();
                  FocusScope.of(context).unfocus();
                },
                color: widget.iconColor,
                icon: Icon(
                  widget.suffixIcon,
                  color: widget.iconColor,
                ),
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          //  horizontal: 20,
          horizontal: 0,
          vertical: 0,
        ),
        filled: true,
        fillColor: widget.backgroundColor?.withOpacity(0.15),
      );
}
