import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriscan/features/donation/domain/donation_model.dart';
import 'package:nutriscan/features/donation/presentation/providers/donation_repository_providers.dart';

final FindDonationProvider =
    FutureProvider.family<List<DonationModel>, String>((ref, name) async {
  final donationRepository = ref.read(donationRepositoryProvider);
  // return mealRepository.getFoodsFromScan(name);
  return donationRepository.getDonations();
});

final FindMyDonationProvider =
    FutureProvider.family<List<DonationModel>, String>((ref, userId) async {
  final donationRepository = ref.read(donationRepositoryProvider);
  // return mealRepository.getFoodsFromScan(name);
  return donationRepository.getMyDonations(userId);
});
