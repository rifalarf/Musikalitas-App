import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/produk.dart'; // Import model Produk
import 'tambah_produk_page.dart'; // Import TambahProdukPage
import 'edit_produk_page.dart'; // Import EditProdukPage
import 'lihat_stok_produk_page.dart'; // Import LihatStokProdukPage
import '../widgets/custom_widgets.dart'; // Import Custom Widgets

class ProdukSayaPage extends StatefulWidget {
  @override
  _ProdukSayaPageState createState() => _ProdukSayaPageState();
}

class _ProdukSayaPageState extends State<ProdukSayaPage> {
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

  Future<void> _navigateToTambahProduk() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TambahProdukPage()),
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
      backgroundColor: Color.fromRGBO(220, 214, 247, 1), // Warna Scaffold
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Tambah',
                    icon: FontAwesomeIcons.plus,
                    onPressed: _navigateToTambahProduk,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Edit',
                    icon: FontAwesomeIcons.edit,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProdukPage()),
                      );
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Stok',
                    icon: FontAwesomeIcons.eye,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LihatStokProdukPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
                child: Column(
              children: [
                Text(
                  "Produk",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Produk>>(
                future: _produkList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Tidak ada produk tersedia'));
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
          ],
        ),
      ),
    );
  }
}
