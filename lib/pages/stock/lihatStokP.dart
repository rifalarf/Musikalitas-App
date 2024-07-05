import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/stok.dart'; // Import model Stok
import '../../widgets/custom_widgets.dart'; // Import Custom Widgets

class viewStockProduct extends StatefulWidget {
  const viewStockProduct({super.key});

  @override
  _LihatStokProdukPageState createState() => _LihatStokProdukPageState();
}

class _LihatStokProdukPageState extends State<viewStockProduct> {
  late Future<List<Stok>> _stokList;

  @override
  void initState() {
    super.initState();
    _stokList = _fetchStok();
  }

  Future<List<Stok>> _fetchStok() async {
    String apiUrl = 'https://api.kartel.dev/stocks';
    try {
      var response = await Dio().get(apiUrl);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Stok.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load stok');
      }
    } catch (e) {
      throw Exception('Failed to load stok: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Lihat Stok'),
      backgroundColor: const Color.fromRGBO(220, 214, 247, 1), // Warna Scaffold
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Stok>>(
          future: _stokList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Tidak ada stok tersedia'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Stok stok = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      title: Text(stok.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Kuantitas: ${stok.qty}, Atribut: ${stok.attr}, Berat: ${stok.weight}'),
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
