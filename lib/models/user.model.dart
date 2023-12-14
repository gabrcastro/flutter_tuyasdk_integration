class UserModel {
  String? uid;

  UserModel({
    this.uid,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['uid'] = uid;

    return data;
  }
}