import 'package:flutter/material.dart';
import 'package:lab_reservation_app/models/lab_model.dart';
import 'package:lab_reservation_app/widgets/lab_reservation.dart';

class LabDetailScreen extends StatelessWidget {
  final Lab lab;
  final Function(Lab) updateLabAvailability;

  LabDetailScreen({required this.lab, required this.updateLabAvailability});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lab Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/${lab.name.toLowerCase()}_image.png',
              width: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              'Lab Name: ${lab.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Lab Description: ${lab.desc}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ReservationScreen(lab, updateLabAvailability: updateLabAvailability),
                  ),
                );
              },
              child: Text('Book the Lab'),
            ),
          ],
        ),
      ),
    );
  }
}
