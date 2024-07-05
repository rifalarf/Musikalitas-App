import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/produk.dart'; // Import model Produk
import '../../widgets/custom_widgets.dart'; // Import Custom Widgets

class viewProduct extends StatefulWidget {
  const viewProduct({super.key});

  @override
  _LihatProdukPageState createState() => _LihatProdukPageState();
}

class _LihatProdukPageState extends State<viewProduct> {
  late Future<List<Produk>> _produkList;

  @override
  void initState() {
    super.initState();
    _produkList = _fetchProduk();
  }

  Future<List<Produk>> _fetchProduk() async {
    String apiUrl = 'https://api.kartel.dev/products';
    try {
      var response = await Dio().get(apiUrl);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Produk.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load produk');
      }
    } catch (e) {
      throw Exception('Failed to load produk: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Lihat Produk'),
      backgroundColor: const Color.fromRGBO(220, 214, 247, 1), // Warna Scaffold
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Produk>>(
          future: _produkList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Tidak ada produk tersedia'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Produk produk = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      title: Text(produk.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Harga: ${produk.price}, Kuantitas: ${produk.qty}, Atribut: ${produk.attr}, Berat: ${produk.weight}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
