class Services{
  String did;
  String servicesName;
  String createdAt;
  String images;

  Services({required this.did, required this.servicesName, required this.createdAt, required this.images});


  factory Services.fromJson(Map<String, dynamic> json) {
    String formattedDate = json["createdAt"].toDate().toString();
    return Services(
      did: json["Did"],
      servicesName: json["ServiceName"],
      createdAt: formattedDate,
      images: json["image"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "did": this.did,
      "servicesName": this.servicesName,
      "createdAt": this.createdAt,
      "images": this.images,
    };
  }
}