import 'package:flutter/material.dart';

import 'custom_button.dart';

const filterCategories = [
  ('Hair Essentials', 85),
  ('Hair Tools', 30),
  ('Bundles & Extensions', 35),
  ('Care & Maintenance', 30),
  ('Accessories', 25),
  ('Wigs', 15),
];

Future<Set<String>?> showFilterSheet(
    BuildContext context, {
      required Set<String> selected,
      required int totalResults,
    }) {
  return showModalBottomSheet<Set<String>>(
    context: context,
    backgroundColor: const Color(0xFFF8EEE6),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _FilterSheet(
      initial: selected,
      totalResults: totalResults,
    ),
  );
}

class _FilterSheet extends StatefulWidget {
  final Set<String> initial;
  final int totalResults;

  const _FilterSheet({required this.initial, required this.totalResults});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late final Set<String> _selected = {...widget.initial};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context, widget.initial),
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'Category',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            for (final (name, count) in filterCategories)
              InkWell(
                onTap: () => setState(() {
                  _selected.contains(name)
                      ? _selected.remove(name)
                      : _selected.add(name);
                }),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Checkbox(
                          value: _selected.contains(name),
                          onChanged: (_) => setState(() {
                            _selected.contains(name)
                                ? _selected.remove(name)
                                : _selected.add(name);
                          }),
                          activeColor: const Color(0xFF654039),
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(name, style: const TextStyle(fontSize: 13)),
                      ),
                      Text(
                        '$count',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(_selected.clear),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF654039),
                      side: const BorderSide(color: Color(0xFF654039)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Clear'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, _selected),
                    child: AbsorbPointer(
                      child: CustomButton(
                        onPressed: (){},
                        text: 'Show ${widget.totalResults} results',
                        color: const Color(0xFF654039),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}