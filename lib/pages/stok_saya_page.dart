import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/stok.dart'; // Import model Stok
import 'tambah_stok_page.dart'; // Import TambahStokPage
import 'edit_stok_page.dart'; // Import EditStokPage
import '../widgets/custom_widgets.dart'; // Import Custom Widgets

class StokSayaPage extends StatefulWidget {
  const StokSayaPage({super.key});

  @override
  _StokSayaPageState createState() => _StokSayaPageState();
}

class _StokSayaPageState extends State<StokSayaPage> {
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

  Future<void> _navigateToTambahStok() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TambahStokPage()),
    );

    if (result == true) {
      setState(() {
        _stokList = _fetchStok();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(220, 214, 247, 1), // Warna Scaffold
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
                    onPressed: _navigateToTambahStok,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Edit',
                    icon: FontAwesomeIcons.edit,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditStokPage()),
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
                  "Stok",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )
              ],
            )),
            SizedBox(height: 20),
            Expanded(
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
                                Text('Jumlah: ${stok.qty}'),
                                Text('Penyedia: ${stok.issuer}'),
                                Text('Terakhir diperbarui: ${stok.updatedAt}'),
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
