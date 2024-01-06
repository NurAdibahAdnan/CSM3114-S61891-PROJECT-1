import 'package:flutter/material.dart';
import 'package:lab_reservation_app/data/dummy_lab.dart';
import 'package:lab_reservation_app/data/dummy_reservation.dart';
import 'package:lab_reservation_app/models/lab_model.dart';
import 'package:lab_reservation_app/models/reservation_model.dart';
import 'package:lab_reservation_app/widgets/lab_detail.dart';
import 'package:lab_reservation_app/widgets/reserved_lab_list.dart';

class LabList extends StatefulWidget {
  const LabList({Key? key}) : super(key: key);

  @override
  _LabListState createState() => _LabListState();
}

class _LabListState extends State<LabList> {
  final GlobalKey<_LabListState> labListKey = GlobalKey<_LabListState>();

  //method to update lab availability
  void updateLabAvailability(Lab lab) {
    setState(() {
      lab.isAvailable = false;
    });
  }

  //method to show lab details
  void _viewLabDetails(Lab lab) {
    if (lab.isAvailable) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) =>
              LabDetailScreen(lab: lab, updateLabAvailability: updateLabAvailability),
        ),
      );
    } else {
      _showLabNotAvailableDialog(context);
    }
  }

  //method to delete the reservation 
  void deleteReservation(Reservation reservation) async {
    setState(() {
      reservation.lab.updateAvailability(true); // Set availability back to true
      reservations.remove(reservation);
    });

    // Wait for the UI to update before navigating back to LabList
    await Future.delayed(Duration.zero);
    print('#Debug delete reservations');

    // Pop ReservedListPage
    Navigator.pop(context);
    print('#Debug Pop test');

    // Push LabList again to trigger a rebuild
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LabList()),
    );
  }

  //method to show alert message 'Lab is not Available'
  void _showLabNotAvailableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lab Not Available'),
          content: Text('This lab is not available for second reservation.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Computer Labs at FTKKI'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: labs.length,
              itemBuilder: (ctx, index) => ListTile(
                title: Text(labs[index].name),
                subtitle: Text('Capacity: ${labs[index].capacity}'),
                trailing: labs[index].isAvailable
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Icon(Icons.cancel, color: Colors.red),
                onTap: () {
                  _viewLabDetails(labs[index]);
                },
              ),
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReservedListPage(reservations, deleteReservation)),
              );
            },
            child: Text('View Reserved Labs'),
          ),
        ],
      ),
    );
  }
}
