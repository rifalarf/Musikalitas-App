import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/sales.dart'; // Import model Sales
import 'tambahSales.dart'; // Import addSales
import 'editSales.dart'; // Import editSales
import '../product/lihatProduk.dart'; // Import viewProduct
import '../../widgets/custom_widgets.dart'; // Import Custom Widgets

class mySales extends StatefulWidget {
  const mySales({super.key});

  @override
  _SalesSayaPageState createState() => _SalesSayaPageState();
}

class _SalesSayaPageState extends State<mySales> {
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

  Future<void> _navigateToTambahSales() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const addSales()),
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
                    onPressed: _navigateToTambahSales,
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
                            builder: (context) => const editSales()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Produk',
                    icon: FontAwesomeIcons.eye,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const viewProduct()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
                child: const Column(
              children: [
                Text(
                  "Sales",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )
              ],
            )),
            const SizedBox(height: 20),
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
