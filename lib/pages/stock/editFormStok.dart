import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/stok.dart'; // Import model Stok
import '../../widgets/custom_widgets.dart'; // Import Custom Widgets

class EditStockForm extends StatefulWidget {
  final Stok stok;

  const EditStockForm({super.key, required this.stok});

  @override
  _EditStokFormState createState() => _EditStokFormState();
}

class _EditStokFormState extends State<EditStockForm> {
  final _formKey = GlobalKey<FormState>();
  late String _nama;
  late int _Jumlah;
  late String _atribut;
  late double _berat;
  late String _issuer;

  @override
  void initState() {
    super.initState();
    _nama = widget.stok.name;
    _Jumlah = widget.stok.qty;
    _atribut = widget.stok.attr;
    _berat = widget.stok.weight;
    _issuer = widget.stok.issuer;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Data yang akan dikirim ke API
      Stok updatedStok = Stok(
        id: widget.stok.id,
        name: _nama,
        qty: _Jumlah,
        attr: _atribut,
        weight: _berat,
        createdAt: widget.stok.createdAt,
        updatedAt: DateTime.now(),
        issuer: _issuer,
      );

      // Endpoint API
      String apiUrl = 'https://api.kartel.dev/stocks/${widget.stok.id}';

      try {
        // Logging data yang akan dikirim
        print('Data yang dikirim: ${updatedStok.toJson()}');

        // Mengirim PUT request ke API
        var response = await Dio().put(
          apiUrl,
          data: updatedStok.toJson(),
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
                content: const Text('Stok diperbarui'),
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
            SnackBar(content: Text('Gagal memperbarui stok: ${response.data}')),
          );
        } else {
          // Jika gagal, tampilkan pesan error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal memperbarui stok: ${response.statusMessage}')),
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
      appBar: const CustomAppBar(title: 'Edit Stok'),
      backgroundColor: const Color.fromRGBO(235, 244, 246, 1), // Warna Scaffold
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
                    initialValue: _nama,
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
                    initialValue: _Jumlah.toString(),
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
                    initialValue: _atribut,
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
                    initialValue: _berat.toString(),
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
                    initialValue: _issuer,
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
                    margin: const EdgeInsets.all(0),
                    child: SizedBox(
                      width: 100,
                      height: 70,
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
