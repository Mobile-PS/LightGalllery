import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/const_color.dart';


class CustomField extends StatelessWidget {
  final Widget? suffixIcon;

  final BorderRadius? borderRadius;
  final bool autofocus;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? contentPadding;
  final void Function()? onTap;
  final String? hintText;
  final String? suffixText;
  final TextStyle? suffixStyle;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Color? fillColor;
  final bool enabled;
  final bool readOnly;
  final TextCapitalization textCapitalization;
  final int maxLine;
  final int? maxLength;
  final Color enableBorderColor;
  final Color? focusedBorderColor;
  final void Function(String)? onChanged;
  final AutovalidateMode? autovalidateMode;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final EdgeInsets scrollPadding;
  final TextStyle? style;
  final String? labelText;
  final String? counterText;
  final String? hintFontFamily;
  final String? labelFontFamily;
  final double? hintFontSize;
  final double? labelFontSize;
  final FontWeight? hintFontWeight;
  final FontWeight? labelFontWeight;
  final Color? hintFontColor;
  final Color? labelFontColor;
  final double? hintFontHeight;
  final double? labelFontHeight;

  const CustomField({
    super.key,
    this.autofocus = false,
    this.borderRadius,
    this.validator,
    this.controller,
    this.contentPadding,
    this.hintText,
    this.suffixIcon,
    this.obscureText = false,
    this.onTap,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.fillColor = fieldFill,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.maxLine = 1,
    this.maxLength,
    this.enableBorderColor = transparent,
    this.focusedBorderColor,
    this.readOnly = false,
    this.onChanged,
    this.autovalidateMode,
    this.textInputAction,
    this.focusNode,
    this.suffixText,
    this.suffixStyle,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.style,
    this.labelText,
    this.counterText,
    this.hintFontFamily,
    this.hintFontSize,
    this.hintFontWeight,
    this.hintFontColor,
    this.hintFontHeight,
    this.labelFontColor,
    this.labelFontFamily,
    this.labelFontSize,
    this.labelFontWeight,
    this.labelFontHeight,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      scrollPadding: scrollPadding,
      focusNode: focusNode,
      textInputAction: textInputAction ?? TextInputAction.next,
      autofocus: autofocus,
      controller: controller,
      readOnly: readOnly,
      minLines: maxLine,
      decoration: InputDecoration(
        labelText: labelText,
        enabled: enabled,
        isCollapsed: true,
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: enableBorderColor, width: 3.0),
          borderRadius: borderRadius ?? BorderRadius.circular(34.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: focusedBorderColor ?? Theme.of(context).primaryColor,
            width: 3.0,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(34.0),
        ),
        errorStyle: const TextStyle(height: 0),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: focusedBorderColor ?? Theme.of(context).colorScheme.error,
            width: 3.0,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(34.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: focusedBorderColor ?? Theme.of(context).colorScheme.error,
              width: 3.0),
          borderRadius: borderRadius ?? BorderRadius.circular(34.0),
        ),
        filled: true,
        fillColor: fillColor,
        hintStyle: TextStyle(
          color: hintFontColor ?? hintTextColor,
         // fontFamily: hintFontFamily ?? Strings.roboto,
          fontSize: hintFontSize ?? 18.sp,
          fontWeight: hintFontWeight ?? FontWeight.w500,
          height: hintFontHeight,
        ),

        labelStyle: TextStyle(
          color: labelFontColor ?? hintTextColor,
        //  fontFamily: labelFontFamily ?? Strings.roboto,
          fontSize: labelFontSize ?? 18.sp,
          fontWeight: labelFontWeight ?? FontWeight.w500,
          height: labelFontHeight,
        ),
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 23.0, vertical: 16.0),
        hintText: hintText,
        errorText: null,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 23.0, left: 8),
                child: suffixIcon,
              )
            : null,
        // suffixIconConstraints:
        //     const BoxConstraints(maxHeight: 16.0, maxWidth: 32.0),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 23.0, right: 8),
                child: prefixIcon,
              )
            : null,
        suffixText: suffixText,
        suffixStyle: suffixStyle,
        counterText: counterText,
      ),
      obscureText: obscureText,
      validator: validator,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      maxLines: maxLine,
      maxLength: maxLength,
      onChanged: onChanged,
      onTap: onTap,
      style: style ??
          TextStyle(
           // fontFamily: Strings.roboto,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            height: 1.1.h,
          ),
      // cursorHeight: 17.0,
    );
  }
}
