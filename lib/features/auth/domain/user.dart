class Users {
  String? uid;
  String? name;
  String? email;
  Map<String, dynamic>? allergies;

  Users({
    this.uid,
    this.name,
    this.email,
    this.allergies
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      allergies: json['allergies']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'allergies': allergies
    };
  }

  Users copyWith({
    String? uid,
    String? name,
    String? email,
    Map<String, String>? allergies,
  }) {
    return Users(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        email: email ?? this.email,
        allergies: allergies ?? this.allergies);
  }
}