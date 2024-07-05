class Produk {
  String id;
  String name;
  double price;
  int qty;
  String attr;
  double weight;
  List<String> stokItems; // Daftar ID item stok yang dipilih

  Produk({
    required this.id,
    required this.name,
    required this.price,
    required this.qty,
    required this.attr,
    required this.weight,
    required this.stokItems,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      qty: (json['qty'] as num).toInt(),
      attr: json['attr'],
      weight: (json['weight'] as num).toDouble(),
      stokItems: List<String>.from(json['stokItems'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'qty': qty,
      'attr': attr,
      'weight': weight,
    };
  }
}
