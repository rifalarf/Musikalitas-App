import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/produk.dart'; // Import model Produk
import '../../models/stok.dart'; // Import model Stok
import '../../widgets/custom_widgets.dart'; // Import Custom Widgets

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  _TambahProdukPageState createState() => _TambahProdukPageState();
}

class _TambahProdukPageState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _price = 0.0;
  int _qty = 0;
  String _attr = '';
  double _weight = 0.0;
  List<Stok> _stokList = [];
  final List<Stok> _selectedStokItems = [];

  @override
  void initState() {
    super.initState();
    _fetchStok();
  }

  Future<void> _fetchStok() async {
    String apiUrl = 'https://api.kartel.dev/stocks';
    try {
      var response = await Dio().get(apiUrl);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        setState(() {
          _stokList = data.map((json) => Stok.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load stok');
      }
    } catch (e) {
      throw Exception('Failed to load stok: $e');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Buat objek Produk tanpa stokItems
      Produk produk = Produk(
        id: '', // ID akan dihasilkan oleh server
        name: _name,
        price: _price,
        qty: _qty,
        attr: _attr,
        weight: _weight,
        stokItems: [], // Kosongkan stokItems karena tidak dikirim ke API
      );

      // Endpoint API
      String apiUrl = 'https://api.kartel.dev/products';

      try {
        // Logging data yang akan dikirim
        print('Data yang dikirim: ${produk.toJson()}');

        // Mengirim POST request ke API
        var response = await Dio().post(
          apiUrl,
          data: produk.toJson(),
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
            validateStatus: (status) {
              return status! < 500; // Tangani status kode di bawah 500
            },
          ),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Simpan item stok yang dipilih ke memori lokal
          SharedPreferences prefs = await SharedPreferences.getInstance();
          List<String> selectedStokIds =
              _selectedStokItems.map((stok) => stok.id).toList();
          await prefs.setStringList('selectedStokItems', selectedStokIds);

          // Jika berhasil, tampilkan notifikasi dan kembali ke halaman Produk Saya dengan hasil true
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Berhasil'),
                content: const Text('Produk ditambahkan'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                      Navigator.pop(context,
                          true); // Kembali ke halaman sebelumnya dengan hasil true
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Jika gagal, tampilkan pesan error
          print('Error response: ${response.data}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal untuk menambahproduk: ${response.statusMessage}')),
          );
        }
      } catch (e) {
        // Jika terjadi error, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  void _addStokItem(Stok stok) {
    setState(() {
      _selectedStokItems.add(stok);
    });
  }

  void _removeStokItem(Stok stok) {
    setState(() {
      _selectedStokItems.remove(stok);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Tambah Produk'),
      backgroundColor: const Color.fromRGBO(220, 214, 247, 1), // Warna Scaffold
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(
                  244, 238, 255, 1), // Warna latar belakang
              borderRadius: BorderRadius.circular(10), // Radius sudut
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nama'),
                    onSaved: (value) {
                      _name = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Harga'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _price = double.parse(value!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Harga tidak boleh kosong';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Harga harus berupa angka';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Kuantitas'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _qty = int.parse(value!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kuantitas tidak boleh kosong';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Kuantitas harus berupa angka';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Atribut'),
                    onSaved: (value) {
                      _attr = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Atribut tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Berat'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onSaved: (value) {
                      _weight = double.parse(value!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Berat tidak boleh kosong';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Berat harus berupa angka';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pilih Item Stok',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 300,
                            child: ListView.builder(
                              itemCount: _stokList.length,
                              itemBuilder: (context, index) {
                                Stok stok = _stokList[index];
                                bool isSelected =
                                    _selectedStokItems.contains(stok);
                                return ListTile(
                                  title: Text(stok.name),
                                  subtitle: Text(
                                      'Kuantitas: ${stok.qty}, Atribut: ${stok.attr}, Berat: ${stok.weight}'),
                                  trailing: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (Widget child,
                                        Animation<double> animation) {
                                      return RotationTransition(
                                        turns:
                                            child.key == const ValueKey('add')
                                                ? Tween(begin: 1.0, end: 0.0)
                                                    .animate(animation)
                                                : Tween(begin: 0.0, end: 1.0)
                                                    .animate(animation),
                                        child: child,
                                      );
                                    },
                                    child: isSelected
                                        ? IconButton(
                                            key: const ValueKey('remove'),
                                            icon: const Icon(
                                                Icons.remove_circle,
                                                color: Colors.red),
                                            onPressed: () {
                                              _removeStokItem(stok);
                                            },
                                          )
                                        : IconButton(
                                            key: const ValueKey('add'),
                                            icon: const Icon(Icons.add_circle,
                                                color: Colors.green),
                                            onPressed: () {
                                              _addStokItem(stok);
                                            },
                                          ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Pilih Item Stok'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Item Stok yang Dipilih',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _selectedStokItems.length,
                    itemBuilder: (context, index) {
                      Stok stok = _selectedStokItems[index];
                      return ListTile(
                        title: Text(stok.name),
                        subtitle: Text(
                            'Kuantitas: ${stok.qty}, Atribut: ${stok.attr}, Berat: ${stok.weight}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: () {
                            _removeStokItem(stok);
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 70,
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                              66, 72, 116, 1), // Warna tombol
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15), // Radius sudut
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        onPressed: _submitForm,
                        child: const Text('Tambah',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
