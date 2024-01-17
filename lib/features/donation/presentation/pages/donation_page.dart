import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriscan/features/donation/presentation/pages/donation_controller.dart';
import 'package:nutriscan/features/foods/presentation/pages/common_widget/BottomNavigation.dart';
import 'package:nutriscan/theme.dart';

class DonationPage extends ConsumerWidget {
  const DonationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  SizedBox(
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
                                  border: softBorder,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Lokasi: Margacinta, Bandung"),
                                  TextButton(
                                      onPressed: () {}, child: Text("Ganti"))
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
                                      return Card(
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
                                                                  .circular(6),
                                                              topLeft: Radius
                                                                  .circular(6)),
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
                                                          color: Colors.white,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 6,
                                                                  horizontal:
                                                                      12),
                                                          child: const Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Icon(Icons
                                                                  .location_on_outlined),
                                                              SizedBox(
                                                                width: 6,
                                                              ),
                                                              Text(
                                                                "- km",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                child: Column(
                                                  // mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      donation.title,
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  // ! NANTI KALO SEMPAT TAMBAHIN STATUS AMAN KONSUMSI
                                                  ],
                                                ),
                                              )
                                            ],
                                          ));
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
                        // Column(),
                        Text("data2")
                      ]),
                    ),
                  )
                ],
              ))),
      bottomNavigationBar: const BottomNavigation(idx: 3),
    ));
  }
}
