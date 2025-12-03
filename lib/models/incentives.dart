import 'package:binpack_residents/utils/enums.dart';

class Incentive {
  final WasteType wasteType;
  final double minWeight;
  final double maxWeight;
  final double amount;

  Incentive({
    required this.wasteType,
    required this.minWeight,
    required this.maxWeight,
    required this.amount,
  });
}

List<Incentive> incentives = [
  // Municipal and Household Waste
  Incentive(
      wasteType: WasteType.municipalSolidWaste,
      minWeight: 0,
      maxWeight: 10,
      amount: 5.0),
  Incentive(
      wasteType: WasteType.municipalSolidWaste,
      minWeight: 10,
      maxWeight: 20,
      amount: 10.0),

  Incentive(
      wasteType: WasteType.organicWaste,
      minWeight: 0,
      maxWeight: 10,
      amount: 4.0),
  Incentive(
      wasteType: WasteType.organicWaste,
      minWeight: 10,
      maxWeight: 20,
      amount: 8.0),

  Incentive(
      wasteType: WasteType.gardenWaste,
      minWeight: 0,
      maxWeight: 10,
      amount: 3.0),
  Incentive(
      wasteType: WasteType.gardenWaste,
      minWeight: 10,
      maxWeight: 20,
      amount: 6.0),

  // Recyclable Materials
  Incentive(
      wasteType: WasteType.recyclablePaper,
      minWeight: 0,
      maxWeight: 10,
      amount: 2.5),
  Incentive(
      wasteType: WasteType.recyclablePaper,
      minWeight: 10,
      maxWeight: 20,
      amount: 5.0),

  Incentive(
      wasteType: WasteType.recyclablePlastic,
      minWeight: 0,
      maxWeight: 10,
      amount: 3.0),
  Incentive(
      wasteType: WasteType.recyclablePlastic,
      minWeight: 10,
      maxWeight: 20,
      amount: 6.0),

  Incentive(
      wasteType: WasteType.recyclableGlass,
      minWeight: 0,
      maxWeight: 10,
      amount: 3.5),
  Incentive(
      wasteType: WasteType.recyclableGlass,
      minWeight: 10,
      maxWeight: 20,
      amount: 7.0),

  Incentive(
      wasteType: WasteType.recyclableMetal,
      minWeight: 0,
      maxWeight: 10,
      amount: 5.0),
  Incentive(
      wasteType: WasteType.recyclableMetal,
      minWeight: 10,
      maxWeight: 20,
      amount: 10.0),

  Incentive(
      wasteType: WasteType.recyclableTextiles,
      minWeight: 0,
      maxWeight: 10,
      amount: 2.0),
  Incentive(
      wasteType: WasteType.recyclableTextiles,
      minWeight: 10,
      maxWeight: 20,
      amount: 4.0),

  // Non-Recyclable Materials
  Incentive(
      wasteType: WasteType.nonRecyclablePlastic,
      minWeight: 0,
      maxWeight: 10,
      amount: 1.0),
  Incentive(
      wasteType: WasteType.nonRecyclableGlass,
      minWeight: 0,
      maxWeight: 10,
      amount: 1.0),
  Incentive(
      wasteType: WasteType.nonRecyclableMetal,
      minWeight: 0,
      maxWeight: 10,
      amount: 1.5),

  // Hazardous Waste
  Incentive(
      wasteType: WasteType.hazardousBatteries,
      minWeight: 0,
      maxWeight: 10,
      amount: 2.0),
  Incentive(
      wasteType: WasteType.hazardousBatteries,
      minWeight: 10,
      maxWeight: 20,
      amount: 4.0),

  Incentive(
      wasteType: WasteType.hazardousLightBulbs,
      minWeight: 0,
      maxWeight: 10,
      amount: 1.0),
  Incentive(
      wasteType: WasteType.hazardousLightBulbs,
      minWeight: 10,
      maxWeight: 20,
      amount: 2.0),

  Incentive(
      wasteType: WasteType.hazardousChemicals,
      minWeight: 0,
      maxWeight: 10,
      amount: 7.0),
  Incentive(
      wasteType: WasteType.hazardousMedicalWaste,
      minWeight: 0,
      maxWeight: 10,
      amount: 7.5),

  Incentive(
      wasteType: WasteType.hazardousAutomotiveWaste,
      minWeight: 0,
      maxWeight: 10,
      amount: 4.0),
  Incentive(
      wasteType: WasteType.hazardousAutomotiveWaste,
      minWeight: 10,
      maxWeight: 20,
      amount: 8.0),

  // Electronic Waste (E-Waste)
  Incentive(
      wasteType: WasteType.ewasteSmallAppliances,
      minWeight: 0,
      maxWeight: 10,
      amount: 6.0),
  Incentive(
      wasteType: WasteType.ewasteMediumAppliances,
      minWeight: 10,
      maxWeight: 20,
      amount: 12.0),

  Incentive(
      wasteType: WasteType.ewasteICTEquipment,
      minWeight: 0,
      maxWeight: 10,
      amount: 5.0),
  Incentive(
      wasteType: WasteType.ewasteLighting,
      minWeight: 0,
      maxWeight: 10,
      amount: 2.0),

  // Construction and Demolition Waste
  Incentive(
      wasteType: WasteType.constructionAndDemolitionWaste,
      minWeight: 0,
      maxWeight: 10,
      amount: 8.0),
  Incentive(
      wasteType: WasteType.constructionAndDemolitionWaste,
      minWeight: 10,
      maxWeight: 20,
      amount: 16.0),

  // Furniture and Appliances
  Incentive(
      wasteType: WasteType.furnitureAndAppliances,
      minWeight: 0,
      maxWeight: 10,
      amount: 10.0),
  Incentive(
      wasteType: WasteType.furnitureAndAppliances,
      minWeight: 10,
      maxWeight: 20,
      amount: 20.0),

  // Automotive Waste
  Incentive(
      wasteType: WasteType.automotiveWaste,
      minWeight: 0,
      maxWeight: 10,
      amount: 4.0),
  Incentive(
      wasteType: WasteType.automotiveWaste,
      minWeight: 10,
      maxWeight: 20,
      amount: 8.0),

  // Medical Waste
  Incentive(
      wasteType: WasteType.medicalWaste,
      minWeight: 0,
      maxWeight: 10,
      amount: 7.5),
  Incentive(
      wasteType: WasteType.medicalWaste,
      minWeight: 10,
      maxWeight: 20,
      amount: 15.0),
];
