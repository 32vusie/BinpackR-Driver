enum WasteRequestStatus {
  pending,
  assigned,
  inProgress,
  completed,
  canceled,
  rejected,
  collected,
  inRouteToDepot,
  hazardous,
  scheduled,
  scheduled_paid;
}

extension WasteRequestStatusExtension on WasteRequestStatus {
  String get statusString {
    return toString().split('.').last;
  }

  static WasteRequestStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return WasteRequestStatus.pending;
      case 'assigned':
        return WasteRequestStatus.assigned;
      case 'inprogress':
      case 'inProgress':
        return WasteRequestStatus.inProgress;
      case 'completed':
        return WasteRequestStatus.completed;
      case 'canceled':
        return WasteRequestStatus.canceled;
        case 'cancelled':
        return WasteRequestStatus.canceled;
      case 'rejected':
        return WasteRequestStatus.rejected;
      case 'collected':
        return WasteRequestStatus.collected;
      case 'inroutetodepot':
      case 'inRouteToDepot':
        return WasteRequestStatus.inRouteToDepot;
      case 'hazardous':
        return WasteRequestStatus.hazardous;
      case 'scheduled-paid':
        return WasteRequestStatus.scheduled_paid;
      case 'scheduled':
        return WasteRequestStatus.scheduled;
      default:
        throw Exception('Invalid WasteRequestStatus: $status');
    }
  }
}

enum UserType {
  admin,
  resident,
  driver,
}

extension UserTypeExtension on UserType {
  String get displayName {
    switch (this) {
      case UserType.resident:
        return 'Resident';
      case UserType.driver:
        return 'Driver';
      case UserType.admin:
        return 'Admin';
      default:
        return '';
    }
  }
}

// Categorized WasteType Enum
enum WasteType {
  // Municipal and Household Waste
  municipalSolidWaste,
  organicWaste,
  gardenWaste,
  event,
  // Recyclable Materials
  recyclablePaper,
  recyclableCardboard,
  recyclablePlastic,
  recyclableGlass,
  recyclableMetal,
  recyclableTextiles,

  // Non-Recyclable Materials
  nonRecyclablePlastic,
  nonRecyclableGlass,
  nonRecyclableMetal,
  nonRecyclableTextiles,

  // Hazardous Waste
  hazardousBatteries,
  hazardousLightBulbs,
  hazardousChemicals,
  hazardousMedicalWaste,
  hazardousAutomotiveWaste,
  hazardousPaint,
  hazardousSolvents,

  // Electronic Waste (E-Waste)
  ewasteSmallAppliances,
  ewasteMediumAppliances,
  ewasteLargeAppliances,
  ewasteICTEquipment,
  ewasteLighting,
  ewasteToys,
  ewasteTools,

  // Construction and Demolition Waste
  constructionAndDemolitionWaste,

  // Other Waste Types
  furnitureAndAppliances,
  automotiveWaste,
  medicalWaste,
  unknown,
  mixed,
}

extension WasteTypeExtension on WasteType {
  String get displayName {
    switch (this) {
      // Municipal and Household Waste
      case WasteType.municipalSolidWaste:
        return 'Municipal Solid Waste (MSW)';
      case WasteType.organicWaste:
        return 'Organic Waste';
      case WasteType.gardenWaste:
        return 'Garden Waste';

      // Recyclable Materials
      case WasteType.recyclablePaper:
        return 'Recyclable Paper';
      case WasteType.recyclableCardboard:
        return 'Recyclable Cardboard';
      case WasteType.recyclablePlastic:
        return 'Recyclable Plastic';
      case WasteType.recyclableGlass:
        return 'Recyclable Glass';
      case WasteType.recyclableMetal:
        return 'Recyclable Metal';
      case WasteType.recyclableTextiles:
        return 'Recyclable Textiles';

      // Non-Recyclable Materials
      case WasteType.nonRecyclablePlastic:
        return 'Non-Recyclable Plastic';
      case WasteType.nonRecyclableGlass:
        return 'Non-Recyclable Glass';
      case WasteType.nonRecyclableMetal:
        return 'Non-Recyclable Metal';
      case WasteType.nonRecyclableTextiles:
        return 'Non-Recyclable Textiles';

      // Hazardous Waste
      case WasteType.hazardousBatteries:
        return 'Hazardous Batteries';
      case WasteType.hazardousLightBulbs:
        return 'Hazardous Light Bulbs';
      case WasteType.hazardousChemicals:
        return 'Hazardous Chemicals';
      case WasteType.hazardousMedicalWaste:
        return 'Hazardous Medical Waste';
      case WasteType.hazardousAutomotiveWaste:
        return 'Hazardous Automotive Waste';
      case WasteType.hazardousPaint:
        return 'Hazardous Paint';
      case WasteType.hazardousSolvents:
        return 'Hazardous Solvents';

      // Electronic Waste (E-Waste)
      case WasteType.ewasteSmallAppliances:
        return 'Small Appliances';
      case WasteType.ewasteMediumAppliances:
        return 'Medium Appliances';
      case WasteType.ewasteLargeAppliances:
        return 'Large Appliances';
      case WasteType.ewasteICTEquipment:
        return 'ICT Equipment';
      case WasteType.ewasteLighting:
        return 'Lighting Equipment';
      case WasteType.ewasteToys:
        return 'Leisure Equipment';
      case WasteType.ewasteTools:
        return 'Tools & Equipment';

      // Construction and Demolition Waste
      case WasteType.constructionAndDemolitionWaste:
        return 'Construction and Demolition Waste';

      // Other Waste Types
      case WasteType.furnitureAndAppliances:
        return 'Furniture and Appliances';
      case WasteType.automotiveWaste:
        return 'Automotive Waste';
      case WasteType.medicalWaste:
        return 'Medical Waste';

      case WasteType.unknown:
      default:
        return 'Unknown';
    }
  }
}

String getWasteTypeId(WasteType wasteType) {
  return wasteType.displayName;
}
