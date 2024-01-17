import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nutriscan/features/donation/domain/donation_model.dart';
import 'package:nutriscan/theme.dart';
import 'package:geocoding/geocoding.dart';
import 'package:clipboard/clipboard.dart';

class DonationDetailPage extends StatefulWidget {
  final DonationModel donation;

  const DonationDetailPage({super.key, required this.donation});

  @override
  State<DonationDetailPage> createState() => _DonationDetailPageState();
}

class _DonationDetailPageState extends State<DonationDetailPage> {
  late GoogleMapController _googleMapController;
  late CameraPosition _initialCamPosition;
  late Marker _origin;
  late Marker _destination;
  String placeName = "";
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _origin = Marker(
      markerId: const MarkerId("origin"),
      position: LatLng(widget.donation.latitude, widget.donation.longitude),
      infoWindow: const InfoWindow(title: "Tujuan"),
      icon: BitmapDescriptor.defaultMarker,
    );

    _initialCamPosition = CameraPosition(
        target: LatLng(widget.donation.latitude, widget.donation.longitude),
        zoom: 14.5);

    _controller.addListener(_onChanged);

    initPlaceName();
  }

  void _onChanged() {
    final currentSize = _controller.size;
    // if (currentSize <= 0.05) _collapse();
  }

  // void _collapse() => _animateSheet(sheet.snapSizes!.first);

  void _anchor() => _animateSheet(sheet.snapSizes!.last);

  void _expand() => _animateSheet(sheet.maxChildSize);

  void _hide() => _animateSheet(sheet.minChildSize);

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  Future<void> initPlaceName() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          widget.donation.latitude, widget.donation.longitude);
      setState(() {
        placeName = placemarks.first.street != ""
            ? ("${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}")
            : "Unknown Place";
      });
      // For now, using a placeholder value
      // Print the place name to the console
    } catch (e) {
      print("Error getting place name: $e");
    }
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    _controller.dispose();
    super.dispose();
  }

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialCamPosition,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (controller) => _googleMapController = controller,
              markers: {
                _origin,
                if (false) _destination,
              },
            ),
            Positioned(
              top: 16.0,
              left: 16.0,
              right: 16.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      "Set Your Location",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: primary),
                    ),
                  ),
                ],
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return DraggableScrollableSheet(
                  key: _sheet,
                  initialChildSize: 0.24,
                  maxChildSize: 0.6,
                  shouldCloseOnMinExtent: false,
                  minChildSize: 0,
                  expand: true,
                  snap: true,
                  snapSizes: [
                    60 / constraints.maxHeight,
                    0.5,
                  ],
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          // Text("halo")
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              child: Column(children: [
                                Center(
                                  child: Container(
                                    height: 5,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: graySecond,
                                        borderRadius: BorderRadius.circular(6)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 80.0, // Fixed width for the image
                                      height:
                                          80.0, // Fixed height for the image
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          widget.donation.image,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            16.0), // Add space between image and text
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.donation.title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            placeName != "" ? placeName : "-",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: gray),
                                          ),
                                          // Add more Text widgets or other UI elements as needed
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  height: 2,
                                  color: graySecond,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: TextButton(
                                      onPressed: () async {},
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      child: const Text(
                                        'Kirimkan Request',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Center(
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: TextButton(
                                      onPressed: () async {
                                        try {
                                          await FlutterClipboard.copy(
                                              widget.donation.phone);
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              content:
                                                  Text("Nomor telepon disalin"),
                                              backgroundColor: primary,
                                              margin: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height -
                                                      155,
                                                  left: 10,
                                                  right: 10),
                                            ),
                                          );
                                        } catch (e) {}
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color:
                                                primary), // Set the border color to primary
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.copy,size: 18, color: primary,),
                                          SizedBox(width: 8,),
                                          Text(
                                            'Hubungi Pendonasi ${widget.donation.phone}',
                                            style: TextStyle(
                                              color:
                                                  primary, // Set the text color to primary
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          foregroundColor: primary,
          onPressed: () {
            _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(_initialCamPosition),
            );
          },
          child: const Icon(Icons.center_focus_strong_rounded),
        ),
      ),
    );
  }
}





            // DraggableScrollableSheet(
            //   key: _sheet,
            //   snap: true,
            //   expand: true,
            //   snapSizes: [0.5],
            //   controller: _controller,
            //   initialChildSize: 0.2,
            //   maxChildSize: 1.0,
            //   minChildSize: 0.1,
            //   builder:
            //       (BuildContext context, ScrollController scrollController) {
            //     return Container(
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: const BorderRadius.only(
            //           topLeft: Radius.circular(20.0),
            //           topRight: Radius.circular(20.0),
            //         ),
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.grey.withOpacity(0.5),
            //             spreadRadius: 5,
            //             blurRadius: 7,
            //             offset: Offset(0, 3),
            //           ),
            //         ],
            //       ),
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(
            //             vertical: 12, horizontal: 20),
            //         child: Column(children: [
            //           Center(
            //             child: Container(
            //               height: 5,
            //               width: 200,
            //               decoration: BoxDecoration(
            //                   color: graySecond,
            //                   borderRadius: BorderRadius.circular(6)),
            //             ),
            //           ),
            //           const SizedBox(
            //             height: 32,
            //           ),
            //           Row(
            //             children: [
            //               SizedBox(
            //                 width: 80.0, // Fixed width for the image
            //                 height: 80.0, // Fixed height for the image
            //                 child: ClipRRect(
            //                   borderRadius: BorderRadius.circular(8.0),
            //                   child: Image.network(
            //                     widget.donation.image,
            //                     width: double.infinity,
            //                     height: double.infinity,
            //                     fit: BoxFit.cover,
            //                   ),
            //                 ),
            //               ),
            //               const SizedBox(
            //                   width: 16.0), // Add space between image and text
            //               Expanded(
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       widget.donation.title,
            //                       style: const TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 20.0),
            //                     ),
            //                     SizedBox(
            //                       height: 4,
            //                     ),
            //                     Text(
            //                       placeName,
            //                       style: TextStyle(
            //                           fontWeight: FontWeight.w500, color: gray),
            //                     ),
            //                     // Add more Text widgets or other UI elements as needed
            //                     SizedBox(
            //                       height: 12,
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ),
            //           Divider(
            //             height: 3,
            //             color: gray,
            //           ),
            //           SizedBox(
            //             height: 12,
            //           ),
            //         ]),
            //       ),
            //       // child: ListView.builder(
            //       //   controller: scrollController,
            //       //   itemCount: 10, // Change this as needed
            //       //   itemBuilder: (BuildContext context, int index) {
            //       //     // Add your content for the bottom sheet here
            //       //     return ListTile(
            //       //       title: Text('Item $index'),
            //       //     );
            //       //   },
            //       // ),
            //     );
            //   },
            // ),
