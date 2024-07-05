class Sales {
  String id;
  String buyer;
  String phone;
  String date;
  String status;

  Sales({
    required this.id,
    required this.buyer,
    required this.phone,
    required this.date,
    required this.status,
  });

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      id: json['id'],
      buyer: json['buyer'],
      phone: json['phone'],
      date: json['date'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buyer': buyer,
      'phone': phone,
      'date': date,
      'status': status,
    };
  }
}
