import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../models/sales.dart'; // Import model Sales
import '../../widgets/custom_widgets.dart'; // Import Custom Widgets

class EditSalesForm extends StatefulWidget {
  final Sales sales;

  const EditSalesForm({super.key, required this.sales});

  @override
  _EditSalesFormState createState() => _EditSalesFormState();
}

class _EditSalesFormState extends State<EditSalesForm> {
  final _formKey = GlobalKey<FormState>();
  late String _buyer;
  late String _phone;
  late String _date;
  late String _status;
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _buyer = widget.sales.buyer;
    _phone = widget.sales.phone;
    _date = widget.sales.date;
    _status = widget.sales.status;
    _dateController.text = _date;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Data yang akan dikirim ke API
      Sales updatedSales = Sales(
        id: widget.sales.id,
        buyer: _buyer,
        phone: _phone,
        date: _date,
        status: _status,
      );

      // Endpoint API
      String apiUrl = 'https://api.kartel.dev/sales/${widget.sales.id}';

      try {
        // Logging data yang akan dikirim
        print('Data yang dikirim: ${updatedSales.toJson()}');

        // Mengirim PUT request ke API
        var response = await Dio().put(
          apiUrl,
          data: updatedSales.toJson(),
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
                content: const Text('Sales diperbarui'),
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
                content: Text('Gagal memperbarui sales: ${response.data}')),
          );
        } else {
          // Jika gagal, tampilkan pesan error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal memperbarui sales: ${response.statusMessage}')),
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
      appBar: const CustomAppBar(title: 'Edit Sales'),
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
                    initialValue: _buyer,
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
                    initialValue: _phone,
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
                    initialValue: _status,
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
