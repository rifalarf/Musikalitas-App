import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/sales.dart'; // Import model Sales
import 'tambah_sales_page.dart'; // Import TambahSalesPage
import 'edit_sales_page.dart'; // Import EditSalesPage
import 'lihat_produk_page.dart'; // Import LihatProdukPage
import '../widgets/custom_widgets.dart'; // Import Custom Widgets

class SalesSayaPage extends StatefulWidget {
  @override
  _SalesSayaPageState createState() => _SalesSayaPageState();
}

class _SalesSayaPageState extends State<SalesSayaPage> {
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
      MaterialPageRoute(builder: (context) => TambahSalesPage()),
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
                    onPressed: _navigateToTambahSales,
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
                            builder: (context) => EditSalesPage()),
                      );
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Produk',
                    icon: FontAwesomeIcons.eye,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LihatProdukPage()),
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
                  "Sales",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )
              ],
            )),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Sales>>(
                future: _salesList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Tidak ada sales tersedia'));
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
