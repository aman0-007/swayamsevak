import 'package:flutter/material.dart';

class NssBatchDropdown extends StatefulWidget {
  final String selectedBatch;
  final ValueChanged<String?> onBatchChanged;

  const NssBatchDropdown({
    Key? key,
    required this.selectedBatch,
    required this.onBatchChanged,
  }) : super(key: key);

  @override
  State<NssBatchDropdown> createState() => _NssBatchDropdownState();
}

class _NssBatchDropdownState extends State<NssBatchDropdown> {
  late List<String> nssBatches;

  @override
  void initState() {
    super.initState();
    _updateNssBatches();
  }

  void _updateNssBatches() {
    final currentYearInt = DateTime.now().year;

    final previousYear = currentYearInt - 1;
    final nextYear = currentYearInt + 1;
    final nextToNextYear = currentYearInt + 2;

    setState(() {
      nssBatches = [
        "$previousYear-$currentYearInt",
        "$currentYearInt-$nextYear",
        "$nextYear-$nextToNextYear"
      ];
    });

    // Ensure the selectedBatch is valid
    if (!nssBatches.contains(widget.selectedBatch)) {
      widget.onBatchChanged(nssBatches.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.selectedBatch,
      items: nssBatches.map((batch) {
        return DropdownMenuItem<String>(
          value: batch,
          child: Text(batch),
        );
      }).toList(),
      onChanged: widget.onBatchChanged,
      decoration: const InputDecoration(
        labelText: "Current NSS Batch",
        border: OutlineInputBorder(),
      ),
    );
  }
}
