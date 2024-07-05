import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/produk.dart'; // Import model Produk
import '../../widgets/custom_widgets.dart'; // Import Custom Widgets
import 'editFormProduk.dart'; // Import EditProductForm

class editProduk extends StatefulWidget {
  const editProduk({super.key});

  @override
  _EditProdukPageState createState() => _EditProdukPageState();
}

class _EditProdukPageState extends State<editProduk> {
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

  Future<void> _deleteProduk(String id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda ingin menghapus?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Tidak
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), // Ya
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );

    if (confirm) {
      String apiUrl = 'https://api.kartel.dev/products/$id';
      try {
        var response = await Dio().delete(apiUrl);
        if (response.statusCode == 200 || response.statusCode == 204) {
          // Jika berhasil, refresh daftar produk
          setState(() {
            _produkList = _fetchProduk();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal menghapus produk: ${response.statusMessage}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  Future<void> _editProduk(Produk produk) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProductForm(produk: produk)),
    );

    if (result == true) {
      setState(() {
        _produkList = _fetchProduk();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Produk'),
      backgroundColor: const Color.fromRGBO(220, 214, 247, 1), // Warna Scaffold
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<Produk>>(
                future: _produkList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Tidak ada produk tersedia'));
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    _editProduk(produk);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    _deleteProduk(produk.id);
                                  },
                                ),
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
          ],
        ),
      ),
    );
  }
}
