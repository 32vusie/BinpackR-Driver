import 'package:flutter/material.dart';
import 'package:binpack_residents/utils/enums.dart';

class WasteTypeDropdown extends StatefulWidget {
  final WasteType? selectedWasteType;
  final ValueChanged<WasteType?>? onChanged;
  final bool
      isPaidRequest; // Flag to differentiate between normal and paid requests

  const WasteTypeDropdown({
    super.key,
    required this.selectedWasteType,
    required this.onChanged,
    required this.isPaidRequest,
  });

  @override
  _WasteTypeDropdownState createState() => _WasteTypeDropdownState();
}

class _WasteTypeDropdownState extends State<WasteTypeDropdown> {
  String? selectedCategory;
  WasteType? selectedWasteType;
  Map<String, List<DropdownMenuItem<WasteType>>> categorizedWasteTypes = {};

  @override
  void initState() {
    super.initState();
    _loadWasteTypes();
  }

  Future<void> _loadWasteTypes() async {
    // Filter waste types based on whether it's a paid or normal request
    final wasteItems = WasteType.values
        .where((wasteType) => widget.isPaidRequest
            ? _isDisposalWaste(wasteType)
            : _isRecyclableWaste(wasteType))
        .map((type) => DropdownMenuItem<WasteType>(
              value: type,
              child: Text(type.displayName),
            ))
        .toList();

    final categorized = <String, List<DropdownMenuItem<WasteType>>>{};

    for (var item in wasteItems) {
      final category = _getWasteCategory(item.value!);
      categorized.putIfAbsent(category, () => []).add(item);
    }

    setState(() {
      categorizedWasteTypes = categorized;
    });
  }

  bool _isRecyclableWaste(WasteType wasteType) {
    return [
      WasteType.recyclablePaper,
      WasteType.recyclableCardboard,
      WasteType.recyclablePlastic,
      WasteType.recyclableGlass,
      WasteType.recyclableMetal,
      WasteType.recyclableTextiles,
    ].contains(wasteType);
  }

  bool _isDisposalWaste(WasteType wasteType) {
    return [
      WasteType.nonRecyclablePlastic,
      WasteType.nonRecyclableGlass,
      WasteType.nonRecyclableMetal,
      WasteType.nonRecyclableTextiles,
      WasteType.hazardousBatteries,
      WasteType.hazardousChemicals,
      WasteType.medicalWaste,
      WasteType.automotiveWaste,
      WasteType.constructionAndDemolitionWaste,
    ].contains(wasteType);
  }

  String _getWasteCategory(WasteType wasteType) {
    switch (wasteType) {
      case WasteType.recyclablePaper:
      case WasteType.recyclableCardboard:
      case WasteType.recyclablePlastic:
      case WasteType.recyclableGlass:
      case WasteType.recyclableMetal:
      case WasteType.recyclableTextiles:
        return 'Recyclable';
      case WasteType.nonRecyclablePlastic:
      case WasteType.nonRecyclableGlass:
      case WasteType.nonRecyclableMetal:
      case WasteType.nonRecyclableTextiles:
        return 'Non-Recyclable';
      case WasteType.hazardousBatteries:
      case WasteType.hazardousChemicals:
      case WasteType.medicalWaste:
      case WasteType.automotiveWaste:
        return 'Hazardous';
      case WasteType.constructionAndDemolitionWaste:
        return 'Construction';
      default:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: selectedCategory,
          onChanged: (category) {
            setState(() {
              selectedCategory = category;
              selectedWasteType = null;
            });
            if (widget.onChanged != null) widget.onChanged!(null);
          },
          items: categorizedWasteTypes.keys.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: 'Waste Category',
            prefixIcon: const Icon(Icons.category),
            filled: true,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 8, 116, 13)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 8, 116, 13)),
            ),
          ),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
            size: 24,
          ),
          validator: (value) {
            if (value == null) {
              return 'Please select a waste category';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        if (selectedCategory != null)
          DropdownButtonFormField<WasteType>(
            value: selectedWasteType,
            onChanged: (wasteType) {
              setState(() {
                selectedWasteType = wasteType;
              });
              if (widget.onChanged != null) widget.onChanged!(wasteType);
            },
            items: categorizedWasteTypes[selectedCategory] ?? [],
            decoration: InputDecoration(
              labelText: 'Waste Type',
              prefixIcon: const Icon(Icons.recycling_rounded),
              filled: true,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color.fromARGB(255, 8, 116, 13)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color.fromARGB(255, 8, 116, 13)),
              ),
            ),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
              size: 24,
            ),
            validator: (value) {
              if (value == null) {
                return 'Please select a waste type';
              }
              return null;
            },
          ),
      ],
    );
  }
}
