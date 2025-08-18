class KeyValueModel {
  final int key;
  final String value;

  KeyValueModel({required this.key, required this.value});

  factory KeyValueModel.fromJson(Map<String, dynamic> json) {
    return KeyValueModel(
      key: json['key'] as int,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }
}