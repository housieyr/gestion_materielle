import '../data/tables.dart';

String statusToText(EquipmentStatus s) {
  switch (s) {
    case EquipmentStatus.working:
      return 'يعمل';
    case EquipmentStatus.needsMaintenance:
      return 'تحتاج صيانة';
    case EquipmentStatus.inRepair:
      return 'في التصليح';
    case EquipmentStatus.outOfService:
      return 'خارج الخدمة';
  }
}