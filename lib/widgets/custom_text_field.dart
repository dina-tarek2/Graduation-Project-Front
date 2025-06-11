import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/constants/colors.dart';

class CustomFormTextField extends StatelessWidget {
  const CustomFormTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.icon,
    this.suffixIcon,
    this.suffixIconOnPressed,
    this.labelText,
    this.minLines,
    this.maxLines,
    this.prefixIcon,
    this.validator,
    this.width,
    this.height,
    this.onSubmitted,
    this.readOnly = false,
    this.isMultiline = false,
    this.decoration = const InputDecoration(),
  }) : super(key: key);

  final TextEditingController? controller;
  final String? hintText;
  final IconData? icon;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? suffixIconOnPressed;
  final String? labelText;
  final int? minLines;
  final int? maxLines;
  final FormFieldValidator<String>? validator;
  final double? width;
  final double? height;
  final ValueChanged<String>? onSubmitted;
  final bool readOnly;
  final bool isMultiline;
  final InputDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SizedBox(
        width: width,
        height: height,
        child: TextFormField(
          readOnly: readOnly,
          obscureText: obscureText,
          validator: validator,
          onFieldSubmitted: onSubmitted,
          controller: controller,
          minLines: isMultiline ? (minLines ?? 3) : (readOnly ? 1 : minLines),
          maxLines:
              isMultiline ? (maxLines ?? 5) : (readOnly ? 1 : (maxLines ?? 1)),
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            labelStyle: TextStyle(
              color: readOnly ? Colors.black54 : Colors.black87,
            ),
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: readOnly ? Colors.grey.shade400 : Colors.grey,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: readOnly ? Colors.grey.shade400 : Colors.grey,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            prefixIcon: prefixIcon ??
                (icon != null ? Icon(icon, size: 16, color: sky) : null),
            suffixIcon: suffixIcon ??
                (suffixIconOnPressed != null
                    ? IconButton(
                        onPressed: suffixIconOnPressed,
                        icon: const Icon(Icons.visibility, color: Colors.blue),
                      )
                    : null),
            filled: true,
            fillColor: readOnly ? const Color(0xFFF4F4F4) : Colors.white,
            iconColor: Colors.white,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ),
      ),
    );
  }
}
