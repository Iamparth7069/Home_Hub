class ServiceProviderRes {
  String? Uid;
  String fname;
  String lname;

  String Images;
  String email;
  int clicks;
  String contectnumber;
  String contectNumber2;
  String address;
  String? status;
  String? services;
  String? password;
  String? useraadharcard;
  String? fcmToken;
  ServiceProviderRes(
      {this.Uid,
      this.fcmToken,
      required this.fname,
      required this.clicks,
      required this.lname,
      required this.Images,
      required this.email,
      required this.contectnumber,
      required this.contectNumber2,
      required this.address,
      this.services,
      this.useraadharcard,
      this.password});

  Map<String, dynamic> tomap() {
    return {
      "fcmToken": fcmToken,
      "Uid": Uid,
      "Images": Images,
      "email": email,
      "contact": contectnumber,
      "contact(optional)": contectNumber2,
      "address": address,
      "services": services,
      "password": password,
      "fname": fname,
      "lname": lname,
      "clicks": clicks,
      "useraadharcard": useraadharcard,
    };
  }

  factory ServiceProviderRes.formMap(Map<String, dynamic> map) {
    return ServiceProviderRes(
      fcmToken: map["fcmToken"] ?? "",
      useraadharcard: map["useraadharcard"] ?? "",
      Uid: map["Uid"] ?? "",
      fname: map["fname"] ?? "",
      lname: map["lname"] ?? "",
      Images: map["Images"] ?? "",
      email: map["email"] ?? "",
      contectnumber: map["contact"] ?? "",
      contectNumber2: map["contact(optional)"] ?? "",
      address: map["address"] ?? "",
      services: map["services"] ?? "",
      clicks: map["clicks"] ?? 0,
      password: map["password"] ?? "",
    );
  }
//
}
