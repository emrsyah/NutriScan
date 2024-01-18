import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutriscan/features/donation/domain/donation_model.dart';

class DonationRepository{
  final donationDb = FirebaseFirestore.instance.collection("donations");

  Future<List<DonationModel>> getDonations () async {
    var rawDonations = await donationDb.where("isOpen", isEqualTo: true).orderBy("created_at",descending: true).get();
    List<DonationModel> donations = rawDonations.docs.map((e) => DonationModel.fromMap({...e.data(), "id": e.id})).toList();
    return donations;
  }

  Future<void> sendFoodRequest(String docId, List<dynamic> currentRequests, dynamic requesterData) async {
    List<dynamic> newRequests = [...currentRequests, requesterData];
    await donationDb.doc(docId).update({
      "requests" : newRequests
    });
  }

}