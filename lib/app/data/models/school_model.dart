class School {
  final String idSekolah;
  final String location;
  final String inTime;
  final String outTime;

  School({
    required this.idSekolah,
    required this.location,
    required this.inTime,
    required this.outTime,
  });

  factory School.fromJson(Map<String, dynamic> json) => School(
        idSekolah: json['idSekolah'].toString(),
        location: json['location'],
        inTime: json['inTime'],
        outTime: json['outTime'],
      );

  Map<String, dynamic> toJson() {
    return {
      'idSekolah': idSekolah,
      'location': location,
      'inTime': inTime,
      'outTime': outTime,
    };
  }
}
