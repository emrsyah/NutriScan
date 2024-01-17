import 'package:nutriscan/features/donation/data/donation_repository.dart';
import 'package:riverpod/riverpod.dart';

final donationRepositoryProvider = Provider<DonationRepository>((ref) {
  return DonationRepository();
});


