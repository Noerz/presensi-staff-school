import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final Function(DateTime) onDateSelected;

  const DateSelector({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Tanggal",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        // ElevatedButton.icon(
        //   onPressed: () async {
        //     final DateTime? selectedDate = await showDatePicker(
        //       context: context,
        //       initialDate: DateTime.now(),
        //       firstDate: DateTime(2000),
        //       lastDate: DateTime(2100),
        //     );
        //     if (selectedDate != null) {
        //       onDateSelected(selectedDate);
        //     }
        //   },
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: const Color(0xFF5E348E),
        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        //   ),
        //   icon: const Icon(Icons.calendar_today, size: 16),
        //   label: const Text("Pilih"),
        // ),
      ],
    );
  }
}
