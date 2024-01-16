// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FoodScanModel {
  final int id;
  final String upcId;
  final String title;
  final String image;
  final String imageType;

  FoodScanModel({
    required this.id,
    required this.upcId,
    required this.title,
    required this.image,
    required this.imageType,
  });


  FoodScanModel copyWith({
    int? id,
    String? upcId,
    String? title,
    String? image,
    String? imageType,
  }) {
    return FoodScanModel(
      id: id ?? this.id,
      upcId: upcId ?? this.upcId,
      title: title ?? this.title,
      image: image ?? this.image,
      imageType: imageType ?? this.imageType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'upcId': upcId,
      'title': title,
      'image': image,
      'imageType': imageType,
    };
  }

  factory FoodScanModel.fromMap(Map<String, dynamic> map) {
    return FoodScanModel(
      id: map['id'] as int,
      upcId: map['_id'] as String,
      title: map['title'] as String,
      image: map['image'] as String,
      imageType: map['imageType'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodScanModel.fromJson(String source) => FoodScanModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FoodScanModel(id: $id, upcId: $upcId, title: $title, image: $image, imageType: $imageType)';
  }

  @override
  bool operator ==(covariant FoodScanModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.upcId == upcId &&
      other.title == title &&
      other.image == image &&
      other.imageType == imageType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      upcId.hashCode ^
      title.hashCode ^
      image.hashCode ^
      imageType.hashCode;
  }
}
