class Users {
  String? uid;
  String? name;
  String? email;

  Users({
    this.uid,
    this.name,
    this.email,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  Users copyWith({
    String? uid,
    String? name,
    String? email,
  }) {
    return Users(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}