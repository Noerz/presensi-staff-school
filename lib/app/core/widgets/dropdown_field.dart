import 'package:flutter/material.dart';

class DropdownField extends StatelessWidget {
  final String hintText;
  final List<DropdownMenuItem<String>> items;
  final Function(String?) onChanged;

  const DropdownField({
    Key? key,
    required this.hintText,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}
