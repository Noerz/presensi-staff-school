import 'package:flutter/material.dart';

class StaffInfoCard extends StatelessWidget {
  final String nip;
  final String name;
  // final String gender;

  const StaffInfoCard({
    Key? key,
    required this.nip,
    required this.name,
    // required this.gender, 
    required String position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          columnWidths: const {
            0: IntrinsicColumnWidth(), // Kolom label memiliki ukuran sesuai teks
            1: FixedColumnWidth(10),  // Memberikan jarak tetap untuk titik dua
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            _buildTableRow("NIP", nip),
            _buildDividerRow(),
            _buildTableRow("Nama", name),
            _buildDividerRow(),
            // _buildTableRow("Gender", gender),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuat baris tabel
  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Text(
          ":", // Titik dua dengan posisi tetap
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // Fungsi untuk membuat garis pembatas di antara baris
  TableRow _buildDividerRow() {
    return TableRow(
      children: [
        const SizedBox(height: 8),
        const SizedBox(height: 8),
        Divider(
          thickness: 1,
          color: Colors.grey[300],
          height: 16,
        ),
      ],
    );
  }
}
