import 'package:flutter/material.dart';

class SearchCourseField extends StatelessWidget {
  const SearchCourseField({super.key, required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Caută un curs',
    textField: true,
    child: TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Find Course',
        hintStyle: const TextStyle(color: Color(0xFFACAFC8)),
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: IconButton(onPressed: () {}, tooltip: 'Filtre', icon: const Icon(Icons.tune_rounded)),
        filled: true,
        fillColor: const Color(0xFFF0F0FA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    ),
  );
}
