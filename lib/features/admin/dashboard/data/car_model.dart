import 'dart:convert';

class CarModel {
  String id;
  String type;
  String model;
  String brand;
  String description;
  String registrationNumber;
  String status;
  String fuelType;
  double fuelCapacity;
  int seatCapacity;
  int lastMaintenance;

  CarModel({
    required this.id,
    required this.type,
    required this.model,
    required this.brand,
    required this.description,
    required this.registrationNumber,
    this.status = 'available',
    required this.fuelType,
    required this.fuelCapacity,
    this.seatCapacity = 0,
    required this.lastMaintenance,
  });

  static CarModel empty() {
    return CarModel(
      id: '',
      type: '',
      model: '',
      brand: '',
      description: '',
      registrationNumber: '',
      fuelType: '',
      fuelCapacity: 0.0,
      lastMaintenance: 0
    );
  }

  CarModel copyWith({
    String? id,
    String? type,
    String? model,
    String? brand,
    String? description,
    String? registrationNumber,
    String? status,
    String? fuelType,
    double? fuelCapacity,
    int? seatCapacity,
    int? lastMaintenance,
  }) {
    return CarModel(
      id: id ?? this.id,
      type: type ?? this.type,
      model: model ?? this.model,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      status: status ?? this.status,
      fuelType: fuelType ?? this.fuelType,
      fuelCapacity: fuelCapacity ?? this.fuelCapacity,
      seatCapacity: seatCapacity ?? this.seatCapacity,
      lastMaintenance: lastMaintenance ?? this.lastMaintenance,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'type': type});
    result.addAll({'model': model});
    result.addAll({'brand': brand});
    result.addAll({'description': description});
    result.addAll({'registrationNumber': registrationNumber});
    result.addAll({'status': status});
    result.addAll({'fuelType': fuelType});
    result.addAll({'fuelCapacity': fuelCapacity});
    result.addAll({'seatCapacity': seatCapacity});
    result.addAll({'lastMaintenance': lastMaintenance});
  
    return result;
  }

  factory CarModel.fromMap(Map<String, dynamic> map) {
    return CarModel(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      model: map['model'] ?? '',
      brand: map['brand'] ?? '',
      description: map['description'] ?? '',
      registrationNumber: map['registrationNumber'] ?? '',
      status: map['status'] ?? '',
      fuelType: map['fuelType'] ?? '',
      fuelCapacity: map['fuelCapacity']?.toDouble() ?? 0.0,
      seatCapacity: map['seatCapacity']?.toInt() ?? 0,
      lastMaintenance: map['lastMaintenance']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CarModel.fromJson(String source) =>
      CarModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CarModel(id: $id, type: $type, model: $model, brand: $brand, description: $description, registrationNumber: $registrationNumber, status: $status, fuelType: $fuelType, fuelCapacity: $fuelCapacity, seatCapacity: $seatCapacity, lastMaintenance: $lastMaintenance)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CarModel &&
      other.id == id &&
      other.type == type &&
      other.model == model &&
      other.brand == brand &&
      other.description == description &&
      other.registrationNumber == registrationNumber &&
      other.status == status &&
      other.fuelType == fuelType &&
      other.fuelCapacity == fuelCapacity &&
      other.seatCapacity == seatCapacity &&
      other.lastMaintenance == lastMaintenance;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      type.hashCode ^
      model.hashCode ^
      brand.hashCode ^
      description.hashCode ^
      registrationNumber.hashCode ^
      status.hashCode ^
      fuelType.hashCode ^
      fuelCapacity.hashCode ^
      seatCapacity.hashCode ^
      lastMaintenance.hashCode;
  }
}
