
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatelessWidget {
  final String selectedCategory;
  final List<String> categories;

  const FilterBottomSheet({
    super.key,
    required this.selectedCategory,
    required this.categories,
  });

  static Future<String?> show(
    BuildContext context, {
    required String selectedCategory,
    required List<String> categories,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return FilterBottomSheet(
          selectedCategory: selectedCategory,
          categories: categories,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Kategori Seminar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Pilih kategori acara yang ingin ditampilkan.'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (_) {
                    Navigator.pop(context, category);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, 'Semua');
                },
                child: const Text('Reset Filter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
