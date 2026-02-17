import 'package:flutter/material.dart';

class ComboField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final List<String> options;
  final String hint;
  final String? Function(String?)? validator;

  const ComboField({
    super.key,
    required this.label,
    required this.controller,
    required this.options,
    this.hint = '',
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        isDense: true,
        suffixIcon: _DropSuffix(
          options: options,
          onSelected: (v) => controller.text = v,
        ),
      ),
      validator: validator,
    );
  }
}

class _DropSuffix extends StatelessWidget {
  final List<String> options;
  final ValueChanged<String> onSelected;

  const _DropSuffix({
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return const SizedBox(width: 40);
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        icon: const Icon(Icons.arrow_drop_down),
        items: options
            .map((e) => DropdownMenuItem(
          value: e,
          child: SizedBox(
            width: 220,
            child: Text(
              e,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.rtl,
            ),
          ),
        ))
            .toList(),
        onChanged: (v) {
          if (v == null) return;
          onSelected(v);
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
