import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'stok_saya_page.dart'; // Import StokSayaPage
import 'produk_saya_page.dart'; // Import ProdukSayaPage
import 'sales_saya_page.dart'; // Import SalesSayaPage
import 'tentang_aplikasi_page.dart'; // Import TentangAplikasiPage
import '../widgets/custom_widgets.dart'; // Import Custom Widgets

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<Map<String, int>> _fetchData() async {
    final stokResponse =
        await http.get(Uri.parse('https://api.kartel.dev/stocks'));
    final produkResponse =
        await http.get(Uri.parse('https://api.kartel.dev/products'));
    final salesResponse =
        await http.get(Uri.parse('https://api.kartel.dev/sales'));

    if (stokResponse.statusCode == 200 &&
        produkResponse.statusCode == 200 &&
        salesResponse.statusCode == 200) {
      return {
        'totalStok': json.decode(stokResponse.body).length,
        'totalProduk': json.decode(produkResponse.body).length,
        'totalSales': json.decode(salesResponse.body).length,
      };
    } else {
      throw Exception('Failed to load data');
    }
  }

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return StokSayaPage();
      case 2:
        return ProdukSayaPage();
      case 3:
        return SalesSayaPage();
      case 4:
        return TentangAplikasiPage();
      default:
        return _buildHomePage();
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi!';
    } else if (hour < 18) {
      return 'Selamat Siang!';
    } else {
      return 'Selamat Malam!';
    }
  }

  Widget _buildHomePage() {
    return FutureBuilder<Map<String, int>>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getGreeting(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(FontAwesomeIcons.infoCircle,
                                color: Colors.black),
                            SizedBox(width: 10),
                            Text(
                              'Informasi',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        _buildFeatureInfo(
                          icon: FontAwesomeIcons.box,
                          text:
                              'Stok adalah persediaan barang yang dimiliki oleh bisnis.',
                        ),
                        SizedBox(height: 10),
                        _buildFeatureInfo(
                          icon: FontAwesomeIcons.cubes,
                          text:
                              'Produk adalah barang atau jasa yang dijual oleh bisnis kepada pelanggan.',
                        ),
                        SizedBox(height: 10),
                        _buildFeatureInfo(
                          icon: FontAwesomeIcons.shoppingCart,
                          text:
                              'Sales adalah aktivitas penjualan barang atau jasa kepada pelanggan.',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FaIcon(FontAwesomeIcons.box, color: Colors.black),
                            FaIcon(FontAwesomeIcons.cubes, color: Colors.black),
                            FaIcon(FontAwesomeIcons.shoppingCart,
                                color: Colors.black),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '${data['totalStok']}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${data['totalProduk']}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${data['totalSales']}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(
                        'assets/images/home.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }

  Widget _buildFeatureInfo({required IconData icon, required String text}) {
    return Row(
      children: [
        FaIcon(icon, color: Colors.black),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Musikalitas', showBackButton: false),
      backgroundColor: Color.fromRGBO(220, 214, 247, 1), // Warna Scaffold
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.box),
            label: 'Stok',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.cubes),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.shoppingCart),
            label: 'Sales',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.infoCircle),
            label: 'Tentang',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(66, 72, 116, 1),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
