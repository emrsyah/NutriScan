import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutriscan/features/auth/presentation/auth_controller.dart';
import 'package:nutriscan/features/donation/presentation/pages/donation_detail/donation_detail_controller.dart';
import 'package:nutriscan/features/donation/utils/image_utils.dart';
import 'package:nutriscan/theme.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;

class AddDonationPage extends ConsumerStatefulWidget {
  const AddDonationPage({super.key});

  @override
  ConsumerState<AddDonationPage> createState() => _AddDonationPageState();
}

class _AddDonationPageState extends ConsumerState<AddDonationPage> {
  Uint8List? _image;
  bool _isLoading = false;

  double _lat = -6.914744;
  double _lon = 107.609810;
  String _address = "";
  bool _isLocationSet = false;

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
      resizeToAvoidBottomInset: false,
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Nama",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: 6,
                ),
                TextFormField(
                  controller: _title,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Isi nama makanan';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 0.7, color: graySecond),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 0.7, color: graySecond),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    hintText: 'Buah-buahan',
                    hintStyle:
                        TextStyle(color: gray, fontWeight: FontWeight.w400),

                    // hintStyle: emailHint,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Nomor Telepon",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: 6,
                ),
                TextFormField(
                  controller: _phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong isi nomor telepon';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 0.7, color: graySecond),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(width: 0.7, color: graySecond),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary)),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    hintText: '08xxx',
                    hintStyle:
                        TextStyle(color: gray, fontWeight: FontWeight.w400),

                    // hintStyle: emailHint,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Lokasi",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: 6,
                ),
                Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: softBorder,
                        borderRadius: BorderRadius.circular(6)),
                    child: TextButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlacePicker(
                              apiKey: Platform.isAndroid
                                  ? "AIzaSyBovpx2n8V3adrgQ-b3mWpQYKi9DmbnbTE"
                                  : "AIzaSyBovpx2n8V3adrgQ-b3mWpQYKi9DmbnbTE",
                              onPlacePicked: (result) {
                                setState(() {
                                  _lat = result.geometry != null ? result.geometry!.location.lat : -6.914744;
                                  _lon = result.geometry != null ? result.geometry!.location.lng : 107.609810;
                                  _address = result.name ?? "Lokasi Tanpa Nama";
                                  _isLocationSet = true;
                                });
                                Navigator.of(context).pop();
                              },
                              initialPosition: LatLng(-6.914744, 107.609810),
                              // initialPosition: HomePage.kInitialPosition,
                              useCurrentLocation: true,
                              resizeToAvoidBottomInset:
                                  false, // only works in page mode, less flickery, remove if wrong offsets
                            ),
                          ),
                        );
                      },
                      child: Text(
                        _address != "" ? _address :
                        "Pilih Lokasi",
                          style: TextStyle(
                              color: primary,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                    )),
                SizedBox(
                  height: 24,
                ),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            _isLoading == false && _isLocationSet && _image != null) {
                          setState(() {
                            _isLoading = true;
                          });
                          await ref.read(donationDetailControllerProvider.notifier).createNewDonation(
                            context,
                            ref.read(authControllerProvider).uid!,
                            _title.text,
                            LatLng(_lat, _lon),
                            _phone.text,
                            _image!
                          );
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Tambahkan Donasi',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    ));
  }
}
