import 'package:flutter/material.dart';

class AttendanceCard extends StatelessWidget {
  final String date;
  final String subject;
  final String timeIn;
  final String timeOut;
  final String status;

  const AttendanceCard({
    Key? key,
    required this.date,
    required this.subject,
    required this.timeIn,
    required this.timeOut,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Mata Pelajaran, $subject'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Jam Masuk: ${timeIn.substring(timeIn.length - 8)}'),
                Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      timeOut,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Keterangan, $status', style: TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}