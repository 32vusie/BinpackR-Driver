import 'package:binpack_residents/models/wastetype.dart';
import 'package:flutter/material.dart';
// import 'package:binpack_residents/models/waste_type.dart';

class WasteDropdownWidget extends StatelessWidget {
  final List<WasteType> wasteTypes;
  final WasteType? selectedWasteType;
  final ValueChanged<WasteType?> onChanged;

  const WasteDropdownWidget({
    super.key,
    required this.wasteTypes,
    required this.selectedWasteType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<WasteType>(
      value: selectedWasteType,
      items: wasteTypes.map((wasteType) {
        return DropdownMenuItem(
          value: wasteType,
          child: Text(wasteType.name),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        labelText: 'Select Waste Type',
        border: OutlineInputBorder(),
      ),
    );
  }
}
