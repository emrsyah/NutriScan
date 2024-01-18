import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nutriscan/features/donation/data/directions_repository.dart';
import 'package:nutriscan/features/donation/domain/directions_model.dart';
import 'package:nutriscan/features/donation/presentation/pages/donation_controller.dart';
import 'package:nutriscan/features/donation/presentation/pages/donation_detail/donation_detail_page.dart';
import 'package:nutriscan/features/donation/utils/gmaps_utils.dart';
import 'package:nutriscan/features/foods/presentation/pages/common_widget/BottomNavigation.dart';
import 'package:nutriscan/theme.dart';
import 'dart:math';

class DonationPage extends ConsumerStatefulWidget {
  const DonationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DonationPageState();
}

class _DonationPageState extends ConsumerState<DonationPage> {
  late Position _currentPosition;
  bool _isLocationSet = false;
  late String _currentAddress;

  Future<void> _getCurrentPosition() async {
    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) return;
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      setState(() {
        _currentAddress = placemarks.first.street != ""
            ? ("${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}")
            : "Unknown Place";
        _currentPosition = position;
        _isLocationSet = true;
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultAsyncValue = ref.watch(FindDonationProvider(""));
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Text(
            "Donasi Makananmu 🥫",
            style:
                TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
          ),
          shape: Border(
              bottom: BorderSide(
            color: graySecond,
            width: 0.5,
          ))),
      body: Padding(
          padding: EdgeInsets.all(20.0),
          child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                      labelPadding: EdgeInsets.zero,
                      indicatorColor: Colors.transparent,
                      dividerColor: Colors.transparent,
                      unselectedLabelColor: Colors.black54,
                      labelStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                      labelColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: primary,
                          border: Border.all(width: 0)),
                      tabs: const [
                        Tab(
                            child: Align(
                          alignment: Alignment.center,
                          child: Text("Find"),
                        )),
                        Tab(
                            child: Align(
                          alignment: Alignment.center,
                          child: Text("Provide"),
                        )),
                      ]),
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: TabBarView(children: [
                        // FIND DONATION
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 12),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color:
                                      _isLocationSet ? primary : Colors.white,
                                  border: softBorder,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _isLocationSet
                                          ? _currentAddress
                                          : "Lokasi belum ditentukan",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: _isLocationSet
                                              ? Colors.white
                                              : Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _getCurrentPosition();
                                    },
                                    child: Text(
                                      _isLocationSet
                                          ? "Lokasi Menyala"
                                          : "Set Lokasi",
                                      style: TextStyle(
                                          color: _isLocationSet
                                              ? Colors.white
                                              : primary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            resultAsyncValue.when(
                              data: (data) {
                                if (data.isNotEmpty) {
                                  return Expanded(
                                      child: ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      final donation = data[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DonationDetailPage(
                                                        donation: donation,
                                                        previousPosition:
                                                            _isLocationSet
                                                                ? _currentPosition
                                                                : null,
                                                      )));
                                        },
                                        child: Card(
                                            surfaceTintColor: Colors.white,
                                            color: const Color.fromRGBO(
                                                255, 255, 255, 1),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: double.infinity,
                                                  height: 180.0,
                                                  child: Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        6),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        6)),
                                                        child: Image.network(
                                                          donation.image ??
                                                              "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/800px-Image_not_available.png?20210219185637",
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: 12.0,
                                                        top: 12.0,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  100.0), // Adjust the radius as needed
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                border:
                                                                    softBorder,
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  softDrop
                                                                ]),
                                                            // color: Colors.white,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        12),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Icon(Icons
                                                                    .location_on_outlined),
                                                                SizedBox(
                                                                  width: 6,
                                                                ),
                                                                FutureBuilder<
                                                                    String>(
                                                                  future: _isLocationSet
                                                                      ? getFoodDirections(
                                                                          _currentPosition
                                                                              .latitude,
                                                                          _currentPosition
                                                                              .longitude,
                                                                          donation
                                                                              .latitude,
                                                                          donation
                                                                              .longitude,
                                                                        )
                                                                      : Future.value("- km"),
                                                                  builder: (context,
                                                                      AsyncSnapshot<
                                                                              String>
                                                                          snapshot) {
                                                                    return Text(
                                                                      snapshot.data ??
                                                                          "- km",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    );
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  child: Column(
                                                    // mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        donation.title,
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      // ! NANTI KALO SEMPAT TAMBAHIN STATUS AMAN KONSUMSI
                                                      FutureBuilder(
                                                        future: getPlaceName(
                                                            donation.latitude,
                                                            donation.longitude),
                                                        builder: (context,
                                                            AsyncSnapshot<
                                                                    String>
                                                                snapshot) {
                                                          switch (snapshot
                                                              .connectionState) {
                                                            case ConnectionState
                                                                  .none:
                                                              return const Text(
                                                                  'Press button to start.');
                                                            case ConnectionState
                                                                  .active:
                                                            case ConnectionState
                                                                  .waiting:
                                                              return const Text(
                                                                  'Awaiting result...');
                                                            case ConnectionState
                                                                  .done:
                                                              if (snapshot
                                                                  .hasError) {
                                                                return Text(
                                                                    'Error: ${snapshot.error}');
                                                              }
                                                              return Text(snapshot
                                                                      .data ??
                                                                  'No place name available');
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                      );
                                    },
                                  ));
                                } else {
                                  return const Text("Tak ada data Donasi");
                                }
                              },
                              loading: () {
                                return const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: CircularProgressIndicator(),
                                ));
                              },
                              error: (error, stack) {
                                return Text('Error: $error');
                              },
                            )
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: (){
                                context.pushNamed("add-donation");
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 12),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border.all(color: primary, width: 1),
                                    borderRadius: BorderRadius.circular(6)),
                                child:  Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, size:24, color: primary,),
                                    SizedBox(width:8 ,),
                                    Text("Tambah Donasi", style: TextStyle(color: primary, fontWeight: FontWeight.w500, fontSize: 16),)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // ColoredBox(color: color)
                      ]),
                    ),
                  )
                ],
              ))),
      bottomNavigationBar: const BottomNavigation(idx: 3),
    ));
  }
}

Future<String> getPlaceName(lat, long) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    String placeName = placemarks.first.street != ""
        ? ("${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}")
        : "Unknown Place";
    return placeName;
    // For now, using a placeholder value
    // Print the place name to the console
  } catch (e) {
    print("Error getting place name: $e");
    return "Can't get place name";
  }
}

String calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return (12742 * asin(sqrt(a))).toStringAsFixed(2) + " km";
}

Future<String> getFoodDirections(lat1, lon1, lat2, lon2) async {
  Directions? directions = await DirectionsRepository().getDirections(
      origin: LatLng(lat1, lon1), destination: LatLng(lat2, lon2));
  return directions != null ? directions.totalDistance : "-";
}
