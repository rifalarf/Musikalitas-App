import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/sales.dart'; // Import model Sales
import '../../widgets/custom_widgets.dart'; // Import Custom Widgets

class addSales extends StatefulWidget {
  const addSales({super.key});

  @override
  _TambahSalesPageState createState() => _TambahSalesPageState();
}

class _TambahSalesPageState extends State<addSales> {
  final _formKey = GlobalKey<FormState>();
  String _buyer = '';
  String _phone = '';
  String _date = '';
  String _status = '';
  final TextEditingController _dateController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Buat objek Sales
      Sales sales = Sales(
        id: '', // ID akan dihasilkan oleh server
        buyer: _buyer,
        phone: _phone,
        date: _date,
        status: _status,
      );

      // Endpoint API
      String apiUrl = 'https://api.kartel.dev/sales';

      try {
        // Logging data yang akan dikirim
        print('Data yang dikirim: ${sales.toJson()}');

        // Mengirim POST request ke API
        var response = await Dio().post(
          apiUrl,
          data: sales.toJson(),
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
          // Jika berhasil, tampilkan notifikasi dan kembali ke halaman Sales Saya dengan hasil true
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Berhasil'),
                content: const Text('Sales ditambahkan'),
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
                    Text('Gagal untuk menambahsales: ${response.statusMessage}')),
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

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context)
        .requestFocus(FocusNode()); // Lepaskan fokus dari TextFormField
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _date = "${picked.toLocal()}".split(' ')[0];
        _dateController.text = _date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Tambah Sales'),
      backgroundColor: const Color.fromRGBO(220, 214, 247, 1), // Warna Scaffold
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(244, 238, 255, 1), // Warna latar belakang
              borderRadius: BorderRadius.circular(10), // Radius sudut
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Buyer'),
                    onSaved: (value) {
                      _buyer = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Buyer tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Phone'),
                    onSaved: (value) {
                      _phone = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(labelText: 'Date'),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    onSaved: (value) {
                      _date = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Status'),
                    onSaved: (value) {
                      _status = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Status tidak boleh kosong';
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
