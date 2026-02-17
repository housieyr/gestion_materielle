class Equipment {
  final int? id;
  final int inventoryNumber; // رقم العدة (ع/ر)
  final String type; // نوع العتاد
  final String manufacturer; // المصنع
  final String serialNumber; // الرقم التسلسلي (إجباري وفريد)
  final String department; // الهيكل
  final String office; // المكتب
  final String status; // الملاحظات/الحالة
  final String? notes; // ملاحظات إضافية (اختياري)

  const Equipment({
    this.id,
    required this.inventoryNumber,
    required this.type,
    required this.manufacturer,
    required this.serialNumber,
    required this.department,
    required this.office,
    required this.status,
    this.notes,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'inventoryNumber': inventoryNumber,
    'type': type,
    'manufacturer': manufacturer,
    'serialNumber': serialNumber,
    'department': department,
    'office': office,
    'status': status,
    'notes': notes,
  };

  static Equipment fromMap(Map<String, Object?> map) => Equipment(
    id: map['id'] as int?,
    inventoryNumber: map['inventoryNumber'] as int,
    type: map['type'] as String,
    manufacturer: map['manufacturer'] as String,
    serialNumber: map['serialNumber'] as String,
    department: map['department'] as String,
    office: map['office'] as String,
    status: map['status'] as String,
    notes: map['notes'] as String?,
  );
}
