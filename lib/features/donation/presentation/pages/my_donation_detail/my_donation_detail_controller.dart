import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriscan/features/donation/data/donation_repository.dart';
import 'package:nutriscan/features/donation/domain/donation_model.dart';
import 'package:nutriscan/features/donation/presentation/providers/donation_repository_providers.dart';
import 'package:nutriscan/theme.dart';

final MyDonationDetailProvider =
    FutureProvider.family<DonationModel, String>((ref, id) async {
  final donationRepository = ref.read(donationRepositoryProvider);
  return donationRepository.getMyDonationDetail(id);
});

class MyDonationDetailState {
  // Define the state properties if needed
}

class MyDonationDetailController extends StateNotifier<MyDonationDetailState> {
  final DonationRepository _donationRepository;

  MyDonationDetailController(this._donationRepository)
      : super(MyDonationDetailState());

  Future<void> acceptRequest(
      BuildContext context,
      String donation_id,
      String provider_id,
      String receiver_id,
      DonationModel donation_data) async {
    try {
      // print(donation_id);
      // print(provider_id);
      // print(receiver_id);
      // print(donation_data.phone);
      await _donationRepository.acceptRequest(
          donation_id, provider_id, receiver_id, donation_data);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Berhasil menerima request"),
          backgroundColor: primary,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 155,
              left: 10,
              right: 10),
        ),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Gagal menerima request"),
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

final myDonationDetailControllerProvider = StateNotifierProvider(
    (ref) => MyDonationDetailController(ref.read(donationRepositoryProvider)));
