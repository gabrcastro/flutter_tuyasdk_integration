class DeviceModel {
  String name;
  String icon;
  int type;

  DeviceModel({
    required this.icon,
    required this.name,
    required this.type
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      name: json['name'] as String,
      icon: json['icon'] as String,
      type: json['type'] as int,
    );
  }
}