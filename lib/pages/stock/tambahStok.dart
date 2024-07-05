import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/stok.dart'; // Import model Stok
import '../../widgets/custom_widgets.dart'; // Import Custom Widgets

class AddStock extends StatefulWidget {
  const AddStock({super.key});

  @override
  _TambahStokPageState createState() => _TambahStokPageState();
}

class _TambahStokPageState extends State<AddStock> {
  final _formKey = GlobalKey<FormState>();
  String _nama = '';
  int _Jumlah = 0;
  String _atribut = '';
  double _berat = 0.0;
  String _issuer = '';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Buat objek Stok
      Stok stok = Stok(
        id: '', // ID akan dihasilkan oleh server
        name: _nama,
        qty: _Jumlah,
        attr: _atribut,
        weight: _berat,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        issuer: _issuer,
      );

      // Endpoint API
      String apiUrl = 'https://api.kartel.dev/stocks';

      try {
        // Logging data yang akan dikirim
        print('Data yang dikirim: ${stok.toJson()}');

        // Mengirim POST request ke API
        var response = await Dio().post(
          apiUrl,
          data: stok.toJson(),
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
          // Jika berhasil, tampilkan notifikasi dan kembali ke halaman Stok Saya dengan hasil true
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Berhasil'),
                content: const Text('Stok ditambahkan'),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal untuk menambahstok: ${response.statusMessage}')),
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
      appBar: const CustomAppBar(title: 'Tambah Stok'),
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
                      _nama = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Jumlah'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _Jumlah = int.parse(value!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah tidak boleh kosong';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Jumlah harus berupa angka';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Atribut'),
                    onSaved: (value) {
                      _atribut = value!;
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
                      _berat = double.parse(value!);
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
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Penyedia'),
                    onSaved: (value) {
                      _issuer = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Penyedia tidak boleh kosong';
                      }
                      return null;
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
