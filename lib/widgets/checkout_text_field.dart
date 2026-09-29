import 'package:flutter/material.dart';

const _brown = Color(0xFF654039);
const _hint = Color(0xFF8B6B61);

InputDecoration _decoration({
  String? hint,
  String? label,
  double radius = 8,
  Color borderColor = _brown,
  Color? fillColor,
  double hintSize = 11,
}) {
  OutlineInputBorder border(double width) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: BorderSide(color: borderColor, width: width),
  );

  return InputDecoration(
    isDense: true,
    filled: fillColor != null,
    fillColor: fillColor,
    counterText: '',
    hintText: hint,
    hintStyle: TextStyle(fontSize: hintSize, color: _hint),
    labelText: label,
    labelStyle: const TextStyle(fontSize: 11, color: _hint),
    floatingLabelBehavior:
    label != null ? FloatingLabelBehavior.always : FloatingLabelBehavior.auto,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 12,
      vertical: label == null ? 13 : 10,
    ),
    enabledBorder: border(1),
    focusedBorder: border(1.5),
  );
}

class CheckoutTextField extends StatelessWidget {
  final String hintText;
  final double radius;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Color borderColor;
  final Color? fillColor;
  final double hintFontSize;
  final int? maxLength;

  const CheckoutTextField({
    super.key,
    required this.hintText,
    this.radius = 8,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.borderColor = _brown,
    this.fillColor,
    this.hintFontSize = 11,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      style: const TextStyle(fontSize: 13, color: Colors.black),
      decoration: _decoration(
        hint: hintText,
        radius: radius,
        borderColor: borderColor,
        fillColor: fillColor,
        hintSize: hintFontSize,
      ),
    );
  }
}

class CheckoutDropdown extends StatelessWidget {
  final String? label;
  final String? hint;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final double radius;

  const CheckoutDropdown({
    super.key,
    this.label,
    this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      isDense: true,
      icon: const Icon(Icons.keyboard_arrow_down, size: 18),
      style: TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontWeight: label != null ? FontWeight.w600 : FontWeight.w400,
      ),
      decoration: _decoration(hint: hint, label: label, radius: radius),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }
}