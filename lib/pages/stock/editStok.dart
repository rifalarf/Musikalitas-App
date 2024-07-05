import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/stok.dart'; // Import model Stok
import '../../widgets/custom_widgets.dart'; // Import Custom Widgets
import 'editFormStok.dart'; // Import EditStockForm

class editStock extends StatefulWidget {
  const editStock({super.key});

  @override
  _EditStokPageState createState() => _EditStokPageState();
}

class _EditStokPageState extends State<editStock> {
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

  Future<void> _deleteStok(String id) async {
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
      String apiUrl = 'https://api.kartel.dev/stocks/$id';
      try {
        var response = await Dio().delete(apiUrl);
        if (response.statusCode == 200 || response.statusCode == 204) {
          // Jika berhasil, refresh daftar stok
          setState(() {
            _stokList = _fetchStok();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal menghapus stok: ${response.statusMessage}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  Future<void> _editStok(Stok stok) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditStockForm(stok: stok)),
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
      appBar: const CustomAppBar(title: 'Edit Stok'),
      backgroundColor: const Color.fromRGBO(220, 214, 247, 1), // Warna Scaffold
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
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
                                Text(
                                    'Jumlah: ${stok.qty}, Atribut: ${stok.attr}, Berat: ${stok.weight}'),
                                Text('Penyedia: ${stok.issuer}'),
                                Text('Dibuat pada: ${stok.createdAt}'),
                                Text('Terakhir diubah: ${stok.updatedAt}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    _editStok(stok);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    _deleteStok(stok.id);
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
