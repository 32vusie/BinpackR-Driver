class QRData {
  final String wasteType;
  final double weight;
  final String imageUrl;

  QRData({
    required this.wasteType,
    required this.weight,
    required this.imageUrl,
  });

  // Create a QRData from JSON data
  factory QRData.fromJson(Map<String, dynamic> json) => QRData(
        wasteType: json['wasteType'],
        weight: json['weight'].toDouble(),
        imageUrl: json['imageUrl'],
  );

  // Convert a QRData to a Map
  Map<String, dynamic> toJson() => {
        'wasteType': wasteType,
        'weight': weight,
        'imageUrl': imageUrl,
  };
}
