import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutriscan/features/donation/utils/image_utils.dart';
import 'package:nutriscan/theme.dart';

class AddDonationPage extends StatefulWidget {
  const AddDonationPage({super.key});

  @override
  State<AddDonationPage> createState() => _AddDonationPageState();
}

class _AddDonationPageState extends State<AddDonationPage> {
  Uint8List? _image;
  bool _isLoading = false;

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _phone = TextEditingController();
  final _location = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Tambah Donasi',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        shape: Border(
            bottom: BorderSide(
          color: graySecond,
          width: 0.5,
        )),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  selectImage();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: primary, width: _image != null ? 1.5 : 0)),
                  height: 200,
                  width: double.infinity,
                  child: _image != null
                      ? Image.memory(
                          _image!,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 40,
                              color: primary,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Tambahkan Gambar",
                              style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ],
                        )),
                ),
              )
            ],
          )),
    ));
  }
}
