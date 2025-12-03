class WasteType {
  final String id;
  final String name;
  final String grouping;
  final double pricePerKilo;
  final String currency;
  final bool isRecyclable;

  WasteType({
    required this.id,
    required this.name,
    required this.grouping,
    required this.pricePerKilo,
    required this.currency,
    required this.isRecyclable,
  });
}