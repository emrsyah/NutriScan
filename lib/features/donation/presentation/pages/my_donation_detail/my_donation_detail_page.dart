import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dice_bear/dice_bear.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriscan/features/auth/presentation/auth_controller.dart';
import 'package:nutriscan/features/donation/presentation/pages/my_donation_detail/my_donation_detail_controller.dart';
import 'package:nutriscan/theme.dart';
import 'package:intl/intl.dart';

class MyDonationDetailPage extends ConsumerWidget {
  const MyDonationDetailPage({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultAsyncValue = ref.watch(MyDonationDetailProvider(id));
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Detail Produk',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          centerTitle: true,
          shape: Border(
            bottom: BorderSide(
              color: graySecond,
              width: 0.5,
            ),
          ),
        ),
        body: resultAsyncValue.when(
          loading: () {
            return const Center(child: CircularProgressIndicator());
          },
          data: (data) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [softDrop],
                          border: softBorder,
                        ),
                        child: Image.network(
                          data.image,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Center(
                      child: Text(
                        data.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: softBorder),
                      child: Text(
                        data.requests.isNotEmpty
                            ? '${data.requests.length} Request Masuk'
                            : 'Belum Ada Request',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Request Masuk",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          data.requests.isNotEmpty
                              ? Column(
                                  children: List.generate(
                                    data.requests.length,
                                    (index) {
                                      Map<String, dynamic> request =
                                          data.requests[index];
                                      return Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: softBorder,
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        child: Container(
                                                          width: 64,
                                                          height: 64,
                                                          decoration:
                                                              BoxDecoration(
                                                            boxShadow: [
                                                              softDrop
                                                            ],
                                                            border: softBorder,
                                                          ),
                                                          child:
                                                              DiceBearBuilder(
                                                            sprite:
                                                                DiceBearSprite
                                                                    .bigSmile,
                                                            seed: request[
                                                                "user_id"],
                                                          ).build().toImage(),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            request["name"],
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 1,
                                                          ),
                                                          Text(formatTimestamp(
                                                              request[
                                                                  "created_at"])),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      await ref
                                                          .read(
                                                              myDonationDetailControllerProvider
                                                                  .notifier)
                                                          .acceptRequest(
                                                              context,
                                                              data.id,
                                                              ref
                                                                  .read(
                                                                      authControllerProvider)
                                                                  .uid!,
                                                              request[
                                                                  "user_id"],
                                                              data);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8,
                                                              horizontal: 16),
                                                      decoration: BoxDecoration(
                                                        color: primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      child: const Text(
                                                        "Terima",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    "Belum ada request",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: gray,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          error: (error, stack) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Terjadi Kesalahan: $error',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600, color: gray),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

String formatTimestamp(Timestamp timestamp) {
  DateTime converted = timestamp.toDate();
  DateTime now = DateTime.now();
  Duration difference = now.difference(converted);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else {
    // Use intl package for more advanced formatting
    return DateFormat.yMMMd().format(converted);
  }
}
