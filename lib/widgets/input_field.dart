import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tto/constant/color.dart';
import 'package:tto/constant/text.dart';

class InputField extends StatelessWidget {
  InputField({
    super.key,
    this.controller,
    this.focusNode,
    this.obsecureText = false,
    this.hintText,
    this.suffixIcon,
    this.enabled = true,
    this.validator,
    this.onSaved,
    this.label,
    this.maxLines,
    this.prefixIcon,
    this.inputFormatter,
    this.keyboardType,
  });

  TextEditingController? controller;
  String? hintText;
  FocusNode? focusNode;
  bool? obsecureText;
  FormFieldSetter<String>? onSaved;
  FormFieldValidator? validator;
  Widget? suffixIcon;
  bool? enabled;
  Widget? label;
  int? maxLines;
  Widget? prefixIcon;
  List<TextInputFormatter>? inputFormatter;
  TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      onSaved: onSaved,
      cursorColor: eerieBlack,
      maxLines: maxLines,
      style: helveticaText,
      inputFormatters: inputFormatter,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        label: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: davysGray,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: davysGray,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: davysGray,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: grayx11,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: orangeAccent,
            width: 1,
          ),
        ),
        errorStyle: const TextStyle(
          color: orangeAccent,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
        fillColor: enabled! ? culturedWhite : platinum,
        filled: true,
        // isDense: true,
        // isCollapsed: true,
        focusColor: culturedWhite,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: sonicSilver,
        ),
        // contentPadding: const EdgeInsets.only(
        //   right: 15,
        //   left: 15,
        //   top: 18,
        //   bottom: 15,
        // ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        suffixIconColor: eerieBlack,
      ),
    );
  }
}
