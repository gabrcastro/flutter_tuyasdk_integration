class User {
  int regFrom;
  String username;
  String sid;
  String uid;
  String service;
  String ecode;
  String nickName;
  String phoneCode;
  String partnerIdentity;
  String mobile;
  int userType;
  int productCount;
  String email;
  String headPic;
  String timezoneId;
  String userAlias;
  int dataVersion;
  int tempUnit;
  String snsNickname;

  User({
    required this.regFrom,
    required this.username,
    required this.sid,
    required this.uid,
    required this.service,
    required this.ecode,
    required this.nickName,
    required this.phoneCode,
    required this.partnerIdentity,
    required this.mobile,
    required this.userType,
    required this.productCount,
    required this.email,
    required this.headPic,
    required this.timezoneId,
    required this.userAlias,
    required this.dataVersion,
    required this.tempUnit,
    required this.snsNickname,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      regFrom: json['regFrom'] as int,
      username: json['username'] as String,
      sid: json['sid'] as String,
      uid: json['uid'] as String,
      service: json['service'] as String,
      ecode: json['ecode'] as String,
      nickName: json['nickName'] as String,
      phoneCode: json['phoneCode'] as String,
      partnerIdentity: json['partnerIdentity'] as String,
      mobile: json['mobile'] as String,
      userType: json['userType'] as int,
      productCount: json['productCount'] as int,
      email: json['email'] as String,
      headPic: json['headPic'] as String,
      timezoneId: json['timezoneId'] as String,
      userAlias: json['userAlias'] as String,
      dataVersion: json['dataVersion'] as int,
      tempUnit: json['tempUnit'] as int,
      snsNickname: json['snsNickname'] as String,
    );
  }
}