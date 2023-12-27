class TailorModel {
  String? id;
  String? tailorEmail;
  String? tailorPassword;
  String? fullName;
  String? shopName;
  String? shopNumber;
  String? description;
  String? area;
  String? city;
  String? zipCode;
  String? availableTimings;
  String? typesOfCloths;
  String? priceForEachTime;
  String? phoneNumber;
  String? profilePic;
  String? orderStatus;

  TailorModel({
    this.id,
    this.tailorEmail,
    this.tailorPassword,
    this.fullName,
    this.shopName,
    this.shopNumber,
    this.description,
    this.area,
    this.city,
    this.zipCode,
    this.availableTimings,
    this.typesOfCloths,
    this.priceForEachTime,
    this.phoneNumber,
    this.profilePic,
    this.orderStatus,
  });

  TailorModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    tailorEmail = map['tailorEmail'];
    tailorPassword = map['tailorPassword'];
    fullName = map['fullName'];
    shopName = map['shopName'];
    shopNumber = map['shopNumber'];
    description = map['description'];
    area = map['area'];
    city = map['city'];
    zipCode = map['zipCode'];
    availableTimings = map['availableTimings'];
    typesOfCloths = map['typesOfCloths'];
    phoneNumber = map['phoneNumber'];
    profilePic = map['profilePic'];
    orderStatus = map['orderStatus'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tailorEmail': tailorEmail,
      'tailorPassword': tailorPassword,
      'fullName': fullName,
      'shopName': shopName,
      'shopNumber': shopNumber,
      'description': description,
      'area': area,
      'city': city,
      'zipCode': zipCode,
      'availableTimings': availableTimings,
      'typesOfCloths': typesOfCloths,
      'phoneNumber': phoneNumber,
      'profilePic': profilePic,
      'orderStatus': orderStatus,
    };
  }
}
