class RepairHistoryItem {
  final List<RepairHistoryItem> childHistoryRepair;
  final String? historyRepairId;
  final String? mainInventoryId;
  final String description;
  final int quantity;
  final double estimatePrice;
  final String? supplier;
  final String note;
  final DateTime repairDate;
  final String? parentId;
  final String? status;
  final DateTime? completeDate;
  final String? avatarUrlSmall;
  final String? avatarUrlMedium;
  final String? avatarUrlBig;

  RepairHistoryItem({
    required this.childHistoryRepair,
    this.historyRepairId,
    this.mainInventoryId,
    required this.description,
    required this.quantity,
    required this.estimatePrice,
    this.supplier,
    required this.note,
    required this.repairDate,
    this.parentId,
    this.status,
    this.completeDate,
    this.avatarUrlSmall,
    this.avatarUrlMedium,
    this.avatarUrlBig,
  });

  factory RepairHistoryItem.fromJson(Map<String, dynamic> json) {
    return RepairHistoryItem(
      childHistoryRepair: (json['childHistoryRepair'] as List)
          .map((e) => RepairHistoryItem.fromJson(e))
          .toList(),
      historyRepairId: json['historyRepairId'] ?? '',
      mainInventoryId: json['mainInventoryId'] ?? '',
      description: json['description'] ?? '',
      quantity: json['quantity'] ?? 0,
      estimatePrice: json['estimatePrice'] ?? 0.0,
      supplier: json['supplier'] ?? '',
      note: json['note'] ?? '',
      repairDate: DateTime.parse(json['repairDate']),
      parentId: json['parentId'] ?? '',
      status: json['status'] ?? '',
      completeDate: json['completeDate'] != null
          ? DateTime.parse(json['completeDate'])
          : null,
      avatarUrlSmall: json['avatarUrlSmall'],
      avatarUrlMedium: json['avatarUrlMedium'] ?? '',
      avatarUrlBig: json['avatarUrlBig'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'childRepairHistory': childHistoryRepair.map((e) => e.toJson()).toList(),
      'historyRepairId': historyRepairId,
      'mainInventoryId': mainInventoryId,
      'description': description,
      'quantity': quantity,
      'estimatePrice': estimatePrice,
      'supplier': supplier,
      'note': note,
      'repairDate': repairDate.toIso8601String(),
      'parentId': parentId,
      'status': status,
      'completeDate': completeDate?.toIso8601String(),
      'avatarUrlSmall': avatarUrlSmall,
      'avatarUrlMedium': avatarUrlMedium,
      'avatarUrlBig': avatarUrlBig,
    };
  }

  @override
  String toString() {
    return 'RepairHistoryItem(childHistoryRepair: $childHistoryRepair, historyRepairId: $historyRepairId, mainInventoryId: $mainInventoryId, description: $description, quantity: $quantity, estimatePrice: $estimatePrice, supplier: $supplier, note: $note, repairDate: $repairDate, parentId: $parentId, status: $status, completeDate: $completeDate, avatarUrlSmall: $avatarUrlSmall, avatarUrlMedium: $avatarUrlMedium, avatarUrlBig: $avatarUrlBig)';
  }
}
