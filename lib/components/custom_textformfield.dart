import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final MaskTextInputFormatter? maskFormatter;
  final TextEditingController? controller;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType keyboardType;
  final int? minLines;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;

  const CustomFormField({
    Key? key,
    required this.label,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.maskFormatter,
    this.controller,
    this.enabled = true,
    this.validator,
    this.onSaved,
    this.keyboardType = TextInputType.text,
    this.minLines,
    this.maxLines,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      minLines: minLines,
      onSaved: onSaved,
      validator: validator,
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      // inputFormatters: maskFormatter != null ? [maskFormatter!] : [],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: prefix != null
            ? Container(
                alignment: Alignment.center,
                width: 48,
                child: prefix,
              )
            : null,
        suffixIcon: suffix != null
            ? Container(
                alignment: Alignment.center,
                width: 54,
                padding: const EdgeInsets.only(right: 8),
                child: suffix,
              )
            : null,
      ),
      enabled: enabled,
    );
  }
}
