// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? idUser;
  String? nama;
  dynamic nip;
  dynamic gender;
  final int? roleCode;
  final String? accessToken;
  String? noHp;
  String? alamat;
  String? image;
  dynamic jabatan;
  String? authId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  Auth? auth;

  User({
     this.idUser,
     this.nama,
     this.nip,
     this.gender,
     this.noHp,
     this.alamat,
     this.image,
     this.jabatan,
     this.authId,
     this.status,
     this.createdAt,
     this.updatedAt,
     this.auth,
    this.roleCode,
    this.accessToken,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    idUser: json["idUser"],
    nama: json["nama"],
    nip: json["nip"],
    gender: json["gender"],
    noHp: json["noHp"],
    alamat: json["alamat"],
    image: json["image"],
    jabatan: json["jabatan"],
    authId: json["auth_id"],
    status: json["status"],
    roleCode: json["roleCode"],
    accessToken: json["accessToken"],
    createdAt: json["createdAt"] != null ? DateTime.tryParse(json["createdAt"]) : null,
    updatedAt: json["updatedAt"] != null ? DateTime.tryParse(json["updatedAt"]) : null,
    auth: json["auth"] != null ? Auth.fromJson(json["auth"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "idUser": idUser,
    "nama": nama,
    "nip": nip,
    "gender": gender,
    "noHp": noHp,
    "alamat": alamat,
    "image": image,
    "jabatan": jabatan,
    "auth_id": authId,
    "status": status,
    "roleCode": roleCode,
    "accessToken": accessToken,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "auth": auth?.toJson(),
  };
}

class Auth {
  String email;

  Auth({required this.email});

  factory Auth.fromJson(Map<String, dynamic> json) =>
      Auth(email: json["email"]);

  Map<String, dynamic> toJson() => {"email": email};
}
