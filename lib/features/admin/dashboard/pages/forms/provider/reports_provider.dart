import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportData {
  int startDate;
  int lastDate;
  String type;
  List<Object> data;
  ReportData({
    required this.startDate,
    required this.lastDate,
    required this.type,
    required this.data,
  });

  static ReportData empty() {
    return ReportData(
        data: [],
        lastDate: DateTime.now().millisecondsSinceEpoch,
        startDate: 0,
        type: '');
  }

  ReportData copyWith({
    int? startDate,
    int? lastDate,
    String? type,
    List<Object>? data,
  }) {
    return ReportData(
      startDate: startDate ?? this.startDate,
      lastDate: lastDate ?? this.lastDate,
      type: type ?? this.type,
      data: data ?? this.data,
    );
  }
}

final reportProvider = StateNotifierProvider<ReportsProvider, ReportData>(
    (ref) => ReportsProvider());

class ReportsProvider extends StateNotifier<ReportData> {
  ReportsProvider() : super(ReportData.empty());

  void setStartDate(int millisecondsSinceEpoch) {
    state = state.copyWith(startDate: millisecondsSinceEpoch);
  }

  void setLastDate(int millisecondsSinceEpoch) {
    state = state.copyWith(lastDate: millisecondsSinceEpoch);
    
  }

  void setType(String string) {
    state = state.copyWith(type: string);
  }
}
