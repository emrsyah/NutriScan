import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nutriscan/features/donation/domain/donation_model.dart';
import 'package:uuid/uuid.dart';

class DonationRepository {
  final donationDb = FirebaseFirestore.instance.collection("donations");
  final acceptedRequestDb = FirebaseFirestore.instance.collection("accepted_requests");
  final donationStorage = FirebaseStorage.instance.ref().child("donations");

  Future<List<DonationModel>> getDonations() async {
    var rawDonations = await donationDb
        .where("isOpen", isEqualTo: true)
        .orderBy("created_at", descending: true)
        .get();
    List<DonationModel> donations = rawDonations.docs
        .map((e) => DonationModel.fromMap({...e.data(), "id": e.id}))
        .toList();
    return donations;
  }

  Future<List<DonationModel>> getMyDonations(String user_id) async {
    var rawDonations = await donationDb
        .where("isOpen", isEqualTo: true)
        .where("user_id", isEqualTo: user_id)
        .orderBy("created_at", descending: true)
        .get();
    List<DonationModel> donations = rawDonations.docs
        .map((e) => DonationModel.fromMap({...e.data(), "id": e.id}))
        .toList();
    return donations;
  }

  Future<DonationModel> getMyDonationDetail(String id) async {
    var rawDonation = await donationDb.doc(id).get();
    DonationModel transformedDonation =
        DonationModel.fromMap({...?rawDonation.data(), "id": id});
    return transformedDonation;
  }

  Future<void> sendFoodRequest(String docId, List<dynamic> currentRequests,
      dynamic requesterData) async {
    // Modify the requesterData by adding a new field
    Map<String, dynamic> modifiedRequesterData = {
      ...requesterData,
      "created_at": DateTime.now(), // Add your new field and value here
    };

    List<dynamic> newRequests = [...currentRequests, modifiedRequesterData];

    // Update the document with the newRequests list
    await donationDb.doc(docId).update({"requests": newRequests});
  }

  Future<void> acceptRequest(String donation_id, String provider_id,
      String receiver_id, DonationModel donation_data) async {

    // print("halo masuk sini");

    // Update
    await donationDb.doc(donation_id).update({
      "isFinish" : false,
      "isOpen" : false
    });

    // Add Accepted
    await acceptedRequestDb.add({
      "donation_id": donation_id,
      "provider_id": provider_id,
      "receiver_id": receiver_id,
      "donation_data": {
        "user_id" : donation_data.user_id,
        "title" :donation_data.title,
        "location" : GeoPoint(donation_data.latitude, donation_data.longitude),
        "phone" : donation_data.phone,
        "image" : donation_data.image
      },
      "created_at": FieldValue.serverTimestamp(),
      "status": "NOT ACCEPTED"
    });
    // await _donationRepository.
  }

  Future<void> createNewDonation(String userId, String title, LatLng location,
      String phone, Uint8List image) async {
    String downloadUrl = await uploadDonationImage(image);
    await donationDb.add({
      "created_at": FieldValue.serverTimestamp(),
      "image": downloadUrl,
      "isOpen": true,
      "location": GeoPoint(location.latitude, location.longitude),
      "phone": phone,
      "requests": [],
      "title": title,
      "user_id": userId
    });
  }

  Future<String> uploadDonationImage(Uint8List image) async {
    try {
      var uuid = Uuid().v4();
      Reference ref = donationStorage.child(uuid);
      UploadTask uploadTask = ref.putData(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print("Error uploading image: $error");
      // Handle the error as needed, e.g., show a message to the user.
      return ""; // You might want to return a default or error URL here.
    }
  }
}
