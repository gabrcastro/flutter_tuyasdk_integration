class DeviceModel {
  String name;
  String icon;

  DeviceModel({
    required this.icon,
    required this.name,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      name: json['name'] as String,
      icon: json['icon'] as String,
    );
  }
}