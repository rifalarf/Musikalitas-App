import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/produk.dart'; // Import model Produk
// Import model Stok
import '../../widgets/custom_widgets.dart'; // Import Custom Widgets

class EditProductForm extends StatefulWidget {
  final Produk produk;

  const EditProductForm({super.key, required this.produk});

  @override
  _EditProdukFormState createState() => _EditProdukFormState();
}

class _EditProdukFormState extends State<EditProductForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;
  late int _qty;
  late String _attr;
  late double _weight;

  @override
  void initState() {
    super.initState();
    _name = widget.produk.name;
    _price = widget.produk.price;
    _qty = widget.produk.qty;
    _attr = widget.produk.attr;
    _weight = widget.produk.weight;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Data yang akan dikirim ke API tanpa stokItems
      Produk updatedProduk = Produk(
        id: widget.produk.id,
        name: _name,
        price: _price,
        qty: _qty,
        attr: _attr,
        weight: _weight,
        stokItems: [], // Kosongkan stokItems karena tidak dikirim ke API
      );

      // Endpoint API
      String apiUrl = 'https://api.kartel.dev/products/${widget.produk.id}';

      try {
        // Logging data yang akan dikirim
        print('Data yang dikirim: ${updatedProduk.toJson()}');

        // Mengirim PUT request ke API
        var response = await Dio().put(
          apiUrl,
          data: updatedProduk.toJson(),
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
            validateStatus: (status) {
              return status! < 500; // Tangani status kode di bawah 500
            },
          ),
        );

        if (response.statusCode == 200 || response.statusCode == 204) {
          // Jika berhasil, tampilkan notifikasi dan kembali ke halaman sebelumnya dengan hasil true
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Berhasil'),
                content: const Text('Produk diperbarui'),
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
        } else if (response.statusCode == 422) {
          // Jika ada kesalahan validasi, tampilkan pesan error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Gagal memperbarui produk: ${response.data}')),
          );
        } else {
          // Jika gagal, tampilkan pesan error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Gagal memperbarui produk: ${response.statusMessage}')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Produk'),
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
                    initialValue: _name,
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
                    initialValue: _price.toString(),
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
                    initialValue: _qty.toString(),
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
                    initialValue: _attr,
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
                    initialValue: _weight.toString(),
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
                  Container(
                    margin: const EdgeInsets.all(10),
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
                      child: const Text('Ubah',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
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
