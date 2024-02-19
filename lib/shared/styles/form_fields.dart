// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/loginCubit/cubit.dart';
import '../bloc/register_cubit/cubit.dart';
import 'colors.dart';
import 'fonts.dart';

class WeLinkTextFormField extends StatelessWidget {
  WeLinkTextFormField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.focusNode,
    this.label,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
  }) : super(key: key);

  final String hintText;
  String? label;
  String? Function(String?)? validator;
  void Function(String)? onFieldSubmitted;
  void Function(String)? onChanged;
  final TextEditingController controller;
  dynamic keyboardType;
  final FocusNode? focusNode;
  TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black,
      ),
      child: TextFormField(

        textInputAction: textInputAction,
        focusNode: focusNode,
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.montserrat(
          color: WeLinkColors.weLinkWhite,
        ),
        decoration: InputDecoration(
         // label: WeLinkHints(hint: label!),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: WeLinkColors.weLinkRed),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: WeLinkColors.weLinkGrey),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            hintText: hintText,
            hintStyle: GoogleFonts.montserrat(
                color: WeLinkColors.weLinkGrey, fontWeight: FontWeight.w600),
            focusColor: WeLinkColors.weLinkRed,
            contentPadding: const EdgeInsets.all(30)),
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
      ),
    );
  }
}

class WeLinkPassFormField extends StatelessWidget {
  WeLinkPassFormField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.focusNode,
    this.label,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.loginCubit,
    this.registerCubit,
  }) : super(key: key);

  final String hintText;
  String? label;
  String? Function(String?)? validator;
  void Function(String)? onFieldSubmitted;
  void Function(String)? onChanged;
  final TextEditingController controller;
  dynamic keyboardType;
  final FocusNode? focusNode;
  TextInputAction? textInputAction;
  LoginCubit? loginCubit;
  RegisterCubit? registerCubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black,
      ),
      child: TextFormField(
        textInputAction: textInputAction,
        focusNode: focusNode,
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.montserrat(
          color: WeLinkColors.weLinkWhite,
        ),
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WeLinkColors.weLinkRed),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: WeLinkColors.weLinkGrey),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          hintText: hintText,
          hintStyle: WeLinkTextStyles.weLinkHintMontserrat(fs: 17.0),
          contentPadding: const EdgeInsets.all(30),
          suffixIcon: IconButton(
            onPressed: loginCubit != null
                ? loginCubit!.changePasswordVisibility
                : registerCubit!.changePasswordVisibility,
            icon: Icon(
              loginCubit != null ? loginCubit!.visible : registerCubit!.visible,
            ),
          ),
          focusColor: WeLinkColors.weLinkRed,
        ),
        obscureText:
            loginCubit != null ? loginCubit!.isShown : registerCubit!.isShown,
        validator: validator,
        onEditingComplete: () {},
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
      ),
    );
  }
}
