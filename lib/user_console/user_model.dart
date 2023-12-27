class UserModel {
  String? id;
  String? userEmail;
  String? userPassword;
  String? userFullName;
  String? userPhoneNumber;
  String? userArea;
  String? userCity;
  String? userZipCode;
  String? profilePic;

  UserModel({
    this.id,
    this.userEmail,
    this.userPassword,
    this.userFullName,
    this.userPhoneNumber,
    this.userArea,
    this.userCity,
    this.userZipCode,
    this.profilePic,
  });

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    userEmail = map['userEmail'];
    userPassword = map['userPassword'];
    userFullName = map['userFullName'];
    userPhoneNumber = map['userPhoneNumber'];
    userArea = map['userArea'];
    userCity = map['userCity'];
    userZipCode = map['userZipCode'];
    profilePic = map['profilePic'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userEmail': userEmail,
      'userPassword': userPassword,
      'userFullName': userFullName,
      'userPhoneNumber': userPhoneNumber,
      'userArea': userArea,
      'userCity': userCity,
      'userZipCode': userZipCode,
      'profilePic': profilePic,
    };
  }
}
