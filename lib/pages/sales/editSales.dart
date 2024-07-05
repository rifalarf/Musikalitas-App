import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/sales.dart'; // Import model Sales
import '../../widgets/custom_widgets.dart'; // Import Custom Widgets
import 'editFormSales.dart'; // Import EditSalesForm

class editSales extends StatefulWidget {
  const editSales({super.key});

  @override
  _EditSalesPageState createState() => _EditSalesPageState();
}

class _EditSalesPageState extends State<editSales> {
  late Future<List<Sales>> _salesList;

  @override
  void initState() {
    super.initState();
    _salesList = _fetchSales();
  }

  Future<List<Sales>> _fetchSales() async {
    String apiUrl = 'https://api.kartel.dev/sales';
    try {
      var response = await Dio().get(apiUrl);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Sales.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load sales');
      }
    } catch (e) {
      throw Exception('Failed to load sales: $e');
    }
  }

  Future<void> _deleteSales(String id) async {
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
      String apiUrl = 'https://api.kartel.dev/sales/$id';
      try {
        var response = await Dio().delete(apiUrl);
        if (response.statusCode == 200 || response.statusCode == 204) {
          // Jika berhasil, refresh daftar sales
          setState(() {
            _salesList = _fetchSales();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal menghapus sales: ${response.statusMessage}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  Future<void> _editSales(Sales sales) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditSalesForm(sales: sales)),
    );

    if (result == true) {
      setState(() {
        _salesList = _fetchSales();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Sales'),
      backgroundColor: const Color.fromRGBO(220, 214, 247, 1), // Warna Scaffold
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<Sales>>(
                future: _salesList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada sales tersedia'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Sales sales = snapshot.data![index];
                        return Card(
                          child: ListTile(
                            title: Text(sales.buyer),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Phone: ${sales.phone}, Date: ${sales.date}, Status: ${sales.status}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    _editSales(sales);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _deleteSales(sales.id);
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
