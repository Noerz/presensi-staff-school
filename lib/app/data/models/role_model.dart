class Role {
  final String idRole;
  final String nama;
  final int code;

  Role({
    required this.idRole,
    required this.nama,
    required this.code,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      idRole: json['idRole'] ?? '',
      nama: json['nama'] ?? '',
      code: json['code'] ?? '',
    );
  }

  toJson() {}
}