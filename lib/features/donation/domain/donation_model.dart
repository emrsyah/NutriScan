// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DonationModel {
  final String id;
  final String title;
  final String user_id;
  final String image;
  final bool isOpen;
  final double latitude;
  final double longitude;
  final String phone;
  final List<dynamic> requests;
  final DateTime created_at;
  final bool? isFinish;
  DonationModel({
    required this.id,
    required this.title,
    required this.user_id,
    required this.image,
    required this.isOpen,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.requests,
    required this.created_at,
    required this.isFinish
  });

  DonationModel copyWith({
    String? id,
    String? title,
    String? user_id,
    String? image,
    bool? isOpen,
    bool? isFinish,
    double? latitude,
    double? longitude,
    String? phone,
    List<dynamic>? requests,
    DateTime? created_at,
  }) {
    return DonationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      user_id: user_id ?? this.user_id,
      image: image ?? this.image,
      isOpen: isOpen ?? this.isOpen,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      requests: requests ?? this.requests,
      created_at: created_at ?? this.created_at,
      isFinish: isFinish ?? this.isFinish,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'user_id': user_id,
      'image': image,
      'isOpen': isOpen,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'requests': requests,
      'created_at': created_at,
      'isFinish': isFinish,
    };
  }

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    double lat = (map["location"] as GeoPoint).latitude;
    double long = (map["location"] as GeoPoint).longitude;
    DateTime created = DateTime.parse(map['created_at'].toDate().toString());
    return DonationModel(
      id: map['id'] as String,
      title: map['title'] as String,
      user_id: map['user_id'] as String,
      image: map['image'] as String,
      isOpen: map['isOpen'] as bool,
      latitude: lat,
      longitude: long,
      phone: map['phone'] as String,
      created_at: created,
      requests: List<dynamic>.from(
          map['requests'] as List<dynamic>),
      isFinish: map["isFinish"] != null ? true : false // Fix the missing parenthesis
    );
  }

  String toJson() => json.encode(toMap());

  factory DonationModel.fromJson(String source) =>
      DonationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DonationModel(id: $id, created_at: $created_at,title: $title, user_id: $user_id, image: $image, isOpen: $isOpen, latitude: $latitude, longitude: $longitude, phone: $phone, requests: $requests, isFinish: $isFinish)';
  }

  @override
  bool operator ==(covariant DonationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.user_id == user_id &&
        other.image == image &&
        other.isOpen == isOpen &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.phone == phone &&
        other.created_at == created_at &&
        other.isFinish == isFinish &&
        listEquals(other.requests, requests);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        user_id.hashCode ^
        image.hashCode ^
        isOpen.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        phone.hashCode ^
        requests.hashCode ^
        isFinish.hashCode ^
        created_at.hashCode;
  }
}
