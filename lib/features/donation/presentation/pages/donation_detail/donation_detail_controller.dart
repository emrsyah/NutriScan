import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nutriscan/features/donation/data/donation_repository.dart';
import 'package:nutriscan/features/donation/presentation/providers/donation_repository_providers.dart';
import 'package:nutriscan/theme.dart';

class DonationDetailState {
  // Define the state properties if needed
}

class DonationDetailController extends StateNotifier<DonationDetailState> {
  final DonationRepository _donationRepository;

  DonationDetailController(this._donationRepository)
      : super(DonationDetailState());

  Future<void> sendDonationRequest(BuildContext context, String docId,
      List<dynamic> currentRequests, dynamic requesterData) async {
    try {
      await _donationRepository.sendFoodRequest(
          docId, currentRequests, requesterData);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Berhasil mengirim request"),
          backgroundColor: primary,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 155,
              left: 10,
              right: 10),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Gagal mengirim request"),
          backgroundColor: Colors.red,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 155,
              left: 10,
              right: 10),
        ),
      );
    }
  }

// CREATED AT REQUEST
  Future<void> createNewDonation(BuildContext context, String userId,
      String title, LatLng location, String phone, Uint8List image) async {
    try {
      await _donationRepository.createNewDonation(
          userId, title, location, phone, image);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Berhasil menambahkan data"),
          backgroundColor: primary,
        ),
      );
      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Gagal menambahkan data"),
          backgroundColor: Colors.red,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 155,
              left: 10,
              right: 10),
        ),
      );
    }
  }
}

final donationDetailControllerProvider =
    StateNotifierProvider<DonationDetailController, DonationDetailState>(
  (ref) => DonationDetailController(ref.read(donationRepositoryProvider)),
);
