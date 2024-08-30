import 'dart:convert';

class MaintenanceModel {
  String id;
  String carId;
  String driverId;
  String driverName;
  String carNumber;
  String maintenanceType;
  String description;
  double cost;
  String receiptPath;
  int date;
  int createdAt;
  MaintenanceModel({
    required this.id,
    required this.carId,
    required this.driverId,
    required this.driverName,
    required this.carNumber,
    required this.maintenanceType,
    required this.description,
    required this.cost,
    required this.receiptPath,
    required this.date,
    required this.createdAt,
  });

  MaintenanceModel copyWith({
    String? id,
    String? carId,
    String? driverId,
    String? driverName,
    String? carName,
    String? maintenanceType,
    String? description,
    double? cost,
    String? receiptPath,
    int? date,
    int? createdAt,
  }) {
    return MaintenanceModel(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      carNumber: carName ?? this.carNumber,
      maintenanceType: maintenanceType ?? this.maintenanceType,
      description: description ?? this.description,
      cost: cost ?? this.cost,
      receiptPath: receiptPath ?? this.receiptPath,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'carId': carId});
    result.addAll({'driverId': driverId});
    result.addAll({'driverName': driverName});
    result.addAll({'carName': carNumber});
    result.addAll({'maintenanceType': maintenanceType});
    result.addAll({'description': description});
    result.addAll({'cost': cost});
    result.addAll({'receiptPath': receiptPath});
    result.addAll({'date': date});
    result.addAll({'createdAt': createdAt});

    return result;
  }

  factory MaintenanceModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceModel(
      id: map['id'] ?? '',
      carId: map['carId'] ?? '',
      driverId: map['driverId'] ?? '',
      driverName: map['driverName'] ?? '',
      carNumber: map['carName'] ?? '',
      maintenanceType: map['maintenanceType'] ?? '',
      description: map['description'] ?? '',
      cost: map['cost']?.toDouble() ?? 0.0,
      receiptPath: map['receiptPath'] ?? '',
      date: map['date']?.toInt() ?? 0,
      createdAt: map['createdAt']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceModel.fromJson(String source) =>
      MaintenanceModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MaintenanceModel(id: $id, carId: $carId, driverId: $driverId, driverName: $driverName, carName: $carNumber, maintenanceType: $maintenanceType, description: $description, cost: $cost, receiptPath: $receiptPath, date: $date, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MaintenanceModel &&
        other.id == id &&
        other.carId == carId &&
        other.driverId == driverId &&
        other.driverName == driverName &&
        other.carNumber == carNumber &&
        other.maintenanceType == maintenanceType &&
        other.description == description &&
        other.cost == cost &&
        other.receiptPath == receiptPath &&
        other.date == date &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        carId.hashCode ^
        driverId.hashCode ^
        driverName.hashCode ^
        carNumber.hashCode ^
        maintenanceType.hashCode ^
        description.hashCode ^
        cost.hashCode ^
        receiptPath.hashCode ^
        date.hashCode ^
        createdAt.hashCode;
  }

  static MaintenanceModel empty() {
    return MaintenanceModel(
      id: '',
      carId: '',
      driverId: '',
      driverName: '',
      carNumber: '',
      maintenanceType: '',
      description: '',
      cost: 0.0,
      receiptPath: '',
      date: 0,
      createdAt: 0,
    );
  }
}
