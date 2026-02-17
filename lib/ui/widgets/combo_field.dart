import 'package:flutter/material.dart';

class ComboField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final List<String> options;
  final String? Function(String?)? validator;
  final String hint;

  const ComboField({
    super.key,
    required this.label,
    required this.controller,
    required this.options,
    this.validator,
    this.hint = '',
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

  const _DropSuffix({required this.options, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    // DropdownButton داخل suffix: لازم نخفي خطه
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        icon: const Icon(Icons.arrow_drop_down),
        items: options
            .map(
              (e) => DropdownMenuItem(
            value: e,
            child: SizedBox(
              width: 220, // يمنع overflow في القيم الطويلة
              child: Text(
                e,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
        )
            .toList(),
        onChanged: (v) {
          if (v == null) return;
          onSelected(v);
          FocusScope.of(context).unfocus(); // يغلق الكيبورد إن كان مفتوح
        },
      ),
    );
  }
}
